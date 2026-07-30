# Mathematical Background

The four main operators this package implements can be reduced to formulas using Lamé scale factors ``h_1, h_2, h_3``. These coefficients describe how arc length scales with each coordinate direction in three dimensions. They let us write formulas that work for any curvilinear coordinate system.

| System       | (q₁, q₂, q₃) | h₁    | h₂    | h₃      |
| ------------ | ------------ | ----- | ----- | ------- |
| Cartesian    | (x, y, z)    | 1     | 1     | 1       |
| Cylindrical  | (r, θ, z)    | 1     | r     | 1       |
| Spherical    | (r, θ, φ)    | 1     | r     | r sin θ |
| User-defined | (q₁, q₂, q₃) | h₁(q) | h₂(q) | h₃(q)   |

## Operator Formulas Used

Gradient

```math
\nabla f = \frac{1}{h_1}\frac{\partial f}{\partial q_1}\hat{e}_1 + \frac{1}{h_2}\frac{\partial f}{\partial q_2}\hat{e}_2 + \frac{1}{h_3}\frac{\partial f}{\partial q_3}\hat{e}_3
```

Divergence

```math
\nabla \cdot \mathbf{F} = \frac{1}{h_1 h_2 h_3}\left[\frac{\partial (h_2 h_3 F_1)}{\partial q_1} + \frac{\partial (h_1 h_3 F_2)}{\partial q_2} + \frac{\partial (h_1 h_2 F_3)}{\partial q_3}\right]
```

Curl (component form)

```math
(\nabla \times \mathbf{F})_1 = \frac{1}{h_2 h_3}\left[\frac{\partial (h_3 F_3)}{\partial q_2} - \frac{\partial (h_2 F_2)}{\partial q_3}\right]
```

```math
(\nabla \times \mathbf{F})_2 = \frac{1}{h_1 h_3}\left[\frac{\partial (h_1 F_1)}{\partial q_3} - \frac{\partial (h_3 F_3)}{\partial q_1}\right]
```

```math
(\nabla \times \mathbf{F})_3 = \frac{1}{h_1 h_2}\left[\frac{\partial (h_2 F_2)}{\partial q_1} - \frac{\partial (h_1 F_1)}{\partial q_2}\right]
```

Laplacian

```math
\Delta f = \frac{1}{h_1 h_2 h_3}\left[\frac{\partial}{\partial q_1}\left(\frac{h_2 h_3}{h_1}\frac{\partial f}{\partial q_1}\right) + \frac{\partial}{\partial q_2}\left(\frac{h_1 h_3}{h_2}\frac{\partial f}{\partial q_2}\right) + \frac{\partial}{\partial q_3}\left(\frac{h_1 h_2}{h_3}\frac{\partial f}{\partial q_3}\right)\right]
```

The implementation evaluates the scale factors at the user-supplied point, evaluates partial derivatives with automatic differentiation, then plugs those calculations into the formulas above.

We only need ``h_1, h_2,`` and ``h_3`` because we assume the coordinate system to be orthogonal. If this assumption were violated, we'd need the six independent components of a full metric tensor.

For a full derivation behind the orthogonality assumption, see [Del in cylindrical and spherical coordinates](https://en.wikipedia.org/wiki/Del_in_cylindrical_and_spherical_coordinates)
and [Curvilinear coordinates](https://en.wikipedia.org/wiki/Curvilinear_coordinates)
on Wikipedia.

## Example Formula to Code

For ``f(r,\theta,\varphi) = r^2`` in spherical coordinates (``h_1 = 1, h_2 = r, h_3 = r\sin\theta``), only the ``r``-derivative term in the Laplacian survives:

```math
\Delta f = \frac{1}{r^2\sin\theta} \frac{\partial}{\partial r}\left(r^2\sin\theta \cdot 2r\right) = \frac{6r^2\sin\theta}{r^2\sin\theta} = 6
```

The analytical result ``\Delta(r^2) = 6`` holds at every point in spherical coordinates and matches the numerical package output:

```jldoctest
julia> using VectorCalculus

julia> f(point) = point[1]^2
f (generic function with 1 method)

julia> laplacian(f, [3.0, pi/3, pi/4], Spherical())
6.0
```

## Learn More

- [API Reference](api.md)
- [Extending the Package](extending.md)