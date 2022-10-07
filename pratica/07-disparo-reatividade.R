library(shiny)

ui <- fluidPage(
  textInput(
    inputId = "entrada",
    label = "Escreva o texto de entrada",
    value = "a"
  ),
  textOutput(
    outputId = "saida"
  )
)

server <- function(input, output, session) {

  texto <- reactive({
    print("Rodei o reactive")
    input$entrada
  })


  output$saida <- renderText({
    print("Rodei o renderText")
    input$entrada
  })

}

shinyApp(ui, server)
