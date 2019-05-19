module NodeModule
import Base.show


    struct Node
        id::Int16
        x::Float32
        y::Float32
    end

    function show(io::IO, n::Node)
        print(string("Node:", n.id))
    end

    function euclidean_distance(n1::Node, n2::Node)::Float32
        """Calculates the euclidean distance between given two nodes.
        """
        return sqrt((n1.x - n2.x)^2 + (n1.y - n2.y)^2)
    end

    function create_distance_matrix(nodes)
        """Creates and returns the matrix of distances between given nodes.
        Uses euclidean_distance function to calculate distance.
        """
        node_num = length(nodes)
        result_matrix = zeros(node_num, node_num)

        for n1 in nodes
            for n2 in nodes
                result_matrix[n1.id,n2.id] = euclidean_distance(n1, n2)
            end
        end
        return result_matrix
    end

end