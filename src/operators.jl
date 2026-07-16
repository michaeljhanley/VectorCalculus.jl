using StaticArrays

function gradient(scalar_field, point, coordinate_system::CoordSystem)
    lame_factors = scale_factors(coordinate_system, point)
    raw_gradient = ForwardDiff.gradient(scalar_field, point)
    SVector{3}(raw_gradient ./ lame_factors)
end

# Helper function for divergence(), curl(), and laplacian()
function partial_derivative(scalar_field, point, coordinate_index::Integer)
    gradient_of_function = ForwardDiff.gradient(scalar_field, point)
    gradient_of_function[coordinate_index]
end

function divergence(vector_field, point, coordinate_system::CoordSystem)
    h1, h2, h3 = scale_factors(coordinate_system, point)

    term1 = partial_derivative(point, 1) do q
        _, hq2, hq3 = scale_factors(coordinate_system, q)
        hq2 * hq3 * vector_field(q)[1]
    end

    term2 = partial_derivative(point, 2) do q
        hq1, _, hq3 = scale_factors(coordinate_system, q)
        hq1 * hq3 * vector_field(q)[2]
    end

    term3 = partial_derivative(point, 3) do q
        hq1, hq2, _ = scale_factors(coordinate_system, q)
        hq1 * hq2 * vector_field(q)[3]
    end

    (term1 + term2 + term3) / (h1 * h2 * h3)
end

function curl(vector_field, point, coordinate_system::CoordSystem)
    h1, h2, h3 = scale_factors(coordinate_system, point)

    function comp1_term_a(q)
        _, _, hq3 = scale_factors(coordinate_system, q)
        hq3 * vector_field(q)[3]
    end
    function comp1_term_b(q)
        _, hq2, _ = scale_factors(coordinate_system, q)
        hq2 * vector_field(q)[2]
    end
    c1a = partial_derivative(comp1_term_a, point, 2)
    c1b = partial_derivative(comp1_term_b, point, 3)
    component1 = (c1a - c1b) / (h2 * h3)

    function comp2_term_a(q)
        hq1, _, _ = scale_factors(coordinate_system, q)
        hq1 * vector_field(q)[1]
    end
    function comp2_term_b(q)
        _, _, hq3 = scale_factors(coordinate_system, q)
        hq3 * vector_field(q)[3]
    end
    c2a = partial_derivative(comp2_term_a, point, 3)
    c2b = partial_derivative(comp2_term_b, point, 1)
    component2 = (c2a - c2b) / (h1 * h3)

    function comp3_term_a(q)
        _, hq2, _ = scale_factors(coordinate_system, q)
        hq2 * vector_field(q)[2]
    end
    function comp3_term_b(q)
        hq1, _, _ = scale_factors(coordinate_system, q)
        hq1 * vector_field(q)[1]
    end
    c3a = partial_derivative(comp3_term_a, point, 1)
    c3b = partial_derivative(comp3_term_b, point, 2)
    component3 = (c3a - c3b) / (h1 * h2)

    SVector(component1, component2, component3)
end

function laplacian(scalar_field, point, coordinate_system::CoordSystem)
    gradient_field = q -> gradient(scalar_field, q, coordinate_system)
    divergence(gradient_field, point, coordinate_system)
end