using Pkg
Pkg.update()
Pkg.add("PyPlot")
Pkg.add("ProgressBars")

using ProgressBars
using PyPlot
using Random

# Pushing current dir to import modules. 
push!(LOAD_PATH, "./src")
import NodeModule.Node, NodeModule.euclidean_distance, NodeModule.create_distance_matrix,
        FireflyModule.Firefly, FireflyModule.path_cost, FireflyModule.init_firefly_paths,
        FireflyModule.hamming_distance, FireflyModule.inversion_mutation, FireflyModule.move_firefly,
        FireflyModule.arc_distance, FireflyModule.generate_mutated_fireflies


function read_nodes(path::String)
    """Reading nodes from giving file path.
    """
    nodes = Node[]
    open(path) do f
        is_coords = false
        for line in eachline(f)
            if line == "EOF"
                break
            end
            if line[1] == '1' 
                is_coords = true
            end
            if is_coords
                line_vals = split(line)
                id = parse(Int16, line_vals[1])
                x_coord = parse(Float32, line_vals[2])
                y_coord = parse(Float32, line_vals[3])
                push!(nodes, Node(id, x_coord, y_coord))
            end
        end
    end
    return nodes
end


LIGHT_ABSORPTION_COEFF = 0.2
ATTRACTION_COEFF = 1
ITERATION_NUMBER = 75  
POPULATION_NUMBER = 200 
NUMBER_OF_MUTATION = 8

file_name = get(ENV, "TSP_FILE", nothing)
if file_name != nothing
    println("Reading from: ", file_name)
    nodes = read_nodes(file_name)
    distance_matrix = create_distance_matrix(nodes)
end

"""
f1 = Firefly(copy(nodes), -1.0)
f2 = Firefly(copy(nodes), -1.0)
init_firefly_paths([f1,f2], distance_matrix)

println("F1 cost: ", f1.cost, " F2 cost:", f2.cost)
if f1.cost > f2.cost
    new_pop = generate_mutated_fireflies(f2, arc_distance(f1, f2), NUMBER_OF_MUTATION)
else
    new_pop = generate_mutated_fireflies(f1, arc_distance(f1, f2), NUMBER_OF_MUTATION)
end
init_firefly_paths(new_pop, distance_matrix)

println(arc_distance(f1,f2))
[println(n.cost, " - ", arc_distance(f2, n)) for n in new_pop]
"""

bests = []
pop = [Firefly(copy(nodes), -1.0) for _ in 1:POPULATION_NUMBER]
init_firefly_paths(pop, distance_matrix)
println(length(pop), " Sized population created!")
for t in tqdm(1:ITERATION_NUMBER)
    print("Step:",t, "-")
    new_pop = []
    for f1 in pop
        for f2 in pop
            if f1.cost < f2.cost 
                # r, _ = hamming_distance(f1, f2)
                # move_firefly(f2, f1, LIGHT_ABSORPTION_COEFF)
                mutated_f1s = generate_mutated_fireflies(f2, distance_matrix, arc_distance(f1, f2), NUMBER_OF_MUTATION)
                new_pop = [new_pop ; mutated_f1s]
                push!(new_pop, f2)
            end
        end
    end
    [push!(pop, n) for n in new_pop]
    sorted_pop = sort!(pop, by=p->p.cost)
    while length(pop) != POPULATION_NUMBER
        pop!(pop)
    end
    # pop = vec(sorted_pop[1:POPULATION_NUMBER])
    push!(bests, sorted_pop[1])
end

println("Bests: ",bests)
best = sort(pop, by=p->p.cost)[1]
best_x = [n.x for n in best.path]
best_y = [n.y for n in best.path]
plot(best_x, best_y, "-")

x = [n.x for n in nodes]
y = [n.y for n in nodes]
plot(x, y, "ro", markersize=2.0)
xlabel("X Dimension")
ylabel("Y Dimension")
title("Cities")
if !isdir("graphs") mkdir("graphs"); end
savefig("graphs/cities.png")