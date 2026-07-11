function gradient(func, point, coordinate_system)
    lame_factors = scale_factors(coordinate_system, point)
    raw = ForwardDiff.gradient(func, point)
    raw ./ lame_factors
end