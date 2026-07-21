@testset "Error Handling" begin
    cyl_param(q) = SVector(q[1]*cos(q[2]), q[1]*sin(q[2]), q[3])
    good_cs = CurvilinearCoords(
        h1_cyl, h2_cyl, h3_cyl; parametrization = cyl_param
    )
    @test scale_factors(good_cs, [2.0, π/4, 1.0]) == (1, 2.0, 1)

    plain_cs = CurvilinearCoords(h1_cyl, h2_cyl, h3_cyl)
    @test scale_factors(plain_cs, [2.0, π/4, 1.0]) == (1, 2.0, 1)

    @test scale_factors(Cylindrical(), [0.0, π/4, 1.0]) == (1, 0.0, 1)
    @test scale_factors(Spherical(), [0.0, 0.0, 0.5]) == (1, 0.0, 0.0)

    f(point) = point[1]^2   # r², same field as the existing Δ(r²)=4 test
    g = gradient(f, [0.0, π/4, 1.0], Cylindrical())
    @test isnan(g[2])        # 0/0 in the θ-component at r=0

    f2(point) = point[2]     # θ, chosen so the θ-partial is nonzero at r=0
    g2 = gradient(f2, [0.0, π/4, 1.0], Cylindrical())
    @test isinf(g2[2])       # 1/0 in the θ-component at r=0
end