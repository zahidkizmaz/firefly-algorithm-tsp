import FireflyModule.Firefly

function init_firefly_paths(fireflies::Array{Firefly}, distance_matrix)
    """Initializes random paths for the given firefly array.
    """
    for f in fireflies
        shuffle!(f.path)
        f.cost = path_cost(f, distance_matrix)
    end
end