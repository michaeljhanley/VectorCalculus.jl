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
```

## Installation

```julia
] add https://github.com/michaeljhanley/VectorCalculus.jl.git
```

## Documentation

See https://michaeljhanley.github.io/VectorCalculus.jl

## Additional Notes

As of version `0.1.0-DEV`, results from this package's functions return in local curvilinear components, not Cartesian.

## Contributing

See https://github.com/michaeljhanley/VectorCalculus.jl/blob/main/CONTRIBUTING.md

## License

This project is licensed under the terms of the MIT license.


