######################################################################!
#                                                                    #
#      Script 1: ADDING MASS METADATA TO HERBITRAITS                 #
#                                                                    #
######################################################################!

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # METADATA
    # This script adds mass metdata to the herbitraits dataset
    #
    # Output: an updated dataframe, in the form of a csv file
    # time: less than 1 min
    # Status: under construction (23 july 2020)
    # 
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####
##### 1. PREPARING THE DATA ##### 
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# – Clear Memory ####
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

rm(list = ls())  # clean memory (= remove)
graphics.off()  # close graphic windows

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# – Set working directory ####
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

setwd("/Users/au572919/Research/herbiTraits")
getwd()

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# – Set up libraries ####
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
library(gdata) # to read excel files

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# – Load Data ####
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

#Load HerbiTraits
herbiTraits_Master = read.xls(xls = "./Code/herbiTraits_v1_resub_v1.xlsx", sheet = 3, header = TRUE)
herbiTraits_Master[1:10,1:10]
dim(herbiTraits_Master)
herbiTraits_Master$Binomial.1.2 = gsub(" ", "_", herbiTraits_Master$Binomial.1.2)

# herbiTraits_Master = read.xls("./herbiTraits/herbiTraits_Master.xlsx", sheet = 2, header = TRUE)
# herbiTraits_Master[1:10,1:10]
# dim(herbiTraits_Master)

# Load PHYLACINE
# PHYLACINE = read.csv("/Users/au572919/datasets/Phylacine.1.2/Data/Traits/Trait_data.csv")
# PHYLACINE[1:10,1:10]
# dim(PHYLACINE)

PHYLACINE = read.csv("/Users/au572919/datasets/PHYLACINE_V1_2_1/Traits/Trait_data.csv")
PHYLACINE[1:10,1:10]
dim(PHYLACINE)

#Load HerbiTraits
Reference_List_HerbiTraits = read.xls("./herbiTraits/herbiTraits_Master.xlsx", sheet = 3, header = TRUE)
Reference_List_HerbiTraits[1:10,1:2]
dim(Reference_List_HerbiTraits)

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####
##### 2. ADD METADATA ##### 
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####

# Remove unecessary data
PHYLACINE_subset = PHYLACINE[which(PHYLACINE$Binomial.1.2 %in% herbiTraits_Master$Binomial.1.2),]
rm(PHYLACINE) #remove unnecessary data

# check which species are different
any((!(PHYLACINE_subset$Binomial.1.2 %in% herbiTraits_Master$Binomial.1.2))) # Are there species in PHYLACINE that don't occur in HerbiTraits_subset?
Added_Species = herbiTraits_Master[which((!(herbiTraits_Master$Binomial.1.2 %in% PHYLACINE_subset$Binomial.1.2))),"Binomial.1.2"] # The following species only occur in HerbiTraits

# Change colname
colnames(PHYLACINE_subset)[12] = "Mass.g.PHYLACINE"
colnames(PHYLACINE_subset)[13] = "Mass.Method.PHYLACINE"
colnames(PHYLACINE_subset)[14] = "Mass.Source.PHYLACINE"
colnames(PHYLACINE_subset)[15] = "Mass.Comparison.PHYLACINE"
colnames(PHYLACINE_subset)[16] = "Mass.Comparison.Source.PHYLACINE"

# Add Mass Metadata to HerbiTraits
herbiTraits_Master_v2 = merge(herbiTraits_Master, PHYLACINE_subset[c("Binomial.1.2", "Mass.g.PHYLACINE", "Mass.Method.PHYLACINE", "Mass.Source.PHYLACINE", "Mass.Comparison.PHYLACINE", "Mass.Comparison.Source.PHYLACINE")], by = "Binomial.1.2", all.x = T)

# Are values equal between PHYLACINE and herbitraits?
length(which(!(herbiTraits_Master_v2$Mass.g == herbiTraits_Master_v2$Mass.g.PHYLACINE))) #30 species have different mass values
herbiTraits_Master_v2[which(!(herbiTraits_Master_v2$Mass.g == herbiTraits_Master_v2$Mass.g.PHYLACINE)), "Binomial.1.2"]
temp = herbiTraits_Master_v2[which(!(herbiTraits_Master_v2$Mass.g == herbiTraits_Master_v2$Mass.g.PHYLACINE)), c("Binomial.1.2", "Mass.g","Mass.Reference", "Mass.g.PHYLACINE", "Mass.Method.PHYLACINE", "Mass.Source.PHYLACINE", "Mass.Comparison.PHYLACINE", "Mass.Comparison.Source.PHYLACINE")]
rm(temp)

temp = herbiTraits_Master_v2[which((herbiTraits_Master_v2$Mass.g == herbiTraits_Master_v2$Mass.g.PHYLACINE)), c("Binomial.1.2", "Mass.g","Mass.Reference", "Mass.g.PHYLACINE", "Mass.Method.PHYLACINE", "Mass.Source.PHYLACINE", "Mass.Comparison.PHYLACINE", "Mass.Comparison.Source.PHYLACINE")]

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####
##### 3. CHANGE MASS VALUES ##### 
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####

# These are all the species that Erick has edited, they include post-domestics and equid species
keep.mass.values = unique(c(which(herbiTraits_Master_v2$Post.Domestic == 1), which(herbiTraits_Master_v2$Mass.Reference == "AnAge: The Animal Ageing and Longevity Database")))
keep.mass.values.species = herbiTraits_Master_v2[keep.mass.values,"Binomial.1.2"] 
length(unique(keep.mass.values))

# Select all other species
change.mass.values.species = herbiTraits_Master_v2[-keep.mass.values,"Binomial.1.2"] 
length(unique(change.mass.values.species))

# Change mass values for other species
herbiTraits_Master_v2[which(herbiTraits_Master_v2$Binomial.1.2 %in% change.mass.values.species),"Mass.g"] = herbiTraits_Master_v2[which(herbiTraits_Master_v2$Binomial.1.2 %in% change.mass.values.species),"Mass.g.PHYLACINE"]

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####
##### 4. CHANGE MASS REFERENCES ##### 
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####

# We assume most of the data was taken from PHYLACINE v1.2.1
herbiTraits_Master_v2$Mass.reference.reworked = "Faurby et al. 2018 Ecology"
herbiTraits_Master_v2$Mass.reference.reworked = as.character(herbiTraits_Master_v2$Mass.reference.reworked)

# If PHYLACINE copied the data
herbiTraits_Master_v2[which(herbiTraits_Master_v2$Mass.Method.PHYLACINE == "Reported"),"Mass.reference.reworked"] = as.character(herbiTraits_Master_v2[which(herbiTraits_Master_v2$Mass.Method.PHYLACINE == "Reported"),"Mass.Source.PHYLACINE"])

# Sources for post-domestics
herbiTraits_Master_v2[which(herbiTraits_Master_v2$Binomial.1.2 %in% keep.mass.values.species),"Mass.reference.reworked"] = as.character(herbiTraits_Master_v2[which(herbiTraits_Master_v2$Binomial.1.2 %in% keep.mass.values.species),"Mass.Reference"])


# If it is an estimate by PHYLACINE, we refer to PHYLACINE DIRECTLY
#herbiTraits_Master_v2[which(herbiTraits_Master_v2$Mass.Method.PHYLACINE == "Reported"),"Mass.reference.reworked"] = herbiTraits_Master_v2[which(herbiTraits_Master_v2$Mass.Method.PHYLACINE == "Reported"),"Mass.Source.PHYLACINE"]

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####
##### 5. CHANGE REFERENCE STYLE ##### 
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####
 
## Check amount of work 
unique(herbiTraits_Master_v2[,"Mass.reference.reworked"])
sort(table(herbiTraits_Master_v2[,"Mass.reference.reworked"]))

## Change References
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Smith, F. A., et al. 2003. Body mass of late Quaternary mammals. Ecology 84:3403 (Updated Version 4.1 obtained from senior author)."),"Mass.reference.reworked"] = "Smith et al. 2003 Ecology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Wilson DE, Mittermeier RA. Handbook of the Mammals of the World - Volume 2 (2011)"),"Mass.reference.reworked"] = "Wilson and Mittermeier 2011 Handbook of the Mammals of the World"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Johnson C Australia's Mammal Extinctions. A 50000 year History (2007)"),"Mass.reference.reworked"] = "Johnson 2007 Australias Mammal Extinctions"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Werdelin L & Sanders WJ (eds) Cenozoic Mammals of Africa (2010). Subfossil Lemurs of Madagascar Godfrey LR, Jungers WL, Burney DA"),"Mass.reference.reworked"] = "Werdelin & Sanders 2010 Cenozoic Mammals of Africa"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Davis, M. 2017. What North America's skeleton crew of megafauna tells us about community disassembly. Proceedings of the Royal Socieity B 284:20162116."),"Mass.reference.reworked"] = "Davis 2017 Proc. of the Royal Society B"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Philosophical Transactions fo the Royal Society of London Series B 366: 2564-2576 (2011)"),"Mass.reference.reworked"] = "Turvey and Fritz 2011 Philos Trans R Soc Lond B"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Global Ecology and Biogeography 19: 475-484 (2010)"),"Mass.reference.reworked"] = "Raia et al. 2010 Global Ecology and Biogeography"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Global Ecology and Biogeography 18 :19-29 (2009)"),"Mass.reference.reworked"] = "Kelt and Meyer 2008 Global Ecology and Biogeography"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Larramendi, A. 2016. Shoulder height, body mass, and shape of proboscideans. Acta Palaeontologica Polonica 61:537-574."),"Mass.reference.reworked"] = "Larramendi 2016 Acta Palaeontologica Polonica"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Wilson, D. E., et al. 2011. Handbook of the Mammals of the World: 2. Hoofed Mammals. First edition. Lynx Edicions, Barcelona."),"Mass.reference.reworked"] = "Wilson and Mittermeier 2011 Handbook of the Mammals of the World"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Wilson, D. E., et al., editors. 2013. Handbook of the Mammals of the World: 3. Primates. First edition. Lynx Edicions, Barcelona."),"Mass.reference.reworked"] = "Wilson et al. 2013 Handbook of the Mammals of the World"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Rozzi, R. 2017. A new extinct dwarfed buffalo from Sulawesi and the evolution of the subgenus Anoa: an interdisciplinary perspective. Quaternary Science Reviews 157:188-205."),"Mass.reference.reworked"] = "Rozzi 2017 Quaternary Science Reviews"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Johnson, C. N., et al. 2004. Extinctions of herbivorous mammals in the late Pleistocene of Australia in relation to their feeding ecology: No evidence for environmental change as cause of extinction. Austral Ecology 29: 553-557."),"Mass.reference.reworked"] = "Johnson and Prideaux 2004 Austral Ecology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Zona arqueológica 4: 464-479 (2004)"),"Mass.reference.reworked"] = "Asensio et al. 2004 Zona arqueológica"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Journal of Human Evolution 32: 523-559 (2002)"),"Mass.reference.reworked"] = "Smith and Jungers 1997 Journal of Human Evolution"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Smith AT, Xie Y, Hoffmann RS, Lunde D, MacKinnon J, Wilson DE, Wozencraft WD. A Guide to the Mammals of China (2008)"),"Mass.reference.reworked"] = "Smith et al. 2008 A Guide to Mammals of China"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Mittermeier RA, Rylands AB,  Wilson DE Handbook of the Mammals of the World - Volume 3 (2013)"),"Mass.reference.reworked"] = "Wilson et al. 2013 Handbook of the Mammals of the World"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Quarternary International 182: 16-48 (2008)"),"Mass.reference.reworked"] = "Van Den Bergh et al. 2008 Quaternary International"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Paleobiology 38:308-321 (2012)"),"Mass.reference.reworked"] = "Wilson et al. 2012 Paleobiology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Webb, S. 2008. Megafauna demography and late Quaternary climatic change in Australia: a predisposition to extinction. Boreas 37:329-345."),"Mass.reference.reworked"] = "Webb 2008 Boreas"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Van Dyck S, Straham R. The Mammals of Australia Third edition (2008)"),"Mass.reference.reworked"] = "Van Duck and Straham 2008 The Mammals of Australia"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Palaeogeography, Palaeoclimatology, Palaeoecology 361-362:  84-93 (2012)"),"Mass.reference.reworked"] = "Faith et al. 2012 Palaeogeography, Palaeoclimatology, Palaeoecology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Wilson, D. E., et al. editors. 2016. Handbook of the Mammals of the World: 6. Lagomorphs and Rodents I. First edition. Lynx Edicions, Barcelona."),"Mass.reference.reworked"] = "Wilson et al. 2016 Handbook of the Mammals of the World"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Faurby et al. 2018 Ecology; Jones et al. 2009 Ecology"),"Mass.reference.reworked"] = "Jones et al. 2009 Ecology"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Tree Kangaroos A curoius Natural History. Flannery TF, Martin R, Szalay A (1996)"),"Mass.reference.reworked"] = "Flannery et al. 1996 Tree Kangaroos A curious Natural History"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Stinnesbeck, S. R., et al. 2017. A new fossil peccary from the Pleistocene-Holocene boundary of the eastern Yucatan Peninsula, Mexico. Journal of South American Earth Sciences 77:341-349."),"Mass.reference.reworked"] = "Stinnesbeck 2017 Journal of South Amercan Earth Sciences"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Science 308: 1161-1164 (2005)"),"Mass.reference.reworked"] = "Jones et al. 2005 Science"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Rivals, F., 2004. Les petits bovidés (Caprini et Rupicaprini) pléistocènes dans le bassin méditerranéen et le Caucase. Etude paléontologique, biostratigraphique, archéozoologique et paléoécologique. Archaeopress: Oxford"),"Mass.reference.reworked"] = "Rivals 2004 Archaeopress"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Reid FA. A field guide to the Mammals of Central America and South East Mexico (2009)"),"Mass.reference.reworked"] = "Reid 2009 Oxford University Press"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Records of the Australian Museum 45: 33-42 (1993)"),"Mass.reference.reworked"] = "Flannery 1993 Records of the Australian Museum"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Quarternary International 182: 90-108 (2008)"),"Mass.reference.reworked"] = "Ferretti 2008 Quaternary International"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Proceedings of the Royal Society of London Series B 279: 3193-3200 (2012)"),"Mass.reference.reworked"] = "Herridge and Lister 2012 Proc. of the Royal Society B"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Prevosti, F. J., et al. 2006. Paleoecology of the large carnivore guild from the late Pleistocene of Argentina. Acta Palaeontologica Polonica 51:407–422."),"Mass.reference.reworked"] = "Prevosti and Vizcaino 2006 Acta Palaeontologica Polonica"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Palmqvist, P., et al. 2003. Paleoecological reconstruction of a lower Pleistocene large mammal community using biogeochemical (δ13C, δ15N, δ18O, Sr:Zn) and ecomorphological approaches. Paleobiology 29:205-229."),"Mass.reference.reworked"] = "Palmqvist et al. 2003 Paleobiology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Palaeogeography, Palaeoclimatology, Palaeoecology 141 13-34 (1998)"),"Mass.reference.reworked"] = "Cerdeno 1998 Palaeogeography, Palaeoclimatology, Palaeoecology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Mittermeier RA, Rylands AB,  Wilson DE Handbook of the Mammals of the World - Volume 3 (2013) (as S. hypoleucus northern form)"),"Mass.reference.reworked"] = "Faurby et al. 2018 Ecology" # THIS SPECIES SHOULD HAVE A METHODS RANKING THAT MATCHES THE SOURCE

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Journal of Primatology 73: 458-473 (2011)"),"Mass.reference.reworked"] = "Biswas et al. 2011 American Journal of Primatology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Johnson, C. N., et al. 2004. Extinctions of herbivorous mammals in the late Pleistocene of Australia in relation to their feeding ecology: no evidence for environmental change as cause of extinction. Austral Ecology 29:553-557."),"Mass.reference.reworked"] = "Johnson and Prideaux 2004 Austral Ecology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Fieldiana Zoology 113: 1-58 (2007)"),"Mass.reference.reworked"] = "Fooden 2007 Fieldiana Zoology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Faurby et al. 2018 Ecology; Wilson and Mittermeier 2011 Handbook of the Mammals of the World"),"Mass.reference.reworked"] = "Wilson and Mittermeier 2011 Handbook of the Mammals of the World"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Faurby et al. 2018 Ecology; Smith et al. 2003 Ecology"),"Mass.reference.reworked"] = "Smith et al. 2003 Ecology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Davies, P. et al. 2001. Palaeoloxodon cypriotes, the dwarf elephant of Cyprus: size and scaling comparisons with P. falconeri (Sicily-Malta) and mainland P. antiquus. Pages 479-480 in G. Cavarretta, et al., editors. The World of Elephants. Rome."),"Mass.reference.reworked"] = "Faurby et al. 2018 Ecology"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Croitor, R., et al. 2008. Systematic revision of the endemic deer Haploidoceros n. gen. mediterraneus (Bonifay, 1967) (Mammalia, Cervidae) from the Middle Pleistocene of southern France. Palaontologische Zeitschrift 82:325-346."),"Mass.reference.reworked"] = "Croitor et al. 2008 Palaontologische Zeitschrift"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Bulletin of the Florida Museum of Natural History 45: 313-333 (2005)"),"Mass.reference.reworked"] = "McDonald 2005 Bulletin of the Florida Museum of Natural History"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Bibi, F., et al. 2015. Continuous evolutionary change in Plio-Pleistocene mammals of eastern Africa. Proceedings of the National Academy of Sciences 112:10623-10628."),"Mass.reference.reworked"] = "Bibi and Kiessling 2015 Proceedings of the National Academy of Sciences"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Annales Zoologica Femnica 36 93-102 (2011)"),"Mass.reference.reworked"] = "Christiansen 1999 Annales Zoologici Fennici"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Ameghiniana 48: 305-319 (2011)"),"Mass.reference.reworked"] = "Vizcaino et al. 2011 Ameghiniana"
herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Alberdi, M.T. et al. 1995. Patterns of body size changes in fossil and living Equini (Perissodactyla). Biological Journal of the Linnean Society, 54(4), 349–370."),"Mass.reference.reworked"] = "Alberdi et al. 1995 Biological Journal of the Linnean Society"

herbiTraits_Master_v2[which(herbiTraits_Master_v2[,"Mass.reference.reworked"] == "Acta Palaeontologica Polonica 51: 407-422 (2006)"),"Mass.reference.reworked"] = "Prevosti and Vizcaino 2006 Acta Palaeontologica Polonica"

# We have changed the publisher of books to the title so may have to be undone
# we have not checked this list with the final reference list yet.
# There was a mistake in Asensio et al. 2004 Zona arqueológica --> first author was wrong

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####
##### 6. ADD DIET CERTAINTY ##### 
#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––####

unique(herbiTraits_Master_v2$Species_Status)

temp = herbiTraits_Master_v2[which(herbiTraits_Master_v2$Species_Status %in% c("Extinct before 1500 CE", "Extinct after 1500 CE")),]
length(which(temp$Mass.reference.reworked == "Smith et al. 2003 Ecology"))
sort(table(temp$Mass.reference.reworked))
    
## Create New Variable
herbiTraits_Master_v2$Mass.Certainty = NA
table(herbiTraits_Master_v2$Mass.Method.PHYLACINE)

## Assigning classifications using the PHYLACINE Metadata
herbiTraits_Master_v2[which(herbiTraits_Master_v2$Mass.Method.PHYLACINE == "Imputed"),"Mass.Certainty"] = 0
herbiTraits_Master_v2[which(grepl("Estimated based on", herbiTraits_Master_v2$Mass.Method.PHYLACINE)),"Mass.Certainty"] = 1
herbiTraits_Master_v2[which(grepl("Assumed isometric based on", herbiTraits_Master_v2$Mass.Method.PHYLACINE)),"Mass.Certainty"] = 2
herbiTraits_Master_v2[which(herbiTraits_Master_v2$Mass.Method.PHYLACINE == "As relative of suggested similar size"),"Mass.Certainty"] = 2

## Assigning classifications using the PHYLACINE Metadata









Reference_List_HerbiTraits[190:200,2]

colnames(herbiTraits_Master_v2)


herbiTraits_Master_v2[which(herbiTraits_Master_v2$Mass.g == herbiTraits_Master_v2$Mass.g.PHYLACINE), "Mass.reference.reworked"] = herbiTraits_Master_v2[which(herbiTraits_Master_v2$Mass.g == herbiTraits_Master_v2$Mass.g.PHYLACINE), "Mass.Source"]

table(herbiTraits_Master_v2$Mass.reference.reworked)

length(which(is.na(herbiTraits_Master_v2$Mass.reference.2)))

# NOTE: the references should be formatted so they are in the appropriate style


temp[2,]



which(is.na(herbiTraits_Master_v2$Mass.g == herbiTraits_Master_v2$Mass.g.PHYLACINE))
herbiTraits_Master_v2$Mass.g 

temp = herbiTraits_Master_v2[which(!(herbiTraits_Master_v2$Mass.g == herbiTraits_Master_v2$Mass.g.PHYLACINE)), c("Binomial.1.2", "Mass.g","Mass.Reference", "Mass.g.PHYLACINE", "Mass.Method.PHYLACINE", "Mass.Source.PHYLACINE", "Mass.Comparison.PHYLACINE", "Mass.Comparison.Source.PHYLACINE")]




# Arctotherium_tarijense	--> no ref
# Bubalus_depressicornis --> 
