module FireflyModule

    import NodeModule.Node, NodeModule.euclidean_distance
    using Random

    mutable struct Firefly
        path::Array{Node}
        cost::Float32
    end

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

    function init_firefly_paths(fireflies)
        """Initializes random paths for the given firefly array.
        """
        for f in fireflies
            shuffle!(f.path)
        end
    end

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

    function light_intensity(source_node::Firefly, destination_node::Firefly, λ)
        """Calculates the light intensity for the source firefly.
        """
        I_0 = source_node.cost
        r, _ = hamming_distance(source_node, destination_node)
        return I_0 * ℯ ^ (-λ * (r^2))
    end
    
    function attractiveness(source_node::Firefly, destination_node::Firefly, λ)
        """Firefly’s attractiveness is proportional to the light
        intensity seen by adjacent fireflies, we can now define the
        attractiveness β of a firefly depending on distance between
        two fireflies.
        """
        β = source_node.cost
        r, _ = hamming_distance(source_node, destination_node)
        return β * ℯ ^ (-λ ^ (r^2))
    end

    function inversion_mutation(firefly::Firefly, index1::Int, index2::Int)
        """Reverses the part of give array with indexes.
        """
        return reverse(firefly.path, index1, index2)
    end
    
    function move_firefly(f1, f2, r)
        """Moving f1 to f2 less than r swap operations.
        """
        number_of_swaps = Int(ceil(rand() * (r-2) ))
        d, d_info = hamming_distance(f1, f2)

        while number_of_swaps > 0
            d, d_info = hamming_distance(f1, f2)
            random_index = rand([i for i in 1:length(d_info) if d_info[i]])
            value_to_copy = f2.path[random_index]
            index_to_move = findfirst(x -> x==value_to_copy, f1.path)

            if number_of_swaps == 1 && f1.path[index_to_move] == f2.path[random_index] && f1.path[random_index] == f2.path[index_to_move]
                break
            end

            f1.path[random_index], f1.path[index_to_move] = f1.path[index_to_move], f1.path[random_index]
            # println("swapped! ", f1.path[random_index], " -- ", f1.path[index_to_move])
            if f1.path[index_to_move] == f2.path[index_to_move] number_of_swaps -= 1 end
            number_of_swaps -= 1
        end
    end

end