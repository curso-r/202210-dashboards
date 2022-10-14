library(shiny)
library(dplyr)

dados <- readr::read_rds(here::here("dados/pkmn.rds"))

ui <- fluidPage(
  # theme = bslib::bs_theme(version = 4),
  theme = shinythemes::shinytheme("slate"),
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
      fluidRow(
        column(
          offset = 5,
          width = 2,
          # imageOutput("imagem")
          uiOutput("imagem")
        )
      )
    )
  )
)

server <- function(input, output, session) {

  # output$imagem <- renderImage(deleteFile = TRUE, {
  #
  #   id <- dados |>
  #     filter(pokemon == input$pokemon) |>
  #     pull(id) |>
  #     stringr::str_pad(width = 3, side = "left", pad = "0")
  #
  #   url <- glue::glue(
  #     "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
  #   )
  #
  #   # Download da imagem
  #   arq_temp <- tempfile()
  #   httr::GET(url, httr::write_disk(arq_temp, overwrite = TRUE))
  #
  #   list(
  #     src = arq_temp,
  #     width = "100%"
  #   )
  #
  # })


  output$imagem <- renderUI({

    id <- dados |>
      filter(pokemon == input$pokemon) |>
      pull(id) |>
      stringr::str_pad(width = 3, side = "left", pad = "0")

    url <- glue::glue(
      "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
    )

    img(
      src = url,
      width = "100%"
    )

  })

}

shinyApp(ui, server)
