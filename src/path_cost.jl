import FireflyModule.Firefly

function path_cost(firefly::Firefly, distance_matrix)::Float32
    """Calculates the total path cost from given distance matrix.
    """
    path = firefly.path
    path_len = length(path) - 1
    p_cost = distance_matrix[path[end].id, path[1].id]
    for i in range(1, length=path_len)
        p_cost +=  distance_matrix[path[i].id, path[i+1].id]
    end

    return p_cost
end