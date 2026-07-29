using Aqua
using VectorCalculus

@testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(VectorCalculus)
end