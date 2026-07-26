@testset "Cylindrical (analytical)" begin
    point = [2.0, pi/4, 1.0]

    f_squared(q) = q[1]^2
    f_r(q) = q[1]

    laplacian_result = @inferred laplacian(f_squared, point, Cylindrical())
    @test isapprox(laplacian_result, 4, atol=TOL)

    grad_result = @inferred gradient(f_r, point, Cylindrical())
    @test isapprox(grad_result, [1, 0, 0], atol=TOL)
end

@testset "Spherical (analytical)" begin
    point = [3.0, pi/3, pi/4]

    f_squared(q) = q[1]^2
    F_radial(q) = SVector(q[1], 0, 0)   # r * r̂

    laplacian_result = @inferred laplacian(f_squared, point, Spherical())
    @test isapprox(laplacian_result, 6, atol=TOL)

    div_result = @inferred divergence(F_radial, point, Spherical())
    @test isapprox(div_result, 3, atol=TOL)
end