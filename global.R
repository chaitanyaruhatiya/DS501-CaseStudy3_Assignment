################
###Chaitanya Ruhatiya
###DS-501 Fall 2022 Case Study-3
###############

library(shiny)

GTdata <- read.csv(file = 'Data/gt_2011.csv')
GTdata
#data frame class
# colnames(GTdata) = c("Ambient Temperature (Celsius)", "Ambient Pressure (mbar)",
#                      "Ambient Humidity (%)", "Air filter difference pressure (mbar)",
#                      "Gas turbine exhaust pressure (mbar)","Turbine inlet temperature (Celsius)",
#                      "Turbine after temperature (Celsius)","Turbine energy yield (MWh)",
#                      "Compressor discharge pressure (mbar)","Carbon Monoxide (mg/m3)", "Nitrogen oxides (mg/m3)")

# GTdata <- head(GTdata, 100)


