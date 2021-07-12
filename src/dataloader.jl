using CSV, DataFrames


export load_data, load_GDP_per_capita, load_expenses_percent_GDP
export datadir

datadir = normpath(joinpath(@__DIR__, "../data"))

name_mapping = Dict(
    "Norway" => :norway, 
    "Sweden" => :sweden, 
    "Denmark" => :denmark, 
    "Finland" => :finland, 
    "United Kingdom" => :uk, 
    "United States" => :usa,
    "Canada" => :canada,
    "Japan" => :japan)

function load_data(filename)
    path = joinpath(datadir, filename)

    # Description of each column begins at row 5
    df = CSV.File(path, header=5) |> DataFrame

    # First column is country name
    # 5th to end is where the actual numerical data is
    df = select(df, 1=>:country, 5:ncol(df))
    countries = ["Norway", "Sweden", "Denmark", "Finland", 
                 "United Kingdom", "United States", "Canada", "Japan"]

     df = filter(df) do row
        row.country in countries 
     end

     table = DataFrame(year = 1960:2020) 
     for country in countries
        matches = filter(row -> row.country == country, df)
        if nrow(matches) < 1
            error("Could not find $country in table")
        end
        name = name_mapping[country]
        
        # extract numberical data for each country.
        # make a column in new table with this data.
        # one column per country
        datacol = collect(matches[1, 2:ncol(matches)-1])
        table[!, name] = datacol
     end
     
     return table    
end

"""
    load_GDP_per_capita() -> DataFrame

Returns a data frame where the first column is the year GDP was recorded.
The next rows are data for one of the Nordic countries, UK, USA, Canada and Japan.

They don't show actual GDP values as they are hard to compare. Instead we have divided
the GDP numbers for every country by its GDP in 1960, and basically said the GDP for
every country is 100 in 1960. Thus the table becomes a way of comparing how GDP
has grown over the years for each country rather than an absolute measure of how
rich each country is.
"""
function load_GDP_per_capita()
    filename = "GDP-per-capita-local-currency.csv"

    gdp = load_data(filename)

    # normalize data, so that each country begins with a GDP index of 100
    # thus we can see relative development of GDP for each country
    for country in values(name_mapping)
        basevalue = gdp[1, country]
        gdp[!, country] .= 100 * (gdp[!, country] / basevalue)
    end

    return gdp
end

"""
    load_expenses_percent_GDP() -> DataFrame
Government expenses such a social benefits, wages to public sector employees.
"""
function load_expenses_percent_GDP()
    filename = "expenses-percent-GDP.csv"
    load_data(filename)
end

