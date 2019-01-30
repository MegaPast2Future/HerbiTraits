
####################################################################!
#
# PREPARE METADATA ----------------------------------------------------------------------------
#
####################################################################!
#
# January 30, 2019
# E.J. Lundgren
#
# Aim: Extract column names from herbiTraits and annotate
#

# Load libraries and workspace------------------------------------------------------------------
library(data.table)

traitdir <- "/Users/elundgren/Documents/Projects/Functional_Diversity_Master/herbiTraits/Data"

# Load data ------------------------------------------------------------------------------------


list.files(traitdir)
traits <- data.table(read.csv(paste0(traitdir, "/herbiTraits v0.1.csv")))

# Extract column names -------------------------------------------------------------------------

cols <- names(traits)

# Create metadata data.table -------------------------------------------------------------------
metadata <- data.table(column = cols, 
                       type = rep("", length(cols)), 
                       description = rep("", length(cols)),
                       notes = rep("", length(cols)),
                       to_do = rep("", length(cols)))
metadata

# Fill in metadata -----------------------------------------------------------------------------
metadata[column %in% c("Binomial.1.2", 
                       "pre_domestic_name",
                       "Order.1.2",
                       "Family.1.2"), `:=` (type = "Taxonomy ID", description = "Based on Phylacine_1.2")]

metadata[column == "pre_domestic_name", notes := "NA except for domestic species where these column contains pre-domestic Species name"]

metadata[column == "k_medoid_herbivore", `:=` (type = "Inclusion ID", description = "Based on kmedoid analysis conducted by @SimonSchowaneck",
                                              notes = "Subset by 'yes' to exclude marginal herbivores" )]

metadata[column %in% c("Mass.g", "guild", "Diet.Graminoids", "Diet.Browse.Fruit", "Diet.Meat_median",
                       "Inferred.Fermentation.Type", "Inferred.Fermentation.Efficiency",
                       "Foraging.Terrestrial", "Foraging.Arboreal", "Foot.Type.Coarse"), 
         `:=` (type = "Ready Data", description = "Analysis ready data",
                                               notes = "" )]


metadata[column %in% c("Fermentation.Type","Foot.Type"), 
         `:=` (type = "Raw Data", description = "Raw, unconsolidated data",
               notes = "" )]

metadata[column %in% c("Foraging.Aquatic","Food.Handling", "Diet.Seed", "Diet.Fruit",
                       "Diet.Nectar", "Diet.Root", "Herd.Size", "Digging.Rooting"), 
         `:=` (type = "Incomplete Data", description = "Insubstantial literature; incomplete",
               notes = "" )]
metadata

metadata[column %in% c("Mass.Method", "Browsing.Grazing.Method", "Fermentation.Type.Method", 
                       "Digging.Rooting.Methods"), 
         `:=` (type = "Data Methods", description = "Method of primary data acquisition",
               notes = "" )]

metadata[column %in% c("Mass.Source", "Mass.Comparison", "Mass.Comparison.Source", 
                       "Browsing.Grazing.Source", "Fermentation.Type.Source", "Foraging.Stratum.Source",
                       "Food.Handling.Source", "Herd.Size.Source", "Digging.Rooting.Source",
                       "Foot.Type.Source"), 
         `:=` (type = "Data Sources", description = "",
               notes = "", to_do = "Requires reformating" )]

metadata[grepl(".Notes", column), 
         `:=` (type = "Notes", description = "",
               notes = "", to_do = "" )]

metadata

metadata[column == "Other.Notes", `:=` (type = "Notes", description = "Additional traits, natural history comments")]

metadata

# Write to csv ----------------------------------------------------------------------------------------

write.csv(metadata, "/Users/elundgren/Documents/Projects/Functional_Diversity_Master/herbiTraits/Metadata/Column Names and Descriptions v0.1.csv", row.names = FALSE)
