library(shiny)
library(ggplot2)

ui <- fluidPage(
  "Um gráfico de dispersão da base mtcars",
  plotOutput(outputId = "grafico", height = "500px", width = "50%"),
  "Gráfico das variáveis mpg x wt"
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({
    mtcars |>
      ggplot(aes(x = wt, y = mpg)) +
      geom_point()
  })

}

shinyApp(ui, server)
