@testset "Orthogonality validation" begin
    h1_cyl(q) = 1
    h2_cyl(q) = q[1]
    h3_cyl(q) = 1

    cyl_param(q) = SVector(q[1]*cos(q[2]), q[1]*sin(q[2]), q[3])
    good_cs = CurvilinearCoords(h1_cyl, h2_cyl, h3_cyl; parametrization=cyl_param)
    @test (@inferred scale_factors(good_cs, [2.0, π/4, 1.0])) == (1, 2.0, 1)

    plain_cs = CurvilinearCoords(h1_cyl, h2_cyl, h3_cyl)
    @test (@inferred scale_factors(plain_cs, [2.0, π/4, 1.0])) == (1, 2.0, 1)

    bad_h1(q) = 1
    bad_h2(q) = 1
    bad_h3(q) = 1
    bad_param(q) = SVector(q[1], q[1] + q[2], q[3])
    bad_cs = CurvilinearCoords(bad_h1, bad_h2, bad_h3; parametrization=bad_param)
    @test_throws ArgumentError scale_factors(bad_cs, [1.0, 1.0, 1.0])
end

@testset "Dimension mismatch" begin
    dummy_scalar(q) = q[1]
    dummy_vector(q) = q

    @test_throws DimensionMismatch gradient(dummy_scalar, [1.0, 2.0], Cartesian())
    @test_throws DimensionMismatch divergence(dummy_vector, [1.0, 2.0], Cartesian())
    @test_throws DimensionMismatch curl(dummy_vector, [1.0, 2.0], Cartesian())
    @test_throws DimensionMismatch laplacian(dummy_scalar, [1.0, 2.0], Cartesian())
end

@testset "Negative radius" begin
    @test_throws ArgumentError scale_factors(Cylindrical(), [-1.0, 0.0, 0.0])
    @test_throws ArgumentError scale_factors(Spherical(), [-1.0, 0.0, 0.0])
end

@testset "Singularities (NaN/Inf, not thrown)" begin
    @test scale_factors(Cylindrical(), [0.0, π/4, 1.0]) == (1, 0.0, 1)
    @test scale_factors(Spherical(), [0.0, 0.0, 0.5]) == (1, 0.0, 0.0)

    r_squared_field(point) = point[1]^2
    g = gradient(r_squared_field, [0.0, π/4, 1.0], Cylindrical())
    @test isnan(g[2])

    theta_field(point) = point[2]
    g2 = gradient(theta_field, [0.0, π/4, 1.0], Cylindrical())
    @test isinf(g2[2])
end