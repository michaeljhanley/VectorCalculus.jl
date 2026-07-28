using LinearAlgebra
using ForwardDiff

"""
    CoordSystem

Abstract supertype for every coordinate system this package supports.
`Cartesian`, `Cylindrical`, `Spherical`, and `CurvilinearCoords` all subtype
`CoordSystem`, and every operator dispatches on it.

See also [`scale_factors`](@ref).
"""
abstract type CoordSystem end

"""
    Cartesian()

The `(x, y, z)` coordinate system. Scale factors are always `(1, 1, 1)`.

# Examples
```jldoctest
julia> scale_factors(Cartesian(), [1.0, 2.0, 3.0])
(1, 1, 1)
```
"""
struct Cartesian <: CoordSystem end
"""
    Cylindrical()

The `(r, θ, z)` coordinate system. Scale factors are `(1, r, 1)`.
Throws `ArgumentError` if `r < 0`.

# Examples
```jldoctest
julia> scale_factors(Cylindrical(), [2.0, pi/4, 1.0])
(1, 2.0, 1)

julia> scale_factors(Cylindrical(), [-1.0, 0.0, 0.0])
ERROR: ArgumentError: radius r must be non-negative, got -1.0
[...]
```
"""
struct Cylindrical <: CoordSystem end
"""
    Spherical()

The `(r, θ, φ)` coordinate system. Scale factors are `(1, r, r sin θ)`.
Throws `ArgumentError` if `r < 0`.

# Examples
```jldoctest
julia> scale_factors(Spherical(), [3.0, pi/3, pi/4])
(1, 3.0, 2.598076211353316)

julia> scale_factors(Spherical(), [-1.0, 0.0, 0.0])
ERROR: ArgumentError: radius r must be non-negative, got -1.0
[...]
```
"""
struct Spherical <: CoordSystem end

"""
    scale_factors(coordinate_system, point)

Return the Lamé scale factors `(h1, h2, h3)` at `point` for
`coordinate_system`.

Throws `ArgumentError` if `coordinate_system` is `Cylindrical` or `Spherical`
and `point[1] < 0`. For `CurvilinearCoords` with `parametrization` set,
throws `ArgumentError` if the system isn't orthogonal at `point`.

# Examples
```jldoctest
julia> scale_factors(Cartesian(), [1.0, 2.0, 3.0])
(1, 1, 1)

julia> scale_factors(Cylindrical(), [2.0, pi/4, 1.0])
(1, 2.0, 1)

julia> scale_factors(Spherical(), [3.0, pi/3, pi/4])
(1, 3.0, 2.598076211353316)
```
"""
function scale_factors end
function scale_factors(coordinate_system::Cartesian, point)
    (1, 1, 1)
end
function scale_factors(coordinate_system::Cylindrical, point)
    if point[1] < 0
        throw(ArgumentError("radius r must be non-negative, got $(point[1])"))
    end
    (1, point[1], 1)
end
function scale_factors(coordinate_system::Spherical, point)
    if point[1] < 0
        throw(ArgumentError("radius r must be non-negative, got $(point[1])"))
    end
    (1, point[1], point[1] * sin(point[2]))
end
struct CurvilinearCoords{
            H1Function, H2Function, H3Function, ParamFunction
        } <: CoordSystem
    h1_function::H1Function
    h2_function::H2Function
    h3_function::H3Function
    parametrization::ParamFunction
end

"""
    CurvilinearCoords(h1, h2, h3; parametrization = nothing)

A user-defined coordinate system built from caller-supplied scale-factor
functions.

# Arguments
- `h1`, `h2`, `h3`: functions `point -> Number` giving the Lamé scale factors.
- `parametrization`: optional function `point -> point` mapping (q₁,q₂,q₃) to
  (x,y,z). When supplied, every `scale_factors` call verifies the system is
  orthogonal at that point and throws `ArgumentError` if it isn't. Defaults
  to `nothing`, which skips the check.

# Examples
```jldoctest
julia> constant_one = point -> 1;

julia> cs = CurvilinearCoords(constant_one, constant_one, constant_one);

julia> scale_factors(cs, [1.0, 2.0, 3.0])
(1, 1, 1)
```

See also [`scale_factors`](@ref).
"""
CurvilinearCoords(h1, h2, h3; parametrization = nothing) =
    CurvilinearCoords(h1, h2, h3, parametrization)

function check_orthogonality(r, point, atol = 1e-8)
    jacobian = ForwardDiff.jacobian(r, point)
    tangent1 = jacobian[:, 1]
    tangent2 = jacobian[:, 2]
    tangent3 = jacobian[:, 3]
    if abs(dot(tangent1, tangent2)) > atol
        throw(ArgumentError(
            "CurvilinearCoords is not orthogonal at point $(point)"
        ))
    elseif abs(dot(tangent1, tangent3)) > atol
        throw(ArgumentError(
            "CurvilinearCoords is not orthogonal at point $(point)"
        ))
    elseif abs(dot(tangent2, tangent3)) > atol
        throw(ArgumentError(
            "CurvilinearCoords is not orthogonal at point $(point)"
        ))
    end
end

function scale_factors(coordinate_system::CurvilinearCoords, point)
    if coordinate_system.parametrization !== nothing
        check_orthogonality(coordinate_system.parametrization, point)
    end
    h1 = coordinate_system.h1_function(point)
    h2 = coordinate_system.h2_function(point)
    h3 = coordinate_system.h3_function(point)
    (h1, h2, h3)
end