using Pkg
Pkg.update()
Pkg.build("PyCall")
Pkg.add("PyPlot")

using PyPlot
using Random

# Pushing current dir to import modules. 
push!(LOAD_PATH, "./")
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


LIGHT_ABSORPTION_COEFF = 1
ATTRACTION_COEFF = 1
ITERATION_NUMBER = 0 
POPULATION_NUMBER = 5

println("Insert your file name ")
file_name = readline()
println("File name: ", file_name)
nodes = read_nodes("../data/berlin52.tsp")
# println(create_weights_matrix(nodes))
f1 = Firefly(copy(nodes), -1.0)
f2 = Firefly(copy(nodes), -1.0)
init_firefly_paths([f1, f2])

distance_matrix = create_distance_matrix(nodes)
f1.cost = path_cost(f1, distance_matrix)
println(f1)
# println(f1.path)
# println(f2.path)
r, dist_info = hamming_distance(f1, f2)
p1 = path_cost(f1, distance_matrix)
p2 = path_cost(f2, distance_matrix)

println("Hamming d f1-f2: ", r, "info ", dist_info)
println("f1 path cost: ", p1)
println("f2 path cost: ", p2)

if (p1 > p2) move_firefly(f1, f2, r) else move_firefly(f2, f1, r) end
r, dist_info = hamming_distance(f1, f2)
p1 = path_cost(f1, distance_matrix)
p2 = path_cost(f2, distance_matrix)
println("Hamming d f1-f2: ", r, "info ", dist_info)
println("f1 path cost: ", p1)
println("f2 path cost: ", p2)
#println(f1.cost(distance_matrix))

pop = [Firefly(copy(nodes), -1.0) for _ in 1:POPULATION_NUMBER]
init_firefly_paths(pop)
println(length(pop), " Sized population created!")
for t in 1:ITERATION_NUMBER
    for f1 in pop
        f1_li = path_cost(f1, distance_matrix)
        for f2 in pop
            f2_li = path_cost(f2, distance_matrix)
            if f1_li > f2_li # TO-DO fix arrow when light intensity is implented!
                old_hamming_d = hamming_distance(f1, f2)
                new_hamming_d = Inf
                while (new_hamming_d >= old_hamming_d)
                    index1 = Int(ceil(rand() * length(f1.path)))
                    index2 = Int(ceil(rand() * length(f1.path)))
                    if (index1 >= index2) index1, index2 = index2, index1 end
                    new_path = inversion_mutation(f1, index1, index2)
                    temp_firefly = Firefly(new_path)
                    new_hamming_d = hamming_distance(temp_firefly, f2)
                    println("Old dist:", old_hamming_d, " -- New Dist:", new_hamming_d)
                    println("f1 cost, new cost ", f1_li, " -- ", path_cost(temp_firefly, distance_matrix))
                end
            end
        end
    end
end

# x = range(0,stop=2*pi,length=1000); y = sin.(3*x + 4*cos.(2*x))
println("nodes: ", nodes)
x = [n.x for n in nodes]
y = [n.y for n in nodes]
plot(x, y, "ro", markersize=2.0)
xlabel("X Dimension")
ylabel("Y Dimension")
title("Cities")
savefig("cities.png")