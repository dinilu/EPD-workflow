##----------------------------------------------------------------------------------------
## M?DULO 3 : EJECUSION DEL CODIGO DE CLAM.R
library(EPDr)

connEPD <- connectToEPD(host="localhost", database="epd_ddbb", user="epdr", password="epdrpw")

dbListTables(connEPD)

# Obtener un listado con aquellos testigos que tengan puntos de control >= 4.
sitesList <- dbGetQuery(connEPD, "select distinct e_ from agebasis where sample_ >= 4 order by e_ desc")
sitesList <- as.vector(sitesList$e_)

#  Selecci?n del testigo de inter?s (identificador del core en la EPD)
prueba <- lapply(sitesList, FUN=function(x, y, z){try(getSiteForClam(x, y, z))}, connEPD, TRUE)

okSites <- sitesList[unlist(lapply(prueba, is.null))]
nonOkSites <- sitesList[!unlist(lapply(prueba, is.null))]

write.csv(nonOkSites, file="sitiosRevisar.csv")

prueba2 <- lapply(okSites, function(x){try(clam(as.character(x)))})
okSites2 <- okSites[unlist(lapply(prueba2, is.null))]
nonOkSites2 <- okSites[!unlist(lapply(prueba2, is.null))]

disconnectFromEPD(con=connEPD)








