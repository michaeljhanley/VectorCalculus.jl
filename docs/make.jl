using Documenter
using VectorCalculus

makedocs(
    sitename = "VectorCalculus.jl",
    pages = ["Home" => "index.md"],
)

deploydocs(
    repo = "github.com/michaeljhanley/VectorCalculus.jl.git",
)