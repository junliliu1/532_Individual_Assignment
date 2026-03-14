library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(tidyr)

df <- read.csv("data/supply_chain_data.csv")

CP <- c("#0072B2", "#D55E00", "#009E73", "#CC79A7", "#F0E442", "#56B4E9", "#E69F00")

ui <- page_sidebar(
  title = "Supply Chain Dashboard",
  sidebar = sidebar(
    h5("Global Filters"),
    selectInput(
      "product_type",
      "Product Category",
      choices = c("All", sort(unique(df$Product.type))),
      selected = "All"
    ),
    selectInput(
      "transport_mode",
      "Transportation Mode",
      choices = c("All", sort(unique(df$Transportation.modes))),
      selected = "All"
    ),
    selectInput(
      "supplier",
      "Supplier",
      choices = c("All", sort(unique(df$Supplier.name))),
      selected = "All"
    )
  ),
  layout_columns(
    layout_columns(
      value_box(
        title = "Average Shipping Cost",
        value = textOutput("avg_shipping_cost"),
        theme = "primary"
      ),
      value_box(
        title = "Inspection Pass Rate",
        value = textOutput("pass_rate"),
        theme = "success"
      ),
      col_widths = c(6, 6)
    ),
    layout_columns(
      card(
        card_header("Customer Demographics"),
        plotOutput("demo_chart", height = "300px")
      ),
      card(
        card_header("Defect Rates by Supplier"),
        plotOutput("defect_chart", height = "300px")
      ),
      col_widths = c(6, 6)
    ),
    col_widths = c(12, 12)
  )
)

server <- function(input, output, session) {

  filtered_data <- reactive({
    data <- df

    if (input$product_type != "All") {
      data <- data %>% filter(Product.type == input$product_type)
    }

    if (input$transport_mode != "All") {
      data <- data %>% filter(Transportation.modes == input$transport_mode)
    }

    if (input$supplier != "All") {
      data <- data %>% filter(Supplier.name == input$supplier)
    }

    data
  })

  output$avg_shipping_cost <- renderText({
    avg <- mean(filtered_data()$Shipping.costs, na.rm = TRUE)
    paste0("$", round(avg, 2))
  })

  output$pass_rate <- renderText({
    pass_count <- sum(filtered_data()$Inspection.results == "Pass", na.rm = TRUE)
    total <- nrow(filtered_data())
    if (total > 0) {
      rate <- (pass_count / total) * 100
      paste0(round(rate, 1), "%")
    } else {
      "N/A"
    }
  })

  output$demo_chart <- renderPlot({
    demo_summary <- filtered_data() %>%
      count(Customer.demographics) %>%
      arrange(desc(n))

    ggplot(demo_summary, aes(x = reorder(Customer.demographics, n), y = n)) +
      geom_bar(stat = "identity", fill = CP[6]) +
      coord_flip() +
      labs(
        title = "Customer Count by Demographics",
        x = NULL,
        y = "Count"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10)
      )
  })

  output$defect_chart <- renderPlot({
    defect_summary <- filtered_data() %>%
      group_by(Supplier.name) %>%
      summarise(avg_defect = mean(Defect.rates, na.rm = TRUE)) %>%
      arrange(desc(avg_defect))

    ggplot(defect_summary, aes(x = reorder(Supplier.name, avg_defect), y = avg_defect)) +
      geom_bar(stat = "identity", fill = CP[2]) +
      coord_flip() +
      labs(
        title = "Average Defect Rate by Supplier",
        x = NULL,
        y = "Defect Rate (%)"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10)
      )
  })
}

shinyApp(ui = ui, server = server)
