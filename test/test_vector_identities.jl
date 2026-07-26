test_vector_identities(
    scalar_field_case, vector_field_case, Cartesian(), [1.0, 2.0, 3.0])
test_vector_identities(
    scalar_field_case, vector_field_case, Cylindrical(), [2.0, π/4, 1.0])
test_vector_identities(
    scalar_field_case, vector_field_case, Spherical(), [3.0, π/3, π/4])