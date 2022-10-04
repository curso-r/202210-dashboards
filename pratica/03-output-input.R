library(shiny)
library(ggplot2)

ui <- fluidPage(
  "Gráficos de dispersão da base mtcars",
  selectInput(
    inputId = "variavel",
    label = "Selecione a variável do eixo X",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "grafico"),
  textOutput(outputId = "texto")
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({
    mtcars |>
      ggplot(aes(x = .data[[input$variavel]], y = mpg)) +
      geom_point()
  })

  output$texto <- renderText({
    paste("Gráfico de dispersão das variáveis mpg x", input$variavel)
  })

}

shinyApp(ui, server)
