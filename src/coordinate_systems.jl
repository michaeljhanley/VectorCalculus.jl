abstract type CoordSystem end

struct Cartesian <: CoordSystem end
struct Cylindrical <: CoordSystem end
struct Spherical <: CoordSystem end

function scale_factors(coordinate_system::Cartesian, point)
    (1, 1, 1)
end
function scale_factors(coordinate_system::Cylindrical, point)
    (1, point[1], 1)
end
function scale_factors(coordinate_system::Spherical, point)
    (1, point[1], point[1] * sin(point[2]))
end
struct CurvilinearCoords{H1Function, H2Function, H3Function} <: CoordSystem
    h1_function::H1Function
    h2_function::H2Function
    h3_function::H3Function
end

function scale_factors(coordinate_system, point)
    h1 = coordinate_system.h1_function(point)
    h2 = coordinate_system.h2_function(point)
    h3 = coordinate_system.h3_function(point)
    (h1, h2, h3)
end