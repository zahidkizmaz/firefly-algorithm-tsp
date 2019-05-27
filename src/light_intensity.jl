import FireflyModule.Firefly

function light_intensity(source_node::Firefly, destination_node::Firefly, λ::Float)::Float
    """Calculates the light intensity for the source firefly.
    """
    I_0 = source_node.cost
    r, _ = hamming_distance(source_node, destination_node)
    return I_0 * ℯ ^ (-λ * (r^2))
end