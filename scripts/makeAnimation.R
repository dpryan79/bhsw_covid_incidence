#!/usr/bin/env Rscript
library(sf)
library(ggplot2)
library(gganimate)
library(gifski)
library(transformr)  # not in conda-forge!

# Load and subset GIS maps
shps = st_read('GIS/GEM_2016.shp')
bhsw = shps[which(shps$NUTS=='DE132'),]

# Load incidence data, add color groups for ggplot2
incidence = read.delim("incidence.txt")
incidence$Date = as.Date(incidence$Date, format="%d.%m.%Y")
breaks = c(0,25,35,50,100,200,350,500,1000,2000)
breakLabels = sprintf(">=%i, <%i", breaks[1:length(breaks)-1], breaks[2:length(breaks)])
incidence$Group = cut(incidence$Incidence,
                      breaks=breaks, labels=breakLabels, include.lowest=T)

# Merge GIS and incidence
bhswi = merge(bhsw, incidence, by.x="GEN", by.y="Location")

# Plot
annotation = "GIS: © GeoBasis-DE / BKG 2016\nData: Landesregierung Breisgau-Hochschwarzwald\nImage: https://github.com/dpryan79/bhsw_covid_incidence"
colorscale = c("white", "#ffeda0", "#fed976", "#feb24c", "#fd8d3c", "#fc4e2a", "#e31a1c", "#bd0026", "#800026", "black")
g = ggplot(bhswi, aes(frame=Date)) + geom_sf(aes(fill=Group, group=seq_along(Group))) + theme_classic()
g = g + annotate(geom="text", label=annotation, x=Inf, y=-Inf, hjust=1, vjust=0, size=3)
g = g + labs(fill="Cases/100k\nper week", x="", y="") + scale_fill_manual(values=colorscale, guide = guide_legend(reverse=TRUE))
g = g + transition_states(Date, state_length=3, transition_length=1) + ggtitle("Week of {closest_state}")
g = g + theme(axis.line=element_blank(), axis.text=element_blank(), axis.ticks = element_blank())
a = animate(g, renderer=gifski_renderer())
anim_save("animation.gif", a)
