import NodeModule.Node

function read_nodes(path::String)::Array{Node}
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