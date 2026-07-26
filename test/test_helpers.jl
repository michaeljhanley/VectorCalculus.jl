const TOL = 1e-10

const scalar_field_case = q -> sin(q[1]) * q[2] + q[3]^2
const vector_field_case = q -> [q[2] * q[3], q[1] * q[3], q[1] * q[2]]

function test_vector_identities(scalar_field, vector_field, cs, point; tolerance=TOL)
    @testset "Vector identities: $(typeof(cs))" begin
        grad_f = q -> gradient(scalar_field, q, cs)

        curl_grad_f = @inferred curl(grad_f, point, cs)
        @test norm(curl_grad_f) < tolerance

        curl_F = q -> curl(vector_field, q, cs)
        div_curl_F = divergence(curl_F, point, cs)
        @test abs(div_curl_F) < tolerance

        laplacian_direct = @inferred laplacian(scalar_field, point, cs)
        laplacian_via_div = @inferred divergence(grad_f, point, cs)
        @test laplacian_direct ≈ laplacian_via_div atol=tolerance
    end
end