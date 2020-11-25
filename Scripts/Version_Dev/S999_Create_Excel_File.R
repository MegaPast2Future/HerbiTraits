######################################################################!
#                                                                    #    
#     S999: Create Excel File                                        #
#                                                                    #
######################################################################!

# Explanation: This files takes the three CSV files (HerbiTraits_Metadata, HerbiTraits_Data, HerbiTraits_References) and combines them into an excel file.
# Output: An Excel file named "HerbiTraits_Dev"
# Duration: Less than one minute
# Status: finished (2020/11/25)

#–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

## Clear Working Memory
rm(list = ls())  # clean memory 
graphics.off()  # close graphic windows

## Working Directory
getwd()

## Load Libraries
#install.packages('openxlsx')
library("openxlsx")

# Create File Paths
path <- "./Data/Version_Dev/HerbiTraits_Dev" # File path
filenames_list <- list.files(path= path, full.names=TRUE) # List of all files in the folder

## Load CSV files
HerbiTraits_Data = read.csv(filenames_list[which(grepl("_Data", filenames_list))])
HerbiTraits_Metadata = read.csv(filenames_list[which(grepl("_Metadata", filenames_list))])
HerbiTraits_References = read.csv(filenames_list[which(grepl("_References", filenames_list))])

## Create a blank workbook
OUT <- createWorkbook()

## Add sheets to the workbook
addWorksheet(OUT, "MetaData")
addWorksheet(OUT, "Data")
addWorksheet(OUT, "References")

## Write the data to the sheets
writeData(OUT, sheet = "MetaData", x = HerbiTraits_Metadata)
writeData(OUT, sheet = "Data", x = HerbiTraits_Data)
writeData(OUT, sheet = "References", x = HerbiTraits_References)

## Export the file
saveWorkbook(OUT, "./Data/Version_Dev/HerbiTraits_Dev/HerbiTraits_Dev.xlsx")
