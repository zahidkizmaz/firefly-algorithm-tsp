import NodeModule.Node

function create_distance_matrix(nodes::Array{Node})
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