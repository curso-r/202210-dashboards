library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  title = "Meu app",
  skin = "purple",
  dashboardHeader(title = "shinydashboard"),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
