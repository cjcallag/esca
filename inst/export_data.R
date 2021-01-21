library(sf)
ft_ord <- esca::ft_ord
roads  <- esca::roads
esca   <- esca::esca_parcels

# Clean data ===================================================================
delete_me <- row.names(
  esca[esca$COENumber == "S1.3.2" & esca$imparea_id != "CSUMB Off-Campus", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber %in% c("E38", "E39", "E42", "E41", "E40") &
         esca$imparea_id != "Interim Action Range", ])
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "L5.7" & esca$imparea_id != "County North", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "L20.5.1" & esca$imparea_id != "Barloy Canyon", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "E19a.4" & esca$imparea_id != "Parker Flats", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "E19a.3" & esca$imparea_id != "Parker Flats", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "E20c.2" & esca$imparea_id != "Parker Flats", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "E21b.3" & esca$imparea_id != "Parker Flats", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "E23.2" & esca$imparea_id != "Seaside", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "L20.18" & esca$imparea_id != "Parker Flats", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]

# Add MRA variables ============================================================
esca[["mra"]] <- "Group 1"
esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("County North",
                                                    "CSUMB Off-Campus"),
                        "Group 2",
                        esca[["mra"]])
esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("Barloy Canyon", 
                                                    "DRO / Monterey", 
                                                    "Interim Action Range",
                                                    "Laguna Seca Parking",
                                                    "MOUT"),
                        "Group 3",
                        esca[["mra"]])
esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("Future East Garrison"),
                        "Group 4",
                        esca[["mra"]])

# Roads ========================================================================
roads$rid <- 1:nrow(roads)
# clean <- st_intersection(roads, esca, sparse = TRUE)
# roads <- roads[roads$rid %in% clean$rid, ]
# roads <- roads[roads$surface_type == "Paved", ]

library(ggplot2)
ggplot() +
  geom_sf(data = ft_ord) +
  geom_sf(data = esca) +
  geom_sf(data = roads)

st_write(roads[, c("name", "surface_type", "condition")],
         "for_eric/roads.shp",
         append = FALSE)
st_write(esca[, c("COENumber", "ParcelName", "HMP_category", "MRA", "Jurisdiction", "mra")],
         "for_eric/esca.shp",
         append = FALSE)
st_write(ft_ord,
         "for_eric/ft_ord.shp",
         append = FALSE)

gates2 <- esca::gates[!is.na(gates$gate_type == "Controlled Roadway Gate"), ]


