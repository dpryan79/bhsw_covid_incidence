# Covid-19 incidence per week by community

This repository is meant to compute and display the population-normalized Covid-19 incidence for each community (Gemeinde) in Breisgau-Hochschwarzwald per week. Only limited data is available, since it's [published weekly as a PDF](https://www.breisgau-hochschwarzwald.de/pb/Breisgau-Hochschwarzwald/Start/Service+_+Verwaltung/Corona-Virus.html) and previous week's data removed. GIS data is from [ESRI Deutschland](https://opendata-esri-de.opendata.arcgis.com/) and © GeoBasis-DE / BKG 2016.

![Animated map](https://github.com/dpryan79/bhsw_covid_incidence/raw/master/animation.gif)

# Data harvesting

Data is extracted from the PDF produced by the Landesregierun Breisgau-Hochscharzwald every week using pdftotext. Then the scripts under `scripts/` are used to format this into a standard TSV file (`incidence.txt`). The text file made from the PDF isn't always formatted exactly the same from week to week, so the python scripts used for this often need to be tweaked slightly.

# Image creation

The TSV data is loaded into R and the final animated GIF created using ggplot2, gganimate, sf and gifski.
