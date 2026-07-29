using Test
using VectorCalculus
using ForwardDiff
using LinearAlgebra
using StaticArrays

@testset verbose = true "VectorCalculus.jl" begin
    include("test_helpers.jl")
    @testset "Scale factors" begin
        include("test_scale_factors.jl")
    end
    @testset "Cartesian operators" begin
        include("test_cartesian.jl")
    end
    @testset "Vector identities" begin
        include("test_vector_identities.jl")
    end
    @testset "Non-Cartesian validation" begin
        include("test_noncartesian.jl")
    end
    @testset "Error handling" begin
        include("test_error_handling.jl")
    end
    @testset "User-defined systems" begin
        include("test_user_defined.jl")
    end
    @testset "Code quality (Aqua.jl)" begin
        include("test_quality.jl")
    end
    @testset "Code quality (JET.jl)" begin
        include("test_jet.jl")
    end
end