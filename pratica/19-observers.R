library(shiny)
library(dplyr)

dados <- readr::read_rds(here::here("dados/pkmn.rds"))

ui <- fluidPage(
  titlePanel("Pokémon"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(
        inputId = "geracao",
        label = "Selecione a geração",
        choices = unique(dados$id_geracao)
      ),
      selectInput(
        inputId = "pokemon",
        label = "Selecione um pokemon",
        choices = c("Carregando..." = "")
      )
      # uiOutput("select_pokemon")
    ),
    mainPanel = mainPanel(
      fluidRow(
        column(
          width = 3,
          offset = 2,
          shinyWidgets::addSpinner(uiOutput("imagem"))
        )
      )
    )
  )
)

server <- function(input, output, session) {


  observe({

    withProgress(message = "Atualizando opções de pokemon...", {

      incProgress(0.1)

      Sys.sleep(1)

      incProgress(0.4)

      Sys.sleep(1)

      incProgress(0.4)

      pokemon <- dados |>
        filter(id_geracao == input$geracao) |>
        pull(pokemon)

      updateSelectInput(
        session = session,
        inputId = "pokemon",
        choices = pokemon
      )

      Sys.sleep(0.5)

      incProgress(0.1)

    })


  })


  # output$select_pokemon <- renderUI({
  #
  #   Sys.sleep(4)
  #
  # pokemon <- dados |>
  #   filter(id_geracao == input$geracao) |>
  #   pull(pokemon)
  #
  #   selectInput(
  #     inputId = "pokemon",
  #     label = "Selecione o pokemon",
  #     choices = pokemon
  #   )
  # })

  base_filtrada <- reactive({
    Sys.sleep(4)
    dados |>
      filter(pokemon == input$pokemon)
  })


  output$imagem <- renderUI({

    req(input$pokemon)

    # validate(need(
    #   isTruthy(input$pokemon),
    #   "Espere enquanto o app é atualizado..."
    # ))

    if (input$pokemon == "") {
      stop("EERRO SUPER FEIO QUE VAI APARECER NA TELA!")
    }

    id <-  base_filtrada() |>
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
