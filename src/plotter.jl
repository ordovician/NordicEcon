using CSV, DataFrames, Plots

export plot_trade_union_membership, plot_GDP_per_capita

ENV["GKS_ENCODING"]="utf8"  # Fix some annoying warning when plotting

function plot_trade_union_membership()
    path = joinpath(datadir, "trade-union-membership.csv")
    unions = CSV.File(path) |> DataFrame
    unions = select(unions, :Country, :Time, :Value)
    country_unions = groupby(unions, :Country)
    
    country_names = ["Norway", "Sweden", "Denmark", "Finland", 
                 "United Kingdom", "United States", "Canada"]
    colors = [:purple, :blue, :cyan, :green, :orange, :red, :brown]
    plot()             
    for (i, cname) in enumerate(country_names)
        country = country_unions[(Country=cname,)]
        @df country plot!(:Time, :Value, label=cname, lw=2, seriescolor=colors[i])
    end
    plot!(minorgrid=true,      # turn on minor grid lines
          gridalpha=0.3,       # Make major grid lines a bit more visible
          legend=:outertopleft # Place box with legends outside of plot on top left
    )
end

function plot_GDP_per_capita()
    gdp = load_GDP_per_capita()
    p = plot(gdp.year,   # x-axis
            [gdp.norway, gdp.sweden, gdp.finland, gdp.denmark, gdp.uk, gdp.usa, gdp.canada],
            lw=2,        # line width
            legend=:bottomright, # where to put legend
            label=["norway" "sweden" "finland" "denmark" "uk" "usa" "canada"] # labels in legend
        )
    # savefig(p, "nordic-GDP-growth-from-60s.svg")
end