
# Functions to be written -------------------------------------------------
getTaxaList
getCoresList
getSitesList
getCountriesList
getRegionsList
getGroupsList 

getCoreID(by e_, by name, by coordinates, by country, by region)
getSiteID(by e_, by name, by coordinates, by country, by region)
getTaxonID(by id, by taxa name, by genus, by family, by type -pollen, etc-)
getGroupID
getCountryID
getRegionID

# Installing the EPDr package ---------------------------------------------
library(devtools)
install_github("dinilu/EPDr", force=T)


# Connecting to the DDBB server in diegonl.ugr.es -------------------------
library(EPDr)
connEPD <- connectToEPD(host="diegonl.ugr.es", database="epd_ddbb", user="epdr", password="epdrpw")
dbListTables(connEPD)
dbGetQuery(connEPD, "SELECT e_ FROM synevent;")
disconnectFromEPD(connEPD)


library(EPDr)
connEPD <- connectToEPD(host="diegonl.ugr.es", database="epd_ddbb", user="epdr", password="epdrpw")
c14 <- extractC14(400, connEPD)
chron <- extractChronologies(400, connEPD)

c14.clam <- c14toCLAM(c14)
noc14.clam <- noC14toCLAM(chron$no_C14)

synevent <- dbGetQuery(connEPD, "SELECT * FROM synevent WHERE e_ = 51;")
event <- dbGetQuery(connEPD, paste("SELECT * FROM event WHERE event_ = ", synevent$event_, ";", sep=""))
event <- merge(synevent, event, by="event_")
event.clam <- eventtoCLAM(event)


# Section 1 - Recalibrate chronologies ------------------------------------------
library(EPDr)
connEPD <- connectToEPD(host="diegonl.ugr.es", database="epd_ddbb", user="epdr", password="epdrpw")

# Site with one chronologies with EXTRA data
core4Clam(1, connEPD, get.dephts=T)
clam("1")

# Site with two chronologies, one with EXTRA data
core4Clam(4, connEPD, get.dephts=T)
clam("4")


# Cores with events
eventList <- unique(dbGetQuery(connEPD, "SELECT e_ FROM synevent;")[,1])
#[1]   51  141  220  457  554  571  679  806  868  874  932  966  980 1030 1031 1032
lapply(eventList[c(4:6, 11:13, 15)], core4Clam, connEPD, get.dephts=T)
core4Clam(1032, connEPD, get.dephts=T)


# Site with two chronologies and events
core4Clam("874", connEPD, get.dephts=T)
disconnectFromEPD(connEPD)

# Cores with sections
unique(as.numeric(dbGetQuery(connEPD, "SELECT e_ FROM section;")[,1]))
#[1] 271 318 456 605 883
core4Clam("271", connEPD, get.dephts=T)
disconnectFromEPD(connEPD)

