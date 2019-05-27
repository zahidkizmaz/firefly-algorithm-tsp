import FireflyModule.Firefly

function inversion_mutation(firefly::Firefly, distance_matrix, r::Int)::Firefly
    """Reverses the random part of given firefly path with
    given difference.
    """
    length_of_mutation = rand(2:r);
    max_len = length(firefly.path)-length_of_mutation
    index1 = rand(1:max_len)
    index2 = index1 + length_of_mutation
    mutated_path = reverse(firefly.path, index1, index2)
    new_f = copy(firefly)
    new_f.path = mutated_path
    new_f.cost = path_cost(new_f, distance_matrix)
    return new_f
end