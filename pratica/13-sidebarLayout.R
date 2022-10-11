library(shiny)
library(dplyr)

dados <- readr::read_rds(here::here("dados/pkmn.rds"))

ui <- fluidPage(
  titlePanel("Pokémon"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(
        inputId = "pokemon",
        label = "Selecione o pokemon",
        choices = unique(dados$pokemon)
      )
    ),
    mainPanel = mainPanel(
      imageOutput("imagem")
    )
  )
)

server <- function(input, output, session) {

  output$imagem <- renderImage(deleteFile = TRUE, {

    url <- dados |>
      filter(pokemon == input$pokemon) |>
      pull(url_imagem)

    arq_temp <- tempfile()
    httr::GET(url, httr::write_disk(arq_temp, overwrite = TRUE))

    list(
      src = arq_temp
    )

  })

}

shinyApp(ui, server)
