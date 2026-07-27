using Documenter
using VectorCalculus

makedocs(
    sitename = "VectorCalculus.jl",
    pages = ["Home" => "index.md",
             "Mathematical Background" => "math.md",
             "API Reference" => "api.md",
             "Extending" => "extending.md",],
)

deploydocs(
    repo = "github.com/michaeljhanley/VectorCalculus.jl.git",
)