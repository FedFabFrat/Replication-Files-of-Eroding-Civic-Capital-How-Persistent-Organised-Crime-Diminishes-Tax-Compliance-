rm(list=ls())
library(dplyr)
library(sf)
library(ggplot2)
library(haven)
library(ggpubr)

#### directory ####
# Set root to the top-level folder of this replication package
root <- "PATH/TO/final_package_JLEO"
maps    <- file.path(root, "data", "maps")
figures <- file.path(root, "output", "figures")
setwd(maps)



#### import and merge data ####

## import layers of italy administrative units ##

# municipalities ##
munis_cn <- st_read("Com2011_WGS84.shp")
munis_cn <- filter(munis_cn, COD_RIP %in% c(1,2,3)) # selet centre-north regions

# provinces #
regs_cn <- st_read("Reg2011_WGS84.shp")
regs_cn <- filter(regs_cn, COD_RIP %in% c(1,2,3)) # selet centre-north regions

# provinces #
provs_cn <- st_read("Prov2011_WGS84.shp")
provs_cn <- filter(provs_cn, COD_RIP %in% c(1,2,3)) # selet centre-north regions

# main data #
main_data <- read_stata("maps_data.dta")


## merge main data with shapefiles ##

# maps data #
maps <- merge(x = munis_cn, y = main_data, by.x= "PRO_COM", by.y = "codcom", all.x = T)    # check in stata PRO_COM and codcom
maps_prov <- merge(x = provs_cn, y = main_data, by.x= "COD_PROV", by.y = "idprov", all.x = T)    # check in stata PRO_COM and codcom

# update wd #
setwd(figures)



#### Plots: organized crime news geographical distribution, by decade ####
cities = c("Milano","Roma","Torino","Genova","Venezia","Firenze","Bologna")

# 1950 #
plot_oc_news_50 <- ggplot(data = maps) +
    geom_sf(aes(fill = ihs_n_news_50), color = NA, size = 0) +  # Set color = NA to remove borders
    scale_fill_distiller(palette = "Blues", direction = 1, name = "IHS of OC news", na.value = "white") +  # Use the "Blues" palette with normal direction
    geom_sf(data = regs_cn, fill = NA, color = "black", size = 1) +  # Add borders from regs_cn
    geom_text(data = maps[maps$COMUNE %in% cities,],
              aes(label = COMUNE, geometry = geometry), 
              color = "brown3", 
              size = 5, 
              stat = "sf_coordinates") +  # Add city labels in red
    theme_minimal() +
    theme(panel.border = element_blank(),  # Remove panel border
          axis.title = element_blank(),    # Remove axis titles
          axis.line = element_blank(),    # Remove axis lines
          axis.text = element_blank(),    # Remove axis text
          axis.ticks = element_blank(),   # Remove axis ticks
          panel.grid = element_blank(),
          legend.title = element_text(size = 14))   # Remove grid lines


# 1960 #
plot_oc_news_60 <- ggplot(data = maps) +
    geom_sf(aes(fill = ihs_n_news_60), color = NA, size = 0) +  # Set color = NA to remove borders
    scale_fill_distiller(palette = "Blues", direction = 1, na.value = "white") +  # Use the "Blues" palette with normal direction
    geom_sf(data = regs_cn, fill = NA, color = "black", size = 1) +  # Add borders from regs_cn
    geom_text(data = maps[maps$COMUNE %in% cities,],
              aes(label = COMUNE, geometry = geometry), 
              color = "brown3", 
              size = 5, 
              stat = "sf_coordinates") +  # Add city labels in red
    theme_minimal() +
    theme(panel.border = element_blank(),  # Remove panel border
          axis.title = element_blank(),    # Remove axis titles
          axis.line = element_blank(),    # Remove axis lines
          axis.text = element_blank(),    # Remove axis text
          axis.ticks = element_blank(),   # Remove axis ticks
          panel.grid = element_blank())   # Remove grid lines

# 1970 #
plot_oc_news_70 <- ggplot(data = maps) +
    geom_sf(aes(fill = ihs_n_news_70), color = NA, size = 0) +  # Set color = NA to remove borders
    scale_fill_distiller(palette = "Blues", direction = 1, na.value = "white") +  # Use the "Blues" palette with normal direction
    geom_sf(data = regs_cn, fill = NA, color = "black", size = 1) +  # Add borders from regs_cn
    geom_text(data = maps[maps$COMUNE %in% cities,],
              aes(label = COMUNE, geometry = geometry), 
              color = "brown3", 
              size = 5, 
              stat = "sf_coordinates") +  # Add city labels in red
    theme_minimal() +
    theme(panel.border = element_blank(),  # Remove panel border
          axis.title = element_blank(),    # Remove axis titles
          axis.line = element_blank(),    # Remove axis lines
          axis.text = element_blank(),    # Remove axis text
          axis.ticks = element_blank(),   # Remove axis ticks
          panel.grid = element_blank())   # Remove grid lines

# 1980 #
plot_oc_news_80 <- ggplot(data = maps) +
    geom_sf(aes(fill = ihs_n_news_80), color = NA, size = 0) +  # Set color = NA to remove borders
    scale_fill_distiller(palette = "Blues", direction = 1, na.value = "white") +  # Use the "Blues" palette with normal direction
    geom_sf(data = regs_cn, fill = NA, color = "black", size = 1) +  # Add borders from regs_cn
    geom_text(data = maps[maps$COMUNE %in% cities,],
              aes(label = COMUNE, geometry = geometry), 
              color = "brown3", 
              size = 5, 
              stat = "sf_coordinates") +  # Add city labels in red
    theme_minimal() +
    theme(panel.border = element_blank(),  # Remove panel border
          axis.title = element_blank(),    # Remove axis titles
          axis.line = element_blank(),    # Remove axis lines
          axis.text = element_blank(),    # Remove axis text
          axis.ticks = element_blank(),   # Remove axis ticks
          panel.grid = element_blank())   # Remove grid lines

# 1990 #
plot_oc_news_90 <- ggplot(data = maps) +
    geom_sf(aes(fill = ihs_n_news_90), color = NA, size = 0) +  # Set color = NA to remove borders
    scale_fill_distiller(palette = "Blues", direction = 1, na.value = "white") +  # Use the "Blues" palette with normal direction
    geom_sf(data = regs_cn, fill = NA, color = "black", size = 1) +  # Add borders from regs_cn
    geom_text(data = maps[maps$COMUNE %in% cities,],
              aes(label = COMUNE, geometry = geometry), 
              color = "brown3", 
              size = 5, 
              stat = "sf_coordinates") +  # Add city labels in red
    theme_minimal() +
    theme(panel.border = element_blank(),  # Remove panel border
          axis.title = element_blank(),    # Remove axis titles
          axis.line = element_blank(),    # Remove axis lines
          axis.text = element_blank(),    # Remove axis text
          axis.ticks = element_blank(),   # Remove axis ticks
          panel.grid = element_blank())   # Remove grid lines

# 2000 #
plot_oc_news_00 <- ggplot(data = maps) +
    geom_sf(aes(fill = ihs_n_news_00), color = NA, size = 0) +  # Set color = NA to remove borders
    scale_fill_distiller(palette = "Blues", direction = 1, na.value = "white") +  # Use the "Blues" palette with normal direction
    geom_sf(data = regs_cn, fill = NA, color = "black", size = 1) +  # Add borders from regs_cn
    geom_text(data = maps[maps$COMUNE %in% cities,],
              aes(label = COMUNE, geometry = geometry), 
              color = "brown3", 
              size = 5, 
              stat = "sf_coordinates") +  # Add city labels in red
    theme_minimal() +
    theme(panel.border = element_blank(),  # Remove panel border
          axis.title = element_blank(),    # Remove axis titles
          axis.line = element_blank(),    # Remove axis lines
          axis.text = element_blank(),    # Remove axis text
          axis.ticks = element_blank(),   # Remove axis ticks
          panel.grid = element_blank())   # Remove grid lines

# common plot #
ggsave("Figure-A1.png",
       ggarrange(plot_oc_news_50, 
          plot_oc_news_60, 
          plot_oc_news_70, 
          plot_oc_news_80,
          plot_oc_news_90,
          plot_oc_news_00,
          common.legend = TRUE, legend="bottom", align = "hv",
          labels = c("1950","1960","1970","1980","1990","2000")),
       dpi = 300, width = 10, height = 8, scale = 1.5)


