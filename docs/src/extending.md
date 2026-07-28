## Intro

This functionality is for anyone using this package with a coordinate
system that isn't built-in. The API supports two approaches: closures via
`CurvilinearCoords`, or a dedicated `CoordSystem` subtype.

```@meta
DocTestSetup = quote
    using VectorCalculus, StaticArrays
end
```

## Option 1: `CurvilinearCoords`

Pass three scale-factor functions directly. This reproduces `Cartesian()`:

```jldoctest
julia> constant_one = point -> 1;

julia> cs = CurvilinearCoords(constant_one, constant_one, constant_one);

julia> scale_factors(cs, [1.0, 2.0, 3.0])
(1, 1, 1)
```

A more useful example: parabolic cylindrical coordinates `(μ, ν, z)`, a
system with no built-in preset.

```jldoctest
julia> h1(q) = sqrt(q[1]^2 + q[2]^2);

julia> h2(q) = sqrt(q[1]^2 + q[2]^2);

julia> h3(q) = 1;

julia> cs = CurvilinearCoords(h1, h2, h3);

julia> laplacian(q -> q[1]^2 - q[2]^2, [2.0, 1.0, 0.5], cs)
8.88178419700125e-17

julia> laplacian(q -> q[3]^2, [2.0, 1.0, 0.5], cs)
2.0
```

### Validating orthogonality

Scale factors alone can't prove a system is orthogonal. Only the Jacobian
of the actual coordinate map can. Pass `parametrization` to get that
guarantee:

```jldoctest
julia> h1_cyl(q) = 1; h2_cyl(q) = q[1]; h3_cyl(q) = 1;

julia> cyl_param(q) = SVector(q[1]*cos(q[2]), q[1]*sin(q[2]), q[3]);

julia> good_cs = CurvilinearCoords(h1_cyl, h2_cyl, h3_cyl; parametrization = cyl_param);

julia> scale_factors(good_cs, [2.0, pi/4, 1.0])
(1, 2.0, 1)
```

A non-orthogonal system throws instead:

```jldoctest
julia> bad_h1(q) = 1; bad_h2(q) = 1; bad_h3(q) = 1;

julia> bad_param(q) = SVector(q[1], q[1] + q[2], q[3]);

julia> bad_cs = CurvilinearCoords(bad_h1, bad_h2, bad_h3; parametrization = bad_param);

julia> scale_factors(bad_cs, [1.0, 1.0, 1.0])
ERROR: ArgumentError: CurvilinearCoords is not orthogonal at point [1.0, 1.0, 1.0]
[...]
```

## Option 2: a dedicated `CoordSystem` subtype

Define a named type instead of using closures when the system deserves its
own name, or will eventually need its own specialized `scale_factors` method:

```julia
struct MySystem <: CoordSystem end

scale_factors(::MySystem, point) = (1, point[1], 1)  # example only
```

```@meta
DocTestSetup = nothing
```