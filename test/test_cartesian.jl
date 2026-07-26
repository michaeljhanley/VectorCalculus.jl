@testset "Gradient matches raw ForwardDiff" begin
    func(point) = point[1]^2 + point[2]^2 + point[3]^2
    point = [1.0, 2.0, 3.0]
    mine = @inferred gradient(func, point, Cartesian())
    raw = ForwardDiff.gradient(func, point)
    @test mine ≈ raw atol=TOL
end

@testset "Gradient analytical: polynomial" begin
    func(point) = point[1]^2 + point[2]^2 + point[3]^2
    point = [1.0, 2.0, 3.0]
    expected = [2.0, 4.0, 6.0]
    result = @inferred gradient(func, point, Cartesian())
    @test result ≈ expected atol=TOL
end

@testset "Gradient analytical: trig" begin
    func(point) = sin(point[1]) * cos(point[2])
    point = [0.0, 0.0, 0.0]
    expected = [1.0, 0.0, 0.0]
    result = @inferred gradient(func, point, Cartesian())
    @test result ≈ expected atol=TOL
end