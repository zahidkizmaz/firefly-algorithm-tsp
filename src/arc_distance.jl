import FireflyModule.Firefly

function arc_distance(f1::Firefly, f2::Firefly)::Int
    """Calculates the arc distance between two firefly paths.
    Example:
        Firefly i -> 1 2 4 6 3 5 7
        Firefly j -> 1 2 4 3 5 7 6 
        1-2, 2-4, 3-5, 5-7 arcs in firefly i are also presented
        in firefly j. But 4-6, 6-3 arcs are missing in
        firefly j. so the arc distance between firefly i
        and firefly j is 2 here.
    """
    missmatched_pair_counts = 0
    f1_pairs = zip(f1.path[1:end-1], f1.path[2:end])
    f2_pairs = zip(f2.path[1:end-1], f2.path[2:end])

    for f1_pair in f1_pairs
        if f1_pair ∉ f2_pairs missmatched_pair_counts += 1 end
    end

    return missmatched_pair_counts
end