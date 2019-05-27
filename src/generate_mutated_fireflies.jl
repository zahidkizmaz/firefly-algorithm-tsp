import FireflyModule.Firefly, FireflyModule.copy

function generate_mutated_fireflies(firefly::Firefly, distance_matrix, r::Int, k::Int)::Array{Firefly}
    """Generates mutated fireflies using inversion_mutation function.
    Returns the new generated firefly array.
    """
    return [inversion_mutation(copy(firefly), distance_matrix, r) for _ in 1:k]
end