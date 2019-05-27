# Pushing current dir to import modules. 
push!(LOAD_PATH, "./src")
# Including the necessary files.
include("./FireflyModule.jl")
include("./NodeModule.jl")
include("./arc_distance.jl")
include("./create_distance_matrix.jl")
include("./euclidean_distance.jl")
include("./generate_mutated_fireflies.jl")
include("./init_firefly.jl")
include("./inversion_mutation.jl")
include("./path_cost.jl")
include("./read_nodes.jl")

using Pkg, ProgressBars, PyPlot, Random

import NodeModule.Node, FireflyModule.Firefly

Pkg.update()
Pkg.add("PyPlot")
Pkg.add("ProgressBars")

LIGHT_ABSORPTION_COEFF = 0.2
ATTRACTION_COEFF = 1
ITERATION_NUMBER = 5
POPULATION_NUMBER = 12
NUMBER_OF_MUTATION = 8

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
    print("Step:",t, "-")
    new_pop = []
    for f1 in pop
        for f2 in pop
            if f1.cost < f2.cost 
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
    push!(bests, sorted_pop[1])
end

# Plotting and printing the best solutions.
println("Bests: ",bests)
best = sort(pop, by=p->p.cost)[1]
best_x = [n.x for n in best.path]
best_y = [n.y for n in best.path]
best_cost = best.cost
plot(best_x, best_y, "-")

x = [n.x for n in nodes]
y = [n.y for n in nodes]
plot(x, y, "ro", markersize=2.0)
xlabel("X Dimension")
ylabel("Y Dimension")
title("Firefly Cost: $best_cost", fontsize=10)
suptitle("File: $file_name", fontweight="bold")
if !isdir("graphs") mkdir("graphs"); end
savefig("graphs/cities.png")