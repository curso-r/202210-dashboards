library(shiny)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  titlePanel("App com o sorteio de uma mostra"),
  sliderInput(
    inputId = "tamanho_amostra",
    label = "Selecione o tamanho da amostra",
    min = 1,
    max = 1000,
    value = 100,
    step = 5
  ),
  plotOutput("grafico"),
  textOutput("texto_do_num_mais_sortedo")
)

server <- function(input, output, session) {


  output$grafico <- renderPlot({
    amostra <- sample(1:10, input$tamanho_amostra, replace = TRUE)

    # amostra |>
    #   table() |>
    #   barplot()

    tibble::tibble(
      valores = amostra
    ) |>
      ggplot(aes(x = valores)) +
      geom_bar()

  })

  output$texto_do_num_mais_sortedo <- renderText({
    valor_mais_sorteado <- tibble::tibble(
      valores = amostra
    ) |>
      count(valores, name = "freq") |>
      slice_max(order_by = freq, n = 1) |>
      pull(valores)

    paste0("O valor mais sorteado foi o ", valor_mais_sorteado, ".")

  })


}

shinyApp(ui, server)
