import NodeModule.Node

function euclidean_distance(n1::Node, n2::Node)::Float32
    """Calculates the euclidean distance between given two nodes.
    """
    return sqrt((n1.x - n2.x)^2 + (n1.y - n2.y)^2)
end