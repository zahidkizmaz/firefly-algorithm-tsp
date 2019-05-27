module FireflyModule

    import NodeModule.Node, Base.show, Base.copy

    mutable struct Firefly
        path::Array{Node}
        cost::Float32
    end

    function show(io::IO, n::Firefly)
        print(string("Firefly:", n.cost, " "))
    end

    copy(s::Firefly) = Firefly(s.path, s.cost)
end