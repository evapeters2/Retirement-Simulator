
# Execute everything in my load_assumptions and monte_carlo_simulation files
source("load_assumptions.R")
source("monte_carlo_simulation.R")

# Load libraries
library(ggplot2)
library(scales)

# Run one simulation to then plot one simulated retirement path
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

# Plot the one simulated retirement path
ggplot(sim$Projection, aes(x = Age, y = Balance)) +
  
  # Shade accumulation years
  annotate(
    "rect",
    xmin = current.age,
    xmax = retirement.age,
    ymin = -Inf,
    ymax = Inf,
    alpha = 0.15
  ) +
  
  # Shade retirement years
  annotate(
    "rect",
    xmin = retirement.age,
    xmax = death.age,
    ymin = -Inf,
    ymax = Inf,
    alpha = 0.08
  ) +
  
  # Portfolio balance
  geom_line(linewidth = 1) +
  
  # Retirement age marker
  geom_vline(
    xintercept = retirement.age,
    linetype = "dashed",
    linewidth = 0.8
  ) +
  
  # Label retirement age
  annotate(
    "text",
    x = retirement.age + 1,
    y = max(sim$Projection$Balance) * 0.95,
    label = "Retirement",
    hjust = 0
  ) +
  
  labs(
    title = "Example Simulated Retirement Path",
    subtitle = "Single Monte Carlo Simulation",
    x = "Age",
    y = "Portfolio Balance ($)"
  ) +
  
  scale_y_continuous(labels = label_comma()) +
  
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 18
    ),
    plot.subtitle = element_text(
      hjust = 0.5,
      size = 13
    ),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )

# Histogram of ending balances
x.max <- quantile(results$Ending.Balance, 0.99)

ggplot(results, aes(x = Ending.Balance)) +
  geom_histogram(bins = 40) +
  coord_cartesian(xlim = c(0, x.max)) +
  scale_x_continuous(labels = label_comma()) +
  labs(
    title = "Distribution of Ending Retirement Balances",
    subtitle = "99% of Simulated Outcomes",
    x = "Ending Balance ($)",
    y = "Number of Simulations"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 18),
    plot.subtitle = element_text(hjust = 0.5, size = 13),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )

# Success vs failure
success.df <- data.frame(
  Outcome = c("Success", "Failure"),
  Count = c(
    sum(results$Success),
    sum(!results$Success)
  )
)

ggplot(success.df,
       aes(x = Outcome,
           y = Count,
           fill = Outcome)) +
  geom_col(width = 0.6) +
  scale_y_continuous(labels = label_comma()) +
  labs(
    title = "Retirement Success Rate",
    subtitle = "Monte Carlo Simulation Results",
    x = NULL,
    y = "Number of Simulations"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 18
    ),
    plot.subtitle = element_text(
      hjust = 0.5,
      size = 13
    ),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.position = "none"
  )

# Contribution sensitivity analysis: how retirement success changes as savings behavior changes

# Create sequence of contribution amounts
contributions <- seq(2000, 20000, by = 1000)

# Create empty data frame
sensitivity <- data.frame(
  Contribution = contributions,
  SuccessRate = NA
)

# Rerun simulation for each contribution level
for(j in 1:length(contributions)) {
  
  contribution <- contributions[j]
  
  temp.results <- data.frame(
    Success = logical(1000)
  )
  
  for(i in 1:1000) {
    
    sim <- simulate_retirement(
      current.age,
      retirement.age,
      death.age,
      current.savings,
      contribution,
      retirement.spending,
      mean.return,
      sd.return,
      inflation.rate
    )
    
    temp.results$Success[i] <- sim$Success
  }
  
  sensitivity$SuccessRate[j] <-
    mean(temp.results$Success)
}

# Plot results
ggplot(sensitivity,
       aes(x = Contribution,
           y = SuccessRate)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_x_continuous(labels = dollar_format()) +
  scale_y_continuous(
    labels = percent_format(),
    limits = c(0, 1)
  ) +
  labs(
    title = "Effect of Annual Contributions on Retirement Success",
    subtitle = "Sensitivity Analysis",
    x = "Annual Contribution ($)",
    y = "Probability of Success"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 18
    ),
    plot.subtitle = element_text(
      hjust = 0.5,
      size = 13
    ),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )
