import FireflyModule.Firefly

function move_firefly(f1::Firefly, f2::Firefly, r:Int)
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