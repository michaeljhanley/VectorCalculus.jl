h1_cyl(q) = 1
h2_cyl(q) = q[1]
h3_cyl(q) = 1

@testset "orthogonality: valid parametrization passes" begin
    cyl_param(q) = [q[1]*cos(q[2]), q[1]*sin(q[2]), q[3]]
    good_cs = CurvilinearCoords(
        h1_cyl, h2_cyl, h3_cyl; parametrization = cyl_param
    )

    @test scale_factors(good_cs, [2.0, π/4, 1.0]) == (1, 2.0, 1)
end

@testset "orthogonality: non-orthogonal parametrization throws" begin
    skewed_param(q) = [q[1] + q[2], q[2], q[3]]
    bad_cs = CurvilinearCoords(
        h1_cyl, h2_cyl, h3_cyl; parametrization = skewed_param
    )

    @test_throws ArgumentError scale_factors(bad_cs, [2.0, π/4, 1.0])
end

@testset "orthogonality: omitted parametrization is unchanged" begin
    plain_cs = CurvilinearCoords(h1_cyl, h2_cyl, h3_cyl)

    @test scale_factors(plain_cs, [2.0, π/4, 1.0]) == (1, 2.0, 1)
end

@testset "dimension check: wrong-length point throws on all operators" begin
    f = q -> sin(q[1]) * q[2] + q[3]^2
    F = q -> [q[2]*q[3], q[1]*q[3], q[1]*q[2]]

    for bad_point in ([1.0, 2.0], [1.0, 2.0, 3.0, 4.0])
        @test_throws DimensionMismatch gradient(f, bad_point, Cartesian())
        @test_throws DimensionMismatch laplacian(f, bad_point, Cartesian())
        @test_throws DimensionMismatch divergence(F, bad_point, Cartesian())
        @test_throws DimensionMismatch curl(F, bad_point, Cartesian())
    end
end

@testset "negative radius throws" begin
    @test_throws ArgumentError scale_factors(Cylindrical(), [-1.0, 0.0, 0.0])
    @test_throws ArgumentError scale_factors(Spherical(), [-1.0, 0.0, 0.0])
end

@testset "singularities return NaN/Inf, not an error" begin
    @test scale_factors(Cylindrical(), [0.0, π/4, 1.0]) == (1, 0.0, 1)
    @test scale_factors(Spherical(), [3.0, 0.0, 0.5]) == (1, 3.0, 0.0)

    f_r2(point)    = point[1]^2
    f_theta(point) = point[2]
    @test isnan(gradient(f_r2, [0.0, π/4, 1.0], Cylindrical())[2])
    @test isinf(gradient(f_theta, [0.0, π/4, 1.0], Cylindrical())[2])

    f_phi(point) = point[3]
    @test isnan(gradient(f_r2, [3.0, 0.0, 0.5], Spherical())[3])
    @test isinf(gradient(f_phi, [3.0, 0.0, 0.5], Spherical())[3])
end