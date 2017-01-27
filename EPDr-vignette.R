
# Installing the EPDr package ---------------------------------------------
library(devtools)
install_github("dinilu/EPDr", force=T)


# DDBB connection functions ----
library(EPDr)
connEPD <- connectToEPD(host="localhost", database="epd", user="epdr", password="epdrpw")
dbListTables(connEPD)
dbGetQuery(connEPD, "SELECT e_ FROM synevent;")
disconnectFromEPD(connEPD)


# Search functions ----
connEPD <- connectToEPD(host="localhost", database="epd", user="epdr", password="epdrpw")

# List functions ----

# Get functions ----
c14 <- getC14(400, connEPD)
chron <- getChronologies(400, connEPD)

# Export functions ----
c14.clam <- exportC14(c14)
noc14.clam <- noC14toCLAM(chron$no_C14)

# Extract functions ----

# Standardize functions ----

# Tabulate functions ----

# Plotting functions ----


# Section 1 - Recalibrate chronologies ------------------------------------------

# Site with one chronologies with EXTRA data
core4Clam(1, connEPD)
clam("1")

# Site with two chronologies, one with EXTRA data
core4Clam(4, connEPD)
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

