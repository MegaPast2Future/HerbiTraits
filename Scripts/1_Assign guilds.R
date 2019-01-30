

####################################################################!
#
# ASSIGN DIETARY GUILDS------------------------------------------------------------
#
####################################################################!
#
# January 30, 2019
# E.J. Lundgren
#
# Assign dietary guilds based on diet
# This data column "guild" is already present in dataset, but this script shows the relation between 
# ordinal diet variables and our guild designations
#

# Load libraries and workspace------------------------------------------------------------------
library(data.table)

# Load data ------------------------------------------------------------------------------------

traits <- data.table(read.csv("./Data/herbiTraits v0.1.csv"))

##basing this on the grazing/browsing framework from @Simon:
#grazers: greater than 2 for graminoids, 1 or less for browse
traits[Diet.Graminoids >= 2 & Diet.Browse.Fruit <= 1, guild := "grazer"]
traits[guild == "grazer", ]$Binomial.1.2 #review species
nrow(traits[guild == "grazer", ])#94 grazers

#browsers: the inverse
traits[Diet.Graminoids <= 1 & Diet.Browse.Fruit >= 2, guild := "browser"]# the inverse
traits[guild == "browser", ]$Binomial.1.2 #review species
nrow(traits[guild == "browser", ])#252 browsers

#mixed feeders: >= 2 for graminoids, >= 2 for browsers
traits[Diet.Graminoids >= 2 & Diet.Browse.Fruit >= 2,  guild := "mixed feeder"]
nrow(traits[guild == "mixed feeder"])#182 mixed feeders

#which are NA?
traits[is.na(guild)]#6

#omnivores
traits[Diet.Meat_median > 1, ]$Binomial.1.2#guild := "omnivore"
#these look like reasonable omnivores
traits[Diet.Meat_median > 1, guild := "omnivore"]#guild := "omnivore"
traits[guild == "omnivore", ]

#any NAs?
traits[is.na(guild)]

View(traits)

# Write to csv: ---------------------------------------------------------------------------
write.csv(traits, 
          paste0(traitdir, "/herbiTraits v0.1.csv"),
          row.names = FALSE)
