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
breaks = c(-1, 0,5,25,50,100,250,500,1000,2000)
breakLabels = c("0", sprintf(">%i, <=%i", breaks[seq(2, length(breaks)-1)], breaks[seq(3, length(breaks))]))
incidence$Group = cut(incidence$Incidence, breaks=breaks, labels=breakLabels)

# Merge GIS and incidence
bhswi = merge(bhsw, incidence, by.x="GEN", by.y="Location")

# Plot
annotation = "GIS: © GeoBasis-DE / BKG 2016\nData: Landesregierung Breisgau-Hochschwarzwald\nImage: https://github.com/dpryan79/bhsw_covid_incidence"
colorscale = c("gray80", "#f4fbc6", "#effb70", "#f8c001", "#d70f01", "#980101", "#690109", "#e60183", "black")
g = ggplot(bhswi) + geom_sf(aes(fill=Group, group=seq_along(Group))) + theme_classic()
g = g + annotate(geom="text", label=annotation, x=Inf, y=-Inf, hjust=1, vjust=-0.1, size=5)
g = g + labs(fill="Cases/100k\nper week", x="", y="") + scale_fill_manual(values=colorscale, guide = guide_legend(reverse=TRUE))
g = g + transition_states(Date, state_length=4, transition_length=2) + ggtitle("Week of {closest_state}")
g = g + theme(axis.line=element_blank(), axis.text=element_blank(), axis.ticks = element_blank(), legend.title=element_text(size=24), legend.text=element_text(size=24), plot.title=element_text(size=24))
g = g + geom_sf_label(data=bhsw, aes(label=GEN), fill = alpha(c("white"),0.5))
a = animate(g, width=1200, height=800, renderer=gifski_renderer())
anim_save("animation.gif", a)
