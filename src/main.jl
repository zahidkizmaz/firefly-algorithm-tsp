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
        FireflyModule.hamming_distance, FireflyModule.inversion_mutation, FireflyModule.move_firefly


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
ITERATION_NUMBER = 10 
POPULATION_NUMBER = 500

file_name = get(ENV, "TSP_FILE", nothing)
if file_name != nothing
    println("Reading from: ", file_name)
    nodes = read_nodes(file_name)
    distance_matrix = create_distance_matrix(nodes)
end

bests = []
pop = [Firefly(copy(nodes), -1.0) for _ in 1:POPULATION_NUMBER]
init_firefly_paths(pop, distance_matrix)
println(length(pop), " Sized population created!")
for t in tqdm(1:ITERATION_NUMBER)
    for f1 in pop
        f1_li = path_cost(f1, distance_matrix)
        for f2 in pop
            f2_li = path_cost(f2, distance_matrix)
            if f1_li < f2_li # TO-DO fix arrow when light intensity is implented!
                r, _ = hamming_distance(f1, f2)
                move_firefly(f2, f1, LIGHT_ABSORPTION_COEFF)
            end
        end
    end
    sorted_pop = sort(pop, by=p->p.cost, rev=true)
    push!(bests, sorted_pop[1])
end

best = sort(pop, by=p->p.cost)[1]
println("Best firefly: ", best)
# x = range(0,stop=2*pi,length=1000); y = sin.(3*x + 4*cos.(2*x))
x = [n.x for n in nodes]
y = [n.y for n in nodes]
plot(x, y, "ro", markersize=2.0)
xlabel("X Dimension")
ylabel("Y Dimension")
title("Cities")
if !isdir("graphs") mkdir("graphs"); end
savefig("graphs/cities.png")