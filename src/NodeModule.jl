module NodeModule
import Base.show

    struct Node
        id::Int16
        x::Float32
        y::Float32
    end

    function show(io::IO, n::Node)
        print(string("Node:", n.id))
    end
end