library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  title = "Meu app",
  skin = "purple",
  dashboardHeader(title = "shinydashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Página 1",
        tabName = "pag1"
      ),
      menuItem(
        "Página 2",
        tabName = "pag2"
      ),
      menuItem(
        "Página 3",
        tabName = "pag3"
      )
    ),
    fluidRow(
      column(
        offset = 1,
        width = 5,
        "Texto 1"
      ),
      column(
        width = 5,
        "Texto 2"
      )
    ),
    fluidRow(
      column(
        width = 10,
        offset = 1,
        selectInput(
          "var3",
          label = "Selecione a variável",
          choices = names(mtcars)
        )
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "pag1",
        h2("Conteúdo da página 1"),
        hr(),
        fluidRow(
          column(
            width = 3,
            selectInput(
              "var1",
              label = "Selecione a variável",
              choices = names(mtcars)
            )
          ),
          column(
            width = 3,
            selectInput(
              "var2",
              label = "Selecione a variável",
              choices = names(mtcars)
            )
          )
        ),
        fluidRow(
          column(
            width = 12,
            plotOutput("grafico")
          )
        ),
        fluidRow(
          column(
            width = 6,
            fluidRow(
              column(
                width = 7,
                plotOutput("grafico2")
              )
            )
          )
        )
      ),
      tabItem(
        tabName = "pag2",
        h2("Conteúdo da página 2")
      ),
      tabItem(
        tabName = "pag3",
        h2("Conteúdo da página 3")
      )
    )
  )
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({
    plot(x = mtcars[[input$var1]], y = mtcars[[input$var2]])
  })

  output$grafico2 <- renderPlot({
    plot(x = mtcars[[input$var1]], y = mtcars[[input$var2]])
  })

}

shinyApp(ui, server)
