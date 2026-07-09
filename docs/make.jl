using Documenter
using FieldOps

makedocs(
    sitename = "FieldOps.jl",
    pages = ["Home" => "index.md"],
)

deploydocs(
    repo = "github.com/michaeljhanley/FieldOps.jl.git",
)