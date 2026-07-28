using Documenter, VectorCalculus, StaticArrays

DocMeta.setdocmeta!(VectorCalculus, :DocTestSetup, :(using VectorCalculus, StaticArrays); recursive=true)

makedocs(
    sitename = "VectorCalculus.jl",
    modules = [VectorCalculus],
    doctest = true,
    pages = ["Home" => "index.md",
             "Mathematical Background" => "math.md",
             "API Reference" => "api.md",
             "Extending" => "extending.md",],
)

deploydocs(
    repo = "github.com/michaeljhanley/VectorCalculus.jl.git",
)