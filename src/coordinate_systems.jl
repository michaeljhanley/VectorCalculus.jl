abstract type CoordSystem end

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

function Cartesian()
    CurvilinearCoords(
        point -> 1,
        point -> 1,
        point -> 1,
    )
end

function Cylindrical()
    CurvilinearCoords(
        point -> 1,
        point -> point[1],
        point -> 1
    )
end

function Spherical()
    CurvilinearCoords(
        point -> 1,
        point -> point[1],
        point -> point[1] * sin(point[2])
    )
end