## Introduction

VectorCalculus.jl is a lightweight Julia package for numerically computing vector calculus functions in arbitrary orthogonal curvilinear coordinate systems. It comes with Cartesian, cylindrical, and spherical as built-in presets.

This is meant for folks who use PDEs for physics and engineering, and SciML users who could use pre-made operators rather than needing to hand-roll them in functions every time they're needed.

Note: the current version of this package returns vector-field results in the local curvilinear basis, rather than defaulting to Cartesian component outputs.

## Working Examples

```julia
julia> using VectorCalculus

julia> f(point) = point[1]^2
f (generic function with 1 method)

julia> laplacian(f, [3.0, pi/3, pi/4], Spherical())
6.0
```

```julia
julia> using VectorCalculus

julia> F(point) = [point[1], 0.0, 0.0]
F (generic function with 1 method)

julia> divergence(F, [2.0, pi/4, 1.0], Cylindrical())
2.0
```

## Installation

```julia
] add https://github.com/michaeljhanley/VectorCalculus.jl.git
```

## API Summary

```julia
gradient(scalar_field, point, coordinate_system)
divergence(vector_field, point, coordinate_system)
curl(vector_field, point, coordinate_system)
laplacian(scalar_field, point, coordinate_system)
```

For more, visit [API Reference](api.md)

## Supported Coordinate Systems

VectorCalculus.jl comes with `Cartesian()`, `Cylindrical()`, and `Spherical()` as coordinate systems that are ready to use out of the box. Users may also extend the package's functionality by defining custom `CurvilinearCoords` instances and `scale_factors()` functions. All coordinate systems used by this package must be orthogonal.

## Learn More

- [Mathematical Background](math.md)
- [API Reference](api.md)
- [Extending the Package](extending.md)