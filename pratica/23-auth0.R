library(shiny)
library(bs4Dash)
library(dplyr)

# install.packages("reactable")
# install.packages("abjData")

pnud <- abjData::pnud_min

ui <- bs4DashPage(
  dark = NULL,
  header = bs4DashNavbar(
    title = "Dados da PNUD"
  ),
  sidebar = bs4DashSidebar(
    bs4SidebarMenu(
      bs4SidebarMenuItem(
        text = "Tabelas",
        icon = icon("table"),
        bs4SidebarMenuSubItem(
          text = "reactable",
          tabName = "reactable"
        ),
        bs4SidebarMenuSubItem(
          text = "DT",
          tabName = "dt"
        )
      ),
      bs4SidebarMenuItem(
        text = "Gráficos",
        icon = icon("line-chart"),
        bs4SidebarMenuSubItem(
          text = "echarts",
          tabName = "echarts"
        ),
        bs4SidebarMenuSubItem(
          text = "plotly",
          tabName = "plotly"
        ),
        bs4SidebarMenuSubItem(
          text = "highcharts",
          tabName = "highcharts"
        )
      ),
      bs4SidebarMenuItem(
        text = "Mapas com leaflet",
        icon = icon("map"),
        tabName = "leaflet"
      )
    )
  ),
  body = bs4DashBody(
    bs4TabItems(
      bs4TabItem(
        tabName = "reactable",
        h2("Exemplo com reactable"),
        fluidRow(
          bs4Card(
            width = 12,
            title = "Filtros",
            fluidRow(
              column(
                width = 3,
                selectInput(
                  inputId = "ano_reactable",
                  label = "Selecione um ano",
                  choices = sort(unique(pnud$ano), decreasing = TRUE)
                )
              ),
              column(
                width = 3,
                selectInput(
                  inputId = "metrica_reactable",
                  label = "Selecione uma métrica",
                  choices = c(
                    "IDHM" = "idhm",
                    "Esperança de vida" = "espvida",
                    "Renda per capita" = "rdpc",
                    "Índice de Gini" = "gini"
                  )
                )
              )
            )
          )
        ),
        fluidRow(
          column(
            width = 12,
            reactable::reactableOutput(
              outputId = "tabela"
            )
          )
        )
      ),
      bs4TabItem(
        tabName = "dt",
        h2("Exemplo com DT")
      ),
      bs4TabItem(
        tabName = "echarts",
        h2("Exemplo com echarts"),
        fluidRow(
          bs4Card(
            width = 12,
            title = "Filtros",
            fluidRow(
              column(
                width = 3,
                selectInput(
                  inputId = "ano_echarts",
                  label = "Selecione um ano",
                  choices = sort(unique(pnud$ano), decreasing = TRUE)
                )
              ),
              column(
                width = 3,
                selectInput(
                  inputId = "eixo_x",
                  label = "Selecione o eixo X",
                  choices = c(
                    "IDHM" = "idhm",
                    "Renda per capita" = "rdpc",
                    "Índice de Gini" = "gini",
                    "População" = "pop"
                  )
                )
              )
            )
          )
        ),
        fluidRow(
          column(
            width = 12,
            echarts4r::echarts4rOutput("grafico")
          )
        )
      ),
      bs4TabItem(
        tabName = "plotly",
        h2("Exemplo com plotly")
      ),
      bs4TabItem(
        tabName = "highcharts",
        h2("Exemplo com highcharts")
      ),
      bs4TabItem(
        tabName = "leaflet",
        h2("Exemplo com leaflet"),
        fluidRow(
          bs4Card(
            width = 12,
            title = "Filtros",
            fluidRow(
              column(
                width = 3,
                selectInput(
                  inputId = "ano_leaflet",
                  label = "Selecione um ano",
                  choices = sort(unique(pnud$ano), decreasing = TRUE)
                )
              ),
              column(
                width = 3,
                selectInput(
                  inputId = "metrica_leaflet",
                  label = "Selecione uma métrica",
                  choices = c(
                    "IDHM" = "idhm",
                    "Esperança de vida" = "espvida",
                    "Renda per capita" = "rdpc",
                    "Índice de Gini" = "gini",
                    "População" = "pop"
                  )
                )
              )
            )
          )
        ),
        fluidRow(
          column(
            width = 12,
            leaflet::leafletOutput(outputId = "mapa")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {

  output$tabela <- reactable::renderReactable({

    pnud |>
      filter(ano == input$ano_reactable) |>
      arrange(desc(.data[[input$metrica_reactable]])) |>
      slice(1:50) |>
      mutate(rank = 1:n()) |>
      select(rank, muni_nm, uf_sigla, regiao_nm, all_of(input$metrica_reactable)) |>
      reactable::reactable(
        sortable = FALSE,
        searchable = TRUE,
        filterable = TRUE,
        striped = TRUE,
        columns = list(
          muni_nm = reactable::colDef(
            name = "Município"
          ),
          rank = reactable::colDef(
            width = 50,
            align = "center"
          )
        ),
        language = reactable::reactableLang(
          searchPlaceholder = "Procurar"
        ),
        theme = reactable::reactableTheme(
          backgroundColor = "transparent",
          stripedColor = "#608df0"
        )
      )

  })


  output$grafico <- echarts4r::renderEcharts4r({

    tab_plot <- pnud |>
      filter(ano == input$ano_echarts)

    min_x <- min(tab_plot[[input$eixo_x]], na.rm = TRUE)
    max_x <- max(tab_plot[[input$eixo_x]], na.rm = TRUE)

    tab_plot |>
      echarts4r::e_charts_(x = input$eixo_x) |>
      echarts4r::e_scatter(serie = espvida) |>
      echarts4r::e_x_axis(
        name = input$eixo_x,
        nameLocation = "center",
        nameGap = 30,
        min = min_x,
        max = max_x
      ) |>
      echarts4r::e_y_axis(
        name = "Esperança de vida",
        nameLocation = "center",
        nameGap = 30,
        min = 60,
        max = 80
      ) |>
      echarts4r::e_tooltip() |>
      echarts4r::e_color("red") |>
      echarts4r::e_legend(show = FALSE)


  })

  output$mapa <- leaflet::renderLeaflet({

    pnud |>
      filter(ano == input$ano_leaflet) |>
      arrange(desc(.data[[input$metrica_leaflet]])) |>
      mutate(
        popup = paste0(
          input$metrica_leaflet,
          ": ",
          .data[[input$metrica_leaflet]]
        )
      ) |>
      slice(1:10) |>
      leaflet::leaflet() |>
      leaflet::addTiles() |>
      leaflet::addMarkers(
        lng = ~lon,
        lat = ~lat,
        label = ~muni_nm,
        popup = ~popup
      )

  })



}

auth0::shinyAppAuth0(
  ui,
  server,
  options = list(launch.browser = FALSE, port = 4242)
)

