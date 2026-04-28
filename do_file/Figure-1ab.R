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



#### Plots: forced resettlement geographical distribution and surnames ####
cities = c("Milano","Roma","Torino","Genova","Venezia","Firenze","Bologna")

# plot #
maps$confino <- as.factor(maps$confino)
plot_confino <- ggplot(data = maps) +
  geom_sf(aes(fill = confino), color = NA, size = 0) +  # Set color = NA to remove borders
  scale_fill_manual(values = c("white","navy"), name = "Exposure to FR", na.value = "white") +  # Use the "Blues" palette with normal direction
  geom_sf(data = regs_cn, fill = NA, color = "black", size = 1) +  # Add borders from regs_cn
  geom_text(data = maps[maps$COMUNE %in% cities,],
            aes(label = COMUNE, geometry = geometry), 
            color = "brown4", 
            size = 10, 
            stat = "sf_coordinates") +  # Add city labels in red
  theme_minimal() +
  theme(panel.border = element_blank(),  # Remove panel border
        axis.title = element_blank(),    # Remove axis titles
        axis.line = element_blank(),    # Remove axis lines
        axis.text = element_blank(),    # Remove axis text
        axis.ticks = element_blank(),   # Remove axis ticks
        panel.grid = element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.title = element_text(size = 14))   # Remove grid lines

# save it #
ggsave("Figure-1a.png", plot_confino, dpi = 300, width = 10, height = 8, scale = 1.5)   # save it

# plot #
plot_surnames <- ggplot(data = maps) +
  geom_point(data = maps[maps$share_surname_conf > 0,], 
             aes(geometry = geometry, size = share_surname_conf), 
             color = "navy", stat = "sf_coordinates") +  # Add bubbles with varying sizes
  labs(size = "Share of surnames FR") +  # Add legend title for size
  geom_sf(data = regs_cn, fill = NA, color = "black", size = 1) +  # Add borders from regs_cn
  geom_text(data = maps[maps$COMUNE %in% cities,],
            aes(label = COMUNE, geometry = geometry), 
            color = "brown4", 
            size = 10, 
            stat = "sf_coordinates") +  # Add city labels in red
  theme_minimal() +
  theme(panel.border = element_blank(),  # Remove panel border
        axis.title = element_blank(),    # Remove axis titles
        axis.line = element_blank(),    # Remove axis lines
        axis.text = element_blank(),    # Remove axis text
        axis.ticks = element_blank(),   # Remove axis ticks
        panel.grid = element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.title = element_text(size = 14))   # Remove grid lines

# save it #
ggsave("Figure-1b.png", plot_surnames, dpi = 300, width = 10, height = 8, scale = 1.5)   # save it
