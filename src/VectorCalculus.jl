module VectorCalculus

using ForwardDiff

include("coordinate_systems.jl")
include("operators.jl")

export CoordSystem, CurvilinearCoords, Cartesian, Cylindrical, Spherical, scale_factors
export gradient, divergence, curl, laplacian

end