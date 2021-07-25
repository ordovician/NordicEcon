# Source of Data
This data is obtained from various sources:

- [data.worldbank.org.](https://data.worldbank.org) - Has stastistics on GDP and expenses as percent of  GDP.
- [OECD.Stat](https://stats.oecd.org) - Statistics on unions.
- [IMF Datamapper](https://www.imf.org/external/datamapper) - IMF statistics. Has great system for visualizing data.
- [Our World in Data](https://ourworldindata.org) - Great collection of data about all sorts of aspects of different countries. 
- [Geert Hofstede](https://geerthofstede.com/research-and-vsm/dimension-data-matrix/) - Comparing culture of different countries.

You can download in different formats but I chose CSV files as they are easy to work with in Julia. Of all these sources I think OECD has the nicest CSV formats to work with.

## Cultural Data Explanation

The `data/geerthofstede-2015-08-16.csv` contains descriptions of countries along cultural dimensions. The following six dimensions are used. You can lookup a discription of these traits [here](https://www.map-consult.com/en/hofstede-model.html), but I will give my own short interpretation here.

- **PDI** - Power Distance Index - High score means stronger power hierarchies. Low score means flatter hierarchies with more delegation and autonomy to employees.
- **IDV** - Individualism versus Collectivism - Low score means collectivist societies. High value means freedom, choice and privacy is promoted.
- **MAS** - Masculinity versus Feminity - Power, money and winning are valued with high value. Low value means tenderness, caring and sympathy with the loser. Tolerate diverging opinions.
- **UAI** - Uncertainty Avoidance Index - High score means preferring planning, follow expert advice, common practice etc. Low score means you are willing to try to new things.
- **LTOWVS** - Longterm Orientation versus Short term Orientation - High value means austerity, thrift and hard work  in a quest for long lasting values and accomplishments. 
- **IVR** -  Indulgence Versus Restraint - High score means placing emphasis on having fun and leisure. 

