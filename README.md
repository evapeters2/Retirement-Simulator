# Retirement Readiness Monte Carlo Simulator

## Project Overview

After beginning to invest in my own Roth IRA, I became interested in how different saving habits, investment returns, and retirement assumptions could affect long-term financial outcomes. Wanting to apply my actuarial and statistical programming skills to a topic that genuinely interested me, I developed this retirement planning application.

The project combines R, Excel, and VBA to perform Monte Carlo simulations of retirement portfolios under thousands of possible market scenarios. Users can modify retirement assumptions directly in Excel and run the simulation with a single button, automatically generating updated projections, summary statistics, and visualizations.

## Features

- Interactive Excel interface for retirement assumptions
- Monte Carlo simulation engine written in R
- Automated communication between Excel and R using VBA
- Retirement success probability calculation
- Summary statistics for ending retirement balances
- Annual retirement projection table
- Dynamic retirement balance visualization
- Input validation to prevent invalid simulations

## Technologies Used

- R
- Excel
- VBA
- Monte Carlo Simulation
- Statistical Modeling

## How It Works

1. The user enters retirement assumptions in Excel.
2. VBA validates the inputs.
3. VBA exports the assumptions to a CSV file.
4. R imports the assumptions and performs the Monte Carlo simulation.
5. Thousands of retirement scenarios are simulated using randomly generated annual investment returns.
6. Summary statistics and an annual projection are written to output files.
7. VBA imports the results back into Excel and updates the Results and Projection worksheets.

## Model Assumptions

- Annual investment returns follow a normal distribution.
- Contributions are made at the end of each working year.
- Retirement withdrawals increase annually with inflation.
- Annual investment returns are assumed to be independent.
- A successful simulation is defined as maintaining a positive account balance throughout retirement.

## Project Structure

Retirement-Monte-Carlo-Simulator/

├── Excel/
│   └── Retirement_Simulator_Final.xlsm
│
├── R/
│   ├── monte_carlo_simulation.R
│   ├── load_assumptions.R
│   └── visualizations.R
│
├── Images/
│   ├── inputs.png
│   ├── results.png
│   └── projection.png
│
└── README.md

## Screenshots

### Inputs

Users can modify retirement assumptions directly in Excel before running the simulation.

![Inputs](Images/inputs.png)

### Results

The application reports retirement success probability along with summary statistics for ending retirement balances.

![Results](Images/results.png)

### Projection

A year-by-year projection illustrates how the retirement account balance evolves throughout accumulation and retirement.

![Projection](Images/projection.png)

## Future Improvements

- Support additional withdrawal strategies
- Allow user-defined investment allocations that can vary year to year
- Model taxes and Social Security income
- Include historical return simulations
- Add sensitivity analysis and additional charts

## Author

Eva Peters

Bachelor of Science in Statistics (Actuarial Science Concentration)

University of Wisconsin–La Crosse

