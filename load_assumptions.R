
library(dplyr)

# Load assumptions passed from Excel/VBA
assumptions <- read.csv("inputs_for_r.csv")

# Round values
assumptions$Value <- round(assumptions$Value, digits = 4) # Round values
 
# Create variables
current.age <- assumptions$Value[assumptions$Assumption == "Current Age"]
retirement.age <- assumptions$Value[assumptions$Assumption == "Retirement Age"]
death.age <- assumptions$Value[assumptions$Assumption == "Death Age"]
current.savings <- assumptions$Value[assumptions$Assumption == "Current Savings"]
annual.contribution <- assumptions$Value[assumptions$Assumption == "Annual Contribution"]
retirement.spending <- assumptions$Value[assumptions$Assumption == "Retirement Spending"]
inflation.rate <- assumptions$Value[assumptions$Assumption == "Inflation Rate"]
mean.return <- assumptions$Value[assumptions$Assumption == "Mean Return"]
sd.return <- assumptions$Value[assumptions$Assumption == "Return SD"]
num.simulations <- assumptions$Value[assumptions$Assumption == "Number of Simulations"]
