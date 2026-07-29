[![codecov](https://codecov.io/github/michaeljhanley/VectorCalculus.jl/graph/badge.svg?token=OO4RMPQG3P)](https://codecov.io/github/michaeljhanley/VectorCalculus.jl)

## Overview

A Julia package for numerical computation of vector calculus operations in arbitrary orthogonal curvilinear coordinate systems. Currently implements gradient, curl, divergence, and Laplacian functions.

## Example

In the Julia REPL:

```julia
julia> using VectorCalculus

julia> f(point) = point[1]^2
f (generic function with 1 method)

julia> laplacian(f, [3.0, pi/3, pi/4], Spherical())
6.0

julia> gradient(f, [2.0, pi/4, 1.0], Cylindrical())
3-element SVector{3, Float64} with indices SOneTo(3):
 4.0
 0.0
 0.0
```

As of version `0.1.0-DEV`, vector-valued results from this package's return in the local curvilinear basis of the supplied coordinate system, not just Cartesian components.

## Installation
```julia
] add https://github.com/michaeljhanley/VectorCalculus.jl.git
```
## Documentation

See https://michaeljhanley.github.io/VectorCalculus.jl

## Contributing

See https://github.com/michaeljhanley/VectorCalculus.jl/blob/main/CONTRIBUTING.md

## Development Notes

Development of this package used LLM assistance for architecture/pseudocode outlining and as a source of feedback while debugging. All implementation code was manually written by the maintainer and has been reviewed line-by-line.

## License

This project is licensed under the terms of the MIT license.
