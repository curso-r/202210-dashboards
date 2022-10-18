library(shiny)

ui <- fluidPage(
  titlePanel("Editando bases de dados"),
  sidebarLayout(
    sidebarPanel(
      numericInput(
        "num_linha",
        label = "Linha para ser removida",
        value = 1
      ),
      actionButton(
        "remover",
        label = "Remover linha"
      )
    ),
    mainPanel(
      tableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {

  # Essa solução não funciona
  # base_atualizada <- eventReactive(input$remover, ignoreNULL = FALSE, {
  #   if (input$remover == 0) {
  #     mtcars
  #   } else {
  #     base_atualizada() |>
  #       dplyr::slice(-input$num_linha)
  #   }
  # })

  base_atualizada <- reactiveVal(mtcars)

  observeEvent(input$remover, {

    nova_base <- base_atualizada() |>
      dplyr::slice(-input$num_linha)

    base_atualizada(nova_base)

  })

  output$tabela <- renderTable({
    base_atualizada() |>
      tibble::rownames_to_column(var = "modelo")
  })

}

shinyApp(ui, server)
