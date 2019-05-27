import FireflyModule.Firefly

function attractiveness(source_node::Firefly, destination_node::Firefly, λ::Float)::Float
    """Firefly’s attractiveness is proportional to the light
    intensity seen by adjacent fireflies, we can now define the
    attractiveness β of a firefly depending on distance between
    two fireflies.
    """
    β = source_node.cost
    r, _ = hamming_distance(source_node, destination_node)
    return β * exp(-λ ^ (r^2))
end