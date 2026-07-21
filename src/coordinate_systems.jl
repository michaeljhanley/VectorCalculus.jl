using LinearAlgebra
using ForwardDiff

abstract type CoordSystem end

struct Cartesian <: CoordSystem end
struct Cylindrical <: CoordSystem end
struct Spherical <: CoordSystem end

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