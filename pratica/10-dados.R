library(shiny)
library(dplyr)
library(ggplot2)

dados <- readr::read_rds(here::here("dados/credito.rds"))

ui <- fluidPage(
  titlePanel("Proporção de clientes bons vs clientes ruins"),
  sliderInput(
    "idade",
    label = "Selecione o intervalo de idade",
    min = min(dados$idade),
    max = max(dados$idade),
    value = c(18, 30),
    step = 1
  ),
  checkboxGroupInput(
    "estado_civil",
    label = "Selecione os estados civis",
    choices = sort(unique(dados$estado_civil)),
    selected = "solteira(o)"
  ),
  selectInput(
    "trabalho",
    label = "Selecione o tipo de trabalho",
    choices = sort(unique(dados$trabalho)),
    multiple = TRUE,
    selected = c("fixo", "meio período")
  ),
  plotOutput("grafico")
)

server <- function(input, output, session) {

  output$grafico <- renderPlot({

    browser()

    dados |>
      filter(
        idade >= input$idade[1],
        idade <= input$idade[2],
        estado_civil %in% input$estado_civil,
        trabalho %in% input$trabalho
      ) |>
      ggplot(aes(x = status)) +
      geom_bar()

  })

}

shinyApp(ui, server)
