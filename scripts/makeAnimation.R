#!/usr/bin/env Rscript
library(sf)
library(ggplot2)
library(gganimate)
library(gifski)
library(transformr)  # not in conda-forge!
shps = st_read('GIS/GEM_2016.shp')
bhsw = shps[which(shps$NUTS=='DE132'),]
ggplot(bhsw) + geom_sf(aes(fill="GEN"))
incidence = read.delim("incidence.txt")
incidence$Date = as.Date(incidence$Date, format="%d.%m.%Y")
breaks = c(0,25,35,50,100,200,350,500,1000,2000)
breakLabels = sprintf(">=%i, <%i", breaks[1:length(breaks)-1], breaks[2:length(breaks)])
incidence$Group = cut(incidence$Incidence,
                      breaks=breaks, labels=breakLabels, include.lowest=T)
bhswi = merge(bhsw, incidence, by.x="GEN", by.y="Location")
colorscale=c("white", "#ffeda0", "#fed976", "#feb24c", "#fd8d3c", "#fc4e2a", "#e31a1c", "#bd0026", "#800026", "black")
g = ggplot(bhswi, aes(frame=Date)) + geom_sf(aes(fill=Group, group=seq_along(Group))) + theme_classic()
g = g + labs(fill="Cases/100k\nper week") + scale_fill_manual(values=colorscale, guide = guide_legend(reverse=TRUE))
g = g + transition_states(Date, state_length=3, transition_length=1) + ggtitle("Week of {closest_state}")
g = g + theme(axis.line=element_blank(), axis.text=element_blank(), axis.ticks = element_blank())
a = animate(g, renderer=gifski_renderer())
anim_save("animation.gif", a)
