@testset "user-defined reproduces cylindrical" begin
    h1(q) = 1
    h2(q) = q[1]
    h3(q) = 1
    radius_squared_field(q) = q[1]^2

    custom_cylindrical = CurvilinearCoords(h1, h2, h3)
    point = [2.0, pi/4, 1.0]

    custom_scale_factors = @inferred scale_factors(custom_cylindrical, point)
    @test custom_scale_factors == scale_factors(Cylindrical(), point)

    custom_laplacian = @inferred laplacian(radius_squared_field, point, custom_cylindrical)
    builtin_laplacian = @inferred laplacian(radius_squared_field, point, Cylindrical())
    @test custom_laplacian ≈ builtin_laplacian atol=1e-10
end

@testset "user-defined reproduces spherical" begin
    h1(q) = 1
    h2(q) = q[1]
    h3(q) = q[1] * sin(q[2])
    radius_squared_field(q) = q[1]^2

    custom_spherical = CurvilinearCoords(h1, h2, h3)
    point = [3.0, pi/3, pi/4]

    custom_scale_factors = @inferred scale_factors(custom_spherical, point)
    @test custom_scale_factors == scale_factors(Spherical(), point)

    custom_laplacian = @inferred laplacian(radius_squared_field, point, custom_spherical)
    builtin_laplacian = @inferred laplacian(radius_squared_field, point, Spherical())
    @test custom_laplacian ≈ builtin_laplacian atol=1e-10
end

@testset "parabolic cylindrical tests" begin
    h1(q) = sqrt(q[1]^2 + q[2]^2)
    h2(q) = sqrt(q[1]^2 + q[2]^2)
    h3(q) = 1
    parabolic_parameterization(q) = SVector(
            (q[1]^2 - q[2]^2) / 2, q[1] * q[2], q[3]
            )
    custom_parabolic = CurvilinearCoords(h1, h2, h3, parabolic_parameterization)
    point = [2.0, 1.0, 0.5]

    custom_scale_factors = @inferred scale_factors(custom_parabolic, point)
    @test custom_scale_factors == (
        sqrt(point[1]^2 + point[2]^2), sqrt(point[1]^2 + point[2]^2), 1
        )

    parabolic_scalar_field1(q) = q[1]^2 - q[2]^2
    laplacian_result1 = @inferred laplacian(parabolic_scalar_field1, point, custom_parabolic)
    @test laplacian_result1 ≈ 0 atol=1e-10

    parabolic_scalar_field2(q) = q[3]^2
    laplacian_result2 = @inferred laplacian(parabolic_scalar_field2, point, custom_parabolic)
    @test laplacian_result2 ≈ 2 atol=1e-10
end