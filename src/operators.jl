using StaticArrays

function check_point_dimensions(point)
    if length(point) != 3
        throw(DimensionMismatch(
            "point must have exactly 3 components, got $(length(point))"
        ))
    end
end

"""
    gradient(f, point, coordinate_system)

Compute the gradient of scalar field `f` at `point` in `coordinate_system`,
returned as a 3-element `SVector` in the local basis of `coordinate_system`.

Throws `DimensionMismatch` if `point` doesn't have exactly 3 components.
Errors from `scale_factors` (negative radius, non-orthogonal
`CurvilinearCoords`) propagate unchanged.

# Examples
```jldoctest
julia> f(point) = point[1]^2 + point[2]^2 + point[3]^2;

julia> gradient(f, [1.0, 2.0, 3.0], Cartesian())
3-element SVector{3, Float64} with indices SOneTo(3):
 2.0
 4.0
 6.0
```
"""
function gradient(scalar_field, point, coordinate_system::CoordSystem)
    check_point_dimensions(point)
    point = SVector{3}(point)
    lame_factors = scale_factors(coordinate_system, point)
    raw_gradient = ForwardDiff.gradient(scalar_field, point)
    raw_gradient ./ lame_factors
end

# Helper function, not public
function partial_derivative(scalar_field, point, coordinate_index::Integer)
    p1, p2, p3 = point
    function along_axis(x)
        shifted = coordinate_index == 1 ? SVector(x, p2, p3) :
                  coordinate_index == 2 ? SVector(p1, x, p3) :
                                          SVector(p1, p2, x)
        scalar_field(shifted)
    end
    ForwardDiff.derivative(along_axis, point[coordinate_index])
end

"""
    divergence(F, point, coordinate_system)

Compute the divergence of vector field `F` at `point` in `coordinate_system`.

Throws `DimensionMismatch` if `point` doesn't have exactly 3 components.
Errors from `scale_factors` propagate unchanged.

# Examples
```jldoctest
julia> F_radial(point) = SVector(point[1], 0.0, 0.0);

julia> divergence(F_radial, [3.0, pi/3, pi/4], Spherical())
3.0
```
"""
function divergence(vector_field, point, coordinate_system::CoordSystem)
    check_point_dimensions(point)
    point = SVector{3}(point)
    h1, h2, h3 = scale_factors(coordinate_system, point)

    term1 = partial_derivative(point, 1) do q
        _, hq2, hq3 = scale_factors(coordinate_system, q)
        hq2 * hq3 * vector_field(q)[1]
    end

    term2 = partial_derivative(point, 2) do q
        hq1, _, hq3 = scale_factors(coordinate_system, q)
        hq1 * hq3 * vector_field(q)[2]
    end

    term3 = partial_derivative(point, 3) do q
        hq1, hq2, _ = scale_factors(coordinate_system, q)
        hq1 * hq2 * vector_field(q)[3]
    end

    (term1 + term2 + term3) / (h1 * h2 * h3)
end

"""
    curl(F, point, coordinate_system)

Compute the curl of vector field `F` at `point` in `coordinate_system`,
returned as a 3-element `SVector` in the local basis of `coordinate_system`.

Throws `DimensionMismatch` if `point` doesn't have exactly 3 components.
Errors from `scale_factors` propagate unchanged.

# Examples
```jldoctest
julia> G(point) = SVector(-point[2], point[1], 0.0);

julia> curl(G, [1.0, 2.0, 3.0], Cartesian())
3-element SVector{3, Float64} with indices SOneTo(3):
  0.0
 -0.0
  2.0
```
"""
function curl(vector_field, point, coordinate_system::CoordSystem)
    check_point_dimensions(point)
    point = SVector{3}(point)
    h1, h2, h3 = scale_factors(coordinate_system, point)

    function comp1_term_a(q)
        _, _, hq3 = scale_factors(coordinate_system, q)
        hq3 * vector_field(q)[3]
    end
    function comp1_term_b(q)
        _, hq2, _ = scale_factors(coordinate_system, q)
        hq2 * vector_field(q)[2]
    end
    c1a = partial_derivative(comp1_term_a, point, 2)
    c1b = partial_derivative(comp1_term_b, point, 3)
    component1 = (c1a - c1b) / (h2 * h3)

    function comp2_term_a(q)
        hq1, _, _ = scale_factors(coordinate_system, q)
        hq1 * vector_field(q)[1]
    end
    function comp2_term_b(q)
        _, _, hq3 = scale_factors(coordinate_system, q)
        hq3 * vector_field(q)[3]
    end
    c2a = partial_derivative(comp2_term_a, point, 3)
    c2b = partial_derivative(comp2_term_b, point, 1)
    component2 = (c2a - c2b) / (h1 * h3)

    function comp3_term_a(q)
        _, hq2, _ = scale_factors(coordinate_system, q)
        hq2 * vector_field(q)[2]
    end
    function comp3_term_b(q)
        hq1, _, _ = scale_factors(coordinate_system, q)
        hq1 * vector_field(q)[1]
    end
    c3a = partial_derivative(comp3_term_a, point, 1)
    c3b = partial_derivative(comp3_term_b, point, 2)
    component3 = (c3a - c3b) / (h1 * h2)

    SVector(component1, component2, component3)
end

"""
    laplacian(f, point, coordinate_system)

Compute the Laplacian of scalar field `f` at `point` in `coordinate_system`.

Throws `DimensionMismatch` if `point` doesn't have exactly 3 components.
Errors from `scale_factors` propagate unchanged.

# Examples
```jldoctest
julia> f(point) = point[1]^2;

julia> laplacian(f, [3.0, pi/3, pi/4], Spherical())
6.0
```
"""
function laplacian(scalar_field, point, coordinate_system::CoordSystem)
    check_point_dimensions(point)
    gradient_field = q -> gradient(scalar_field, q, coordinate_system)
    divergence(gradient_field, point, coordinate_system)
end