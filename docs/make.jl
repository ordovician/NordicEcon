using NordicEcon
using Documenter

DocMeta.setdocmeta!(NordicEcon, :DocTestSetup, :(using NordicEcon); recursive=true)

makedocs(;
    modules=[NordicEcon],
    authors="Erik Engheim <erik.engheim@mac.com> and contributors",
    repo="https://github.com/ordovician/NordicEcon.jl/blob/{commit}{path}#{line}",
    sitename="NordicEcon.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
