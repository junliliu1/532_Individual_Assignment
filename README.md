# Supply Chain Dashboard (R Shiny)

This application is an individual assignment re-implementing the group project supply chain dashboard using Shiny for R.

## About

This interactive dashboard allows supply chain managers to analyze shipping costs across different transportation modes and routes. The application provides filtering capabilities and visualizations for data-driven decision making.

## Features

- **Input Components** (3 filters):
  - Product Category selector
  - Transportation Mode selector
  - Supplier selector
- **Reactive Calculation**: Data filtering based on all selected filters
- **Output Components** (4 total):
  - Average Shipping Cost value box
  - Inspection Pass Rate value box
  - Customer Demographics bar chart
  - Defect Rates by Supplier bar chart

## Installation

### Prerequisites

- R (version 4.0 or higher)
- RStudio (recommended)

### Install Required Packages

Open R or RStudio and run the following commands:

```r
install.packages(c("shiny", "bslib", "ggplot2", "dplyr", "tidyr"))
```

## Running the Application Locally

1. Clone this repository:
```bash
git clone https://github.com/junliliu1/532_Individual_Assignment.git
cd 532_Individual_Assignment
```

2. Open R or RStudio and set the working directory to the project folder

3. Run the application:
```r
shiny::runApp()
```

Alternatively, if using RStudio, open `app.R` and click the "Run App" button.

The application will open in your default web browser at `http://127.0.0.1:XXXX`.

## Deployment

The live application is deployed on Posit Connect Cloud at: https://019ceae4-5499-6944-b853-3f75dd89d0e3.share.connect.posit.cloud/

## Data

The application uses supply chain data from the original group project, including information on:
- Transportation modes
- Shipping routes
- Shipping costs
- Product types
- Supplier information

## Group Project Reference

This individual assignment is based on the group project: [Supply Chain Analytics Dashboard](https://github.com/UBC-MDS/DSCI-532_2026_27_Supply_Chain_Dashboard)

## License

MIT License
