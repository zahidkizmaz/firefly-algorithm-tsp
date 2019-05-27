function hamming_distance(firefly_1::Firefly, firefly_2::Firefly)
    """Calculates the hamming distance between two fireflies.
    """
    dist = 0
    dist_info = []
    for (i, n) in enumerate(firefly_1.path)
        if n.id != firefly_2.path[i].id
            dist += 1
            push!(dist_info, true)
        else
            push!(dist_info, false)
        end
    end
    return dist, dist_info
end