library(shiny)

ui <- fluidPage(
  "Gráfico 1",
  selectInput(
    inputId = "variavel_1",
    label = "Eixo X do gráfico 1",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "grafico_1"),
  "Gráfico 2",
  selectInput(
    inputId = "variavel_2",
    label = "Eixo X do gráfico 2",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "grafico_2"),
)

server <- function(input, output, session) {

  output$grafico_1 <- renderPlot({
    print("Rodei o gráfico 1")
    plot(x = mtcars[[input$variavel_1]], y = mtcars$mpg)
  })

  output$grafico_2 <- renderPlot({
    print("Rodei o gráfico 2")
    plot(x = mtcars[[input$variavel_2]], y = mtcars$wt)
  })

}

shinyApp(ui, server)
