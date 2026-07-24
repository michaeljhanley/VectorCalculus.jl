# test/test_noncartesian.jl
using Test
using VectorCalculus
using StaticArrays

@testset "cylindrical (analytical)" begin
    point = [2.0, pi/4, 1.0]

    f_squared(q) = q[1] ^ 2
    f_r(q) = q[1]

    laplacian_result = laplacian(f_squared, point, Cylindrical())
    @test isapprox(laplacian_result, 4, atol=1e-10)

    grad_result = gradient(f_r, point, Cylindrical())
    @test isapprox(grad_result, [1, 0, 0], atol=1e-10)
end

@testset "spherical (analytical)" begin
    point = [3.0, pi/3, pi/4]

    f_squared(q) = q[1] ^ 2
    F_radial(q) = SVector(q[1], 0, 0)   # r * r̂

    laplacian_result = laplacian(f_squared, point, Spherical())
    @test isapprox(laplacian_result, 6, atol=1e-10)

    div_result = divergence(F_radial, point, Spherical())
    @test isapprox(div_result, 3, atol=1e-10)
end