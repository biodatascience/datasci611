library(shiny)
library(tidyverse)

city_df = read_csv(url("https://gist.githubusercontent.com/Miserlou/11500b2345d3fe850c92/raw/e36859a9eef58c231865429ade1c142a2b75f16e/gistfile1.txt"), skip=3)

# Define UI for app that draws a histogram and a data table----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Integer for the number of bins ----
      numericInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram and table----
      plotOutput(outputId = "popPlot"),
      dataTableOutput(outputId = "popTable")
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # renderPlot creates histogram and links to ui
  output$popPlot <- renderPlot({
    bins = seq(min(city_df$population, na.rm = T), 
               max(city_df$population, na.rm = T), 
               length.out = input$bins + 1)
    
    ggplot(city_df, aes(x=population)) +
      geom_histogram(breaks = bins) +
         labs(x = "Population size",
              title = "Histogram of US city populations") +
      scale_y_log10()
  })
  
  # Data table output, linked to ui
  output$popTable <- renderDataTable({city_df})
}

shinyApp(ui = ui, server = server)