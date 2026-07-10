@testset "Cartesian scale factors" begin
    point = (1, 2, 3)
    result = scale_factors(Cartesian(), point)
    @test result[1] ≈ 1
    @test result[2] ≈ 1
    @test result[3] ≈ 1
    @test (@inferred scale_factors(Cartesian(), (1, 2, 3))) isa Tuple
end

@testset "cylindrical scale factors" begin
    point = (2, pi/4, 1)
    result = scale_factors(Cylindrical(), point)
    @test result[1] ≈ 1
    @test result[2] ≈ 2
    @test result[3] ≈ 1
end

@testset "spherical scale factors" begin
    point = (3, pi/3, pi/4)
    result = scale_factors(Spherical(), point)
    expected_h3 = 3 * sin(pi/3)
    @test result[1] ≈ 1
    @test result[2] ≈ 3
    @test result[3] ≈ expected_h3
end

@testset "user-defined reproduces cartesian" begin
    constant_one = point -> 1
    custom_cs = CurvilinearCoords(constant_one, constant_one, constant_one)
    point = (5, -1, 0)
    result = scale_factors(custom_cs, point)
    expected = scale_factors(Cartesian(), point)
    @test result[1] ≈ expected[1]
    @test result[2] ≈ expected[2]
    @test result[3] ≈ expected[3]
end