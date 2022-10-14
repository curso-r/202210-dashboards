library(shiny)
library(dplyr)

ui <- navbarPage(
  title = "App com navbarPage",
  # theme = bslib::bs_theme(version = 4),
  theme = shinythemes::shinytheme("superhero"),
  tabPanel(
    title = "Página 1",
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
    hr(),
    fluidRow(
      column(
        offset = 3,
        width = 6,
        plotOutput("grafico")
      )
    )
  ),
  tabPanel(
    title = "Página 2",
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "var3",
          label = "Selecione a variável",
          choices = names(mtcars)
        )
      ),
      mainPanel(
        tableOutput("tabela")
      )
    )
  ),
  navbarMenu(
    "Mais páginas",
    tabPanel(
      title = "Página 3",
      h2("Conteúdo da página 3")
    ),
    tabPanel(
      title = "Página 4",
      h2("Conteúdo da página 4")
    ),
    tabPanel(
      title = "Página 5",
      h2("Conteúdo da página 5")
    ),
  )
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({
    plot(x = mtcars[[input$var1]], y = mtcars[[input$var2]])
  })

  output$tabela <- renderTable({
    mtcars |>
      slice_max(order_by = .data[[input$var3]], n = 5)
  })

}

shinyApp(ui, server)
