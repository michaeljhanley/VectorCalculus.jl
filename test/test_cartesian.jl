using ForwardDiff
using LinearAlgebra

@testset "gradient() matches ForwardDiff" begin
    func(point) = point[1]^2 + point[2]^2 + point[3]^2
    point = [1.0, 2.0, 3.0]

    mine = gradient(func, point, Cartesian())
    raw = ForwardDiff.gradient(func, point)

    @test mine ≈ raw atol=1e-10
end

@testset "gradient() analytical: polynomial" begin
    func(point) = point[1]^2 + point[2]^2 + point[3]^2
    point = [1.0, 2.0, 3.0]
    expected = [2.0, 4.0, 6.0]

    result = gradient(func, point, Cartesian())

    @test result ≈ expected atol=1e-10
end

@testset "gradient() analytical: trig" begin
    func(point) = sin(point[1]) * cos(point[2])
    point = [0.0, 0.0, 0.0]

    # df/dx = cos(x)cos(y) = 1, df/dy = -sin(x)sin(y) = 0, df/dz = 0
    expected = [1.0, 0.0, 0.0]

    result = gradient(func, point, Cartesian())

    @test result ≈ expected atol=1e-10
end