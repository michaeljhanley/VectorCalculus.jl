using ForwardDiff
using LinearAlgebra

@testset "gradient() matches ForwardDiff" begin
    func(point) = point[1]^2 + point[2]^2 + point[3]^2
    point = [1.0, 2.0, 3.0]
    mine = @inferred gradient(func, point, Cartesian())
    raw = ForwardDiff.gradient(func, point)
    @test mine ≈ raw atol=1e-10
end

@testset "gradient() analytical: polynomial" begin
    func(point) = point[1]^2 + point[2]^2 + point[3]^2
    point = [1.0, 2.0, 3.0]
    expected = [2.0, 4.0, 6.0]
    result = @inferred gradient(func, point, Cartesian())
    @test result ≈ expected atol=1e-10
end

@testset "gradient() analytical: trig" begin
    func(point) = sin(point[1]) * cos(point[2])
    point = [0.0, 0.0, 0.0]
    expected = [1.0, 0.0, 0.0]
    result = @inferred gradient(func, point, Cartesian())
    @test result ≈ expected atol=1e-10
end

function test_vector_identities(
    scalar_field, vector_field, coordinate_system, test_point; tolerance=1e-10,
)
    @testset "vector identities: $(typeof(coordinate_system))" begin
        grad_f = q -> gradient(scalar_field, q, coordinate_system)

        curl_grad_f = @inferred curl(grad_f, test_point, coordinate_system)
        @test norm(curl_grad_f) < tolerance

        curl_F = q -> curl(vector_field, q, coordinate_system)
        div_curl_F = divergence(curl_F, test_point, coordinate_system)
        @test abs(div_curl_F) < tolerance

        laplacian_direct = @inferred laplacian(scalar_field, test_point, coordinate_system)
        laplacian_via_div = @inferred divergence(grad_f, test_point, coordinate_system)
        @test laplacian_direct ≈ laplacian_via_div atol=tolerance
    end
end

const f = q -> sin(q[1]) * q[2] + q[3]^2
const F = q -> [q[2] * q[3], q[1] * q[3], q[1] * q[2]]

test_vector_identities(f, F, Cartesian(), [1.0, 2.0, 3.0])