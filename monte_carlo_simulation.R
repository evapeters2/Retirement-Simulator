
# Ensure working directory is set
setwd("C:/Users/User/OneDrive/Retirement_Simulator")

# Execute everything in my load_assumptions file
source("load_assumptions.R")

# Create retirement function
simulate_retirement <- function(
    current.age,
    retirement.age,
    death.age,
    current.savings,
    annual.contribution,
    retirement.spending,
    mean.return,
    sd.return,
    inflation.rate
) {
  
  # Create empty projection data frame to eventually store values
  projection <- data.frame(
    Age = current.age:death.age,
    Return = NA,
    Contribution = NA,
    Withdrawal = NA,
    Balance = NA
  )
  
  # Set initial balance
  projection$Balance[1] <- current.savings
  
  # Loop through each year
  for(i in 2:nrow(projection)) {
    
    # Generate and store a random investment return
    annual.return <- rnorm(1, mean.return, sd.return)
    projection$Return[i] <- annual.return
    
    # Determine the person's age
    age <- projection$Age[i]
    
    # Accumulation years (before retirement)  
    if(age < retirement.age) {
      
      projection$Contribution[i] <- annual.contribution
      projection$Withdrawal[i] <- 0
      
      # FV = PV(1+i)^n 
      # In this case FV = projection balance = previous balance * (1 + annual return) + annual contribution
      # We are assuming that we are making each contribution at the end of each year
      projection$Balance[i] <- (projection$Balance[i - 1] * (1 + annual.return)) + annual.contribution
      
      # Retirement years    
    } else {
      
      years.retired <- age - retirement.age
      
      # Takes into account inflation during spending years
      withdrawal <- retirement.spending * (1 + inflation.rate)^years.retired
      
      projection$Contribution[i] <- 0
      projection$Withdrawal[i] <- withdrawal
      
      projection$Balance[i] <- (projection$Balance[i - 1] * (1 + annual.return)) - withdrawal
    }
  }

  # Define success or failure 
  ending.balance <- tail(projection$Balance, 1)
  success <- ending.balance > 0  
  
  return(list(
    Success = success,
    Ending.Balance = ending.balance,
    Projection = projection
  ))
}

# Create results data frame
results <- data.frame(
  Simulation = 1:num.simulations,
  Success = NA,
  Ending.Balance = NA
)

# Run the specified number of simulations
for(i in 1:num.simulations) {
  
  sim <- simulate_retirement(
    current.age,
    retirement.age,
    death.age,
    current.savings,
    annual.contribution,
    retirement.spending,
    mean.return,
    sd.return,
    inflation.rate
  )
  
  results$Success[i] <- sim$Success
  results$Ending.Balance[i] <- sim$Ending.Balance
}

# Retirement success probability
mean(results$Success)

# Create a summary table
summary.results <- data.frame(
  Metric = c(
    "Number of Simulations",
    "Success Probability",
    "Average Ending Balance",
    "Median Ending Balance",
    "10th Percentile Ending Balance",
    "25th Percentile Ending Balance",
    "75th Percentile Ending Balance",
    "90th Percentile Ending Balance",
    "Minimum Ending Balance",
    "Maximum Ending Balance"
  ),
  Value = c(
    nrow(results),
    mean(results$Success),
    mean(results$Ending.Balance),
    median(results$Ending.Balance),
    quantile(results$Ending.Balance, 0.10),
    quantile(results$Ending.Balance, 0.25),
    quantile(results$Ending.Balance, 0.75),
    quantile(results$Ending.Balance, 0.90),
    min(results$Ending.Balance),
    max(results$Ending.Balance)
  )
)

# Export results for VBA
write.table(
  summary.results,
  "C:/Users/User/OneDrive/Retirement_Simulator/results_output.txt",
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE
)


# INDIVIDUAL PROJECTION

# Create empty data frame to store values
projection <- data.frame(
  Age = current.age:death.age,
  Return = 0,
  Contribution = 0,
  Withdrawal = 0,
  Balance = 0
)

# Set initial balance
projection$Balance[1] <- current.savings

# Loop through each year
for(i in 2:nrow(projection)) {
  
  annual.return <- rnorm(1, mean.return, sd.return)
  projection$Return[i] <- annual.return
  
  age <- projection$Age[i]
  
  # Accumulation years (before retirement)  
  if(age < retirement.age) {
    
    projection$Contribution[i] <- annual.contribution
    projection$Withdrawal[i] <- 0
    
    # FV = PV(1+i)^n 
    # In this case FV = projection balance = previous balance * (1 + annual return) + annual contribution
    # We are assuming that we are making each contribution at the end of each year
    projection$Balance[i] <- (projection$Balance[i - 1] * (1 + annual.return)) + annual.contribution
    
    # Retirement years    
  } else {
    
    years.retired <- age - retirement.age
    
    withdrawal <- retirement.spending * (1 + inflation.rate)^years.retired
    
    projection$Contribution[i] <- 0
    projection$Withdrawal[i] <- withdrawal
    
    projection$Balance[i] <- (projection$Balance[i - 1] * (1 + annual.return)) - withdrawal
  }
}

# Export projection for VBA to import
write.table(
  projection,
  "C:/Users/User/OneDrive/Retirement_Simulator/projection_output.txt",
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE
)

