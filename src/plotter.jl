using CSV, DataFrames, Plots, StatsPlots

export plot_trade_union_membership, plot_GDP_per_capita, plot_maddison_GDP_data
export plot_GDP
export north_vs_south_countries, anglo_germanic_countries
export plot_relative_GDP

ENV["GKS_ENCODING"]="utf8"  # Fix some annoying warning when plotting

# Find names of colors here: http://juliagraphics.github.io/Colors.jl/stable/namedcolors/

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
    p = @df gdp plot(
           :year,
           [:norway, :sweden, :denmark, :finland, :uk, :usa],
           lw=2,
           minorgrid=true,
           gridalpha=0.3,
           legend=:bottomright,
           label=["norway"  "sweden"  "denmark"  "finland"  "uk"  "usa"],
           seriescolor=[:magenta4  :mediumblue  :deeppink2 :purple4 :lime :green]
           # seriescolor=[:aqua  :teal  :dodgerblue :blue :gold :orange :orangered3]
        )
    # p = plot(gdp.year,   # x-axis
    #         [gdp.norway, gdp.sweden, gdp.finland, gdp.denmark, gdp.uk, gdp.usa, gdp.canada],
    #         lw=2,        # line width
    #         legend=:bottomright, # where to put legend
    #         label=["norway" "sweden" "finland" "denmark" "uk" "usa" "canada"] # labels in legend
    #     )
    # savefig(p, "nordic-GDP-growth-from-60s.svg")
end

function plot_maddison_GDP_data()
    gdp = load_maddison_GDP_data()
    country_gdp = groupby(gdp, :Country)            
    plot_GDP(country_gdp)
end

# This is a smarter way of doing the plotting
function simpler_maddison_GDP_plot()
    gdp = load_maddison_GDP_data()
    countries = DataFrame(Country=["Norway", "Sweden", "Denmark", "Finland", "United Kingdom", "United States"])
    
    # Like a set intersection. Match on :Country column
    sample = innerjoin(gdp, countries, on=:Country)    
    
    # Filter out irrelevant years
    sample = filter(row -> 1950 < row.Year < 2020, sample)
    
    # Creates a separate series for every unique value in value provided to
    # group property. Every row with that group value gets assigned to the same series
    plot(sample.Year, sample.GDP, group=sample.Country)
    
    # You can also write this as:
    @df sample plot(:Year, :GDP, group=:Country)
end


const north_vs_south_countries = [
        "Norway"    => :purple,
        "Sweden"    => :cyan,
        "Finland"   => :blue,
        "Portugal"  => :goldenrod2,
        "Argentina" => :orange,
        "Spain"     => :brown,
        "Italy"     => :red,
        "Venezuela" => :orangered3,
      ]

const anglo_germanic_countries = [
      "Denmark"    => :purple,
      "Germany"    => :cyan,
      "Austria"   => :blue,
      "United Kingdom"  => :goldenrod2,
      "United States" => :orange,
      "Canada"     => :brown,
      "Italy"     => :red,
      "France" => :orangered3,
    ]        


"""
    plot_GDP(country_gdp::GroupedDataFrame, range)
    
Plots GDP data for the year `range` given.
"""
function plot_GDP(country_gdp::GroupedDataFrame, range = 1800:2020, countries = north_vs_south_countries)
    plot()             
    for (cname, color) in countries
        country = country_gdp[(Country=cname,)]
        country = filter(row -> row.Year in range, country)
        @df country plot!(:Year, :GDP, label=cname, lw=2, seriescolor=color)
        # @df country plot!(:Year, :GDP, label=cname, lw=1)
    end
    plot!(minorgrid=true,      # turn on minor grid lines
          gridalpha=0.3,       # Make major grid lines a bit more visible
          # legend=:outertopleft # Place box with legends outside of plot on top left
          legend=:topleft
          
    )    
end

function plot_relative_GDP(base_country::DataFrame, country_gdp::GroupedDataFrame, range = 1900:2020, countries = anglo_germanic_countries)
    bcountry = base_country = filter(row -> row.Year in range, base_country)
    plot(ylims = (40, 130))             
    for (cname, color) in countries
        country = country_gdp[(Country=cname,)]
        country = filter(row -> row.Year in range, country)
        country.rGDP = 100*(country.GDP ./ bcountry.GDP)
        @df country plot!(:Year, :rGDP, label=cname, lw=2, seriescolor=color)
        # @df country plot!(:Year, :GDP, label=cname, lw=1)
    end
    plot!(minorgrid=true,      # turn on minor grid lines
          gridalpha=0.3,       # Make major grid lines a bit more visible
          # legend=:outertopleft # Place box with legends outside of plot on top left
          legend=:topleft
          
    )    
end

function plot_cultural_diff()
    path = joinpath(datadir, "geerthofstede-2015-08-16.csv")
    cultural = CSV.File(path) |> DataFrame
    cultures = select(cultural, :country, 
        :pdi => :hierarchy, 
        :idv => :individualism, 
        :mas => :masculinity, 
        :uai => :uncertainty, 
        :ltowvs => :long_term, 
        :ivr => :indulgence)

    # Countries we want to filter on by performing an innerjoin
    # countries = DataFrame(country=["Norway", "Sweden", "Denmark", "Finland", "U.S.A."])
    countries = DataFrame(country=["Norway", "Sweden", "Denmark", "Japan", "China"])
    
    # Pick cultures where the :country column matches in both DataFrame objects
    sample = innerjoin(cultures, countries, on = :country)
    
    # Stack turns column names into row values. E.g. if you got the row:
    # country hierarchy individualism
    # China   80        20
    #
    # then this becomes:
    # country variable       value
    # China   hierarchy      80
    # China   individualism  20
    #
    # So every column entry gets a separate row with the name of that column    
    data = stack(sample, 2:7)
    
    # Why is this useful? Because the `group` attribute allows you to bundle values
    # having identical column value such as "hierarchy" into a seprate series.
    # Here each series is one country. The x-axis values for each country is the
    # cultural dimensions under the `variable` column
    groupedbar(data.variable, data.value, group=data.country)
    
    # Turn into CSV viewable in Numbers
    # clipboard(repr(MIME("text/csv"), sample))
end
