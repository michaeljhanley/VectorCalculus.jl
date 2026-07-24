Vector results (gradient and curl) come back in the local curvilinear basis, not Cartesian components. In spherical that's r̂, θ̂, φ̂. In cylindrical it's r̂, θ̂, ẑ.

## Working Example

```julia
julia> using VectorCalculus

julia> g(point) = point[1]
g (generic function with 1 method)

julia> gradient(g, [3.0, pi/3, 1.5], Cylindrical())
3-element StaticArraysCore.SVector{3, Float64} with indices SOneTo(3):
 1.0
 0.0
 0.0
```


