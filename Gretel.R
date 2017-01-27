library(devtools)
install_github("dinilu/EPDr", force=T)

library(EPDr)

rm(list=ls())

connEPD <- connectToEPD(host="localhost", database="epd", user="epdr", password="epdrpw")
entity.list <- e_by_countries(c("Spain","Portugal", "France", "Switzerland", "Austria", "Italy", "Malta", "Algeria", "Tunisia", "Morocco", "Atlantic ocean", "Mediterranean Sea"), connEPD)
entity.list <- listE(connEPD)$e_
counts.all <- lapply(entity.list, getAgedCounts, connEPD)

counts.po <- lapply(counts.all, filterTaxaGroups, c("HERB", "TRSH", "DWAR", "LIAN", "HEMI", "UPHE"))
counts.gi <- lapply(counts.po, gieseckeDefaultChronology)
counts.un <- removeRestricted(counts.gi)
counts.wa <- removeWithoutAges(counts.un)


percent.wa <- lapply(counts.wa, trans2Percentages)

percent.int <- lapply(percent.wa, interpolateCounts, seq(0, 22000, by=1000))

percent.ran <- lapply(percent.wa[14], intervalsCounts, seq(0, 21000, by=1000), seq(999, 21999, by=1000))

for(ii in c(1110:length(entity.list))){
}

epd.taxonomy <- getTaxonomyEPD(connEPD)

counts.wa.acc <- lapply(counts.wa, taxa2AcceptedTaxa, epd.taxonomy)
percent.wa.acc <- lapply(percent.wa, taxa2AcceptedTaxa, epd.taxonomy)
percent.ran.acc <- lapply(percent.ran, taxa2AcceptedTaxa, epd.taxonomy)
percent.int.acc <- lapply(percent.int, taxa2AcceptedTaxa, epd.taxonomy)

counts.wa.hig <- lapply(counts.wa, taxa2HigherTaxa, epd.taxonomy)
percent.wa.hig <- lapply(percent.wa, taxa2HigherTaxa, epd.taxonomy)
percent.ran.hig <- lapply(percent.ran, taxa2HigherTaxa, epd.taxonomy)
percent.int.hig <- lapply(percent.int, taxa2HigherTaxa, epd.taxonomy)

counts.wa.uni <- unifyTaxonomy(counts.wa.acc, epd.taxonomy)
percent.wa.uni <- unifyTaxonomy(percent.wa.acc, epd.taxonomy)
percent.ran.uni <- unifyTaxonomy(percent.ran.acc, epd.taxonomy)
percent.int.uni <- unifyTaxonomy(percent.int.acc, epd.taxonomy)


entity.list <- sapply(counts.wa.uni, extract_e)
datation.co.wa.uni <- lapply(entity.list, getDatation, connEPD)

entity.list <- sapply(percent.wa.uni, extract_e)
datation.pe.wa.uni <- lapply(entity.list, getDatation, connEPD)

entity.list <- sapply(percent.ran.uni, extract_e)
datation.pe.ran.uni <- lapply(entity.list, getDatation, connEPD)

entity.list <- sapply(percent.int.uni, extract_e)
datation.pe.int.uni <- lapply(entity.list, getDatation, connEPD)


# Aquí me quedo con el problema de que hay algunos e_ que tienen NA en las fechas y casca a la hora de calcular el indice de calidad
for(ii in 1:length(entity.list)){
    counts.wa.uni.q <- mapply(qualityIndex, counts.wa.uni[ii], datation.co.wa.uni[ii])
}
percent.wa.uni.q <- mapply(qualityIndex, percent.wa.uni, datation.pe.wa.uni)
percent.ran.uni.q <- mapply(qualityIndex, percent.ran.uni, datation.pe.ran.uni)
percent.int.uni.q <- mapply(qualityIndex, percent.int.uni, datation.pe.int.uni)



# Journals:
#   Quartenary International

Cedrus <- c("Cedrus", "Cedrus atlantica", "Cedrus cf. C. atlantica", "Cedrus-type", "cf. Cedrus")

mapTaxaAge(percent.unr.ranges.acc, Cedrus, "0-1000", pres_abse=T, pollen_thres=NULL, zoom_coords=NULL, points_pch=21,
               points_colour=c("Red", "Blue"), points_fill=c("Red", "Blue"), points_range_size=c(1.5, 3), map_title=NULL,
               legend_range=NULL, legend_title=NULL, napoints_size=0.75, napoints_pch=19, 
               napoints_colour="grey45", napoints_fill=NA, countries_fill_colour="grey80", countries_border_colour="grey90")

mapTaxaAge(percent.unr.ranges,  Cedrus, "20000-22000", pres_abse=T, pollen_thres=0)(percent.unr.ranges,  Cedrus, "20000-22000", pres_abse=T, pollen_thres=0)
mapTaxaAge(percent.unr.ranges, Cedrus, "5500-6500", pres_abse=F, legend_range=c(0,5))
mapTaxaAge(percent.unr.ranges,  Cedrus, "20000-22000", pres_abse=F, legend_range=c(0,5))

Pinus <- c("Pinus", "Pinus pinaster", "Pinus pinea", "Pinus sylvestris", "Pinus-type", "Pinus sp.")
mapTaxaAge(percent.unr.ranges, Pinus, "5500-6500", pres_abse=T)
mapTaxaAge(percent.unr.ranges, Pinus, "20000-22000", pres_abse=T)
mapTaxaAge(percent.unr.ranges, Pinus, "5500-6500", pres_abse=F)
mapTaxaAge(percent.unr.ranges, Pinus, "20000-22000", pres_abse=F)
