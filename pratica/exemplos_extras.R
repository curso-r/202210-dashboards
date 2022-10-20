library(shiny)
library(bs4Dash)
library(dplyr)
library(ggplot2)

imdb <- readr::read_rds(here::here("dados/imdb.rds"))

generos <- imdb |>
  tidyr::separate_rows(generos, sep = "\\|") |>
  pull(generos) |>
  unique() |>
  sort()

# generos <- imdb |>
#   pull(generos) |>
#   stringr::str_split(pattern = "\\|") |>
#   unlist() |>
#   unique() |>
#   sort()

ui <- dashboardPage(
  dashboardHeader(title = "App IMDB"),
  dashboardSidebar(sidebarMenu(
    menuItem(
      text = "Informações gerais",
      tabName = "info",
      icon = icon("info-circle")
    ),
    menuItem(
      text = "Visão por elenco",
      tabName = "elenco",
      icon = icon("users")
    )
    # Fazer mais uma página reproduzindo a página do elenco para os
    # diretores e diretoras (direção)
  )),
  dashboardBody(tabItems(
    tabItem(
      tabName = "info",
      h2("Informações gerais"),
      hr(),
      fluidRow(box(
        width = 12,
        title = "Filtros",
        fluidRow(
          column(
            width = 3,
            sliderInput(
              inputId = "ano",
              label = "Selecione o ano",
              min = min(imdb$ano, na.rm = TRUE),
              max = max(imdb$ano, na.rm = TRUE),
              value = c(2001, 2010),
              sep = ""
            )
          ),
          column(
            width = 3,
            offset = 1,
            shinyWidgets::pickerInput(
              inputId = "genero",
              label = "Selecione um gênero",
              choices = generos,
              multiple = TRUE,
              selected = generos,
              options = shinyWidgets::pickerOptions(
                actionsBox = TRUE,
                deselectAllText = "Remover todos",
                selectAllText = "Selecionar todos"
              )
            )
          )
        )
      )),
      fluidRow(
        valueBoxOutput("vb_num_filmes", width = 2),
        valueBoxOutput("vb_num_dir", width = 2)
        # Quantos atores e atrizes trabalharam nos filmes selecionados
        # Orçamento médio dos filme selecionados
        # Receita média dos filmes selecionados
        # Nota média dos filmes selecionados
        # Duração média (min) dos filmes selecionados
      ),
      fluidRow(column(
        width = 6,
        offset = 3,
        tableOutput("tabela")
      ))
    ),
    tabItem(
      tabName = "elenco",
      # selectInput(
      #   "sel_ator",
      #   "Selecione um ator/atriz",
      # choices = imdb |>
      #   tidyr::pivot_longer(
      #     cols = starts_with("ator"),
      #     names_to = "prioridade_ator",
      #     values_to = "nome_ator"
      #   ) |>
      #   distinct(nome_ator) |>
      #   pull() |>
      #   sort()
      # ),
      shinyWidgets::pickerInput(
        "sel_ator",
        "Seleciona um ator/atriz",
        choices = imdb |>
          tidyr::pivot_longer(
            cols = starts_with("ator"),
            names_to = "prioridade_ator",
            values_to = "nome_ator"
          ) |>
          distinct(nome_ator) |>
          pull() |>
          sort(),
        options = shinyWidgets::pickerOptions(actionsBox = TRUE,
                                              liveSearch = TRUE)
      ),
      plotOutput("grafico_ator")
      # Dado um ator/atriz, mostrar um gráfico de barras com os filmes
      # feitos por essa pessoa no eixo y e a nota do filme no eixo x
    )
  )),
  dashboardControlbar(id = "controlid",
                      controlbarMenu(
                        p("Esse e o controbar"),
                        selectInput(
                          "filtra_cor",
                          "Filtrar por cor",
                          multiple = TRUE,
                          choices = imdb |>
                            distinct(cor) |>
                            pull(cor) |>
                            sort(),
                          selected = imdb |>
                            distinct(cor) |>
                            pull(cor) |>
                            sort()
                        )


                      ))
)

server <- function(input, output, session) {
  base_geral <- reactive({
    imdb |>
      filter(cor %in% input$filtra_cor)
  })

  observeEvent(input$filtra_cor, {
    shinyWidgets::updatePickerInput(
      session = session,
      inputId = "sel_ator",
      choices = base_geral() |>
        tidyr::pivot_longer(
          cols = starts_with("ator"),
          names_to = "prioridade_ator",
          values_to = "nome_ator"
        ) |>
        distinct(nome_ator) |>
        pull() |>
        sort()
    )
    input$sel_ator
  })


  base_filtrada <- reactive({
    base_geral() |>
      tidyr::separate_rows(generos, sep = "\\|") |>
      filter(ano >= input$ano[1],
             ano <= input$ano[2],
             generos %in% input$genero)
  })

  output$vb_num_filmes <- renderValueBox({
    num_filmes <- base_filtrada() |>
      distinct(titulo, ano, diretor) |>
      nrow() |>
      scales::number(big.mark = ".", decimal.mark = ",")


    valueBox(
      value = num_filmes,
      subtitle = "Número de filmes",
      color = "purple",
      icon = icon("film")
      # href = "https://curso-r.com"
    )

  })


  output$vb_num_dir <- renderValueBox({
    num_dir <- base_filtrada() |>
      distinct(diretor) |>
      nrow() |>
      scales::number(big.mark = ".", decimal.mark = ",")


    valueBox(
      value = num_dir,
      subtitle = "Número de diretores/diretoras",
      color = "purple",
      icon = icon("video")
    )

  })

  output$tabela <- renderTable({
    base_filtrada() |>
      distinct(titulo, ano, diretor, receita) |>
      slice_max(order_by = receita, n = 10) |>
      mutate(receita = scales::dollar(receita, big.mark = ".", decimal.mark = ",")) |>
      rename(
        Título = titulo,
        Ano = ano,
        Direção = diretor,
        Bilheteria = receita
      )
  })


  # aba elenco --------------------------------------------------------------

  output$grafico_ator <- renderPlot({
    # Dado um ator/atriz, mostrar um gráfico de barras com os filmes
    # feitos por essa pessoa no eixo y e a nota do filme no eixo x
    base_geral() |>
      tidyr::pivot_longer(cols = starts_with("ator"),
                          names_to = "prioridade_ator",
                          values_to = "nome_ator") |>
      filter(nome_ator == input$sel_ator) |>
      ggplot() +
      geom_col(aes(x = titulo, y = nota_imdb))

  })

}

shinyApp(ui, server)
