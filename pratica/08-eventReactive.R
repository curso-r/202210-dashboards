library(shiny)

ui <- fluidPage(
  titlePanel("Formulário"),
  textInput(
    inputId = "nome",
    label = "Nome",
    value = ""
  ),
  dateInput(
    inputId = "data_nasc",
    label = "Data de nascimento",
    value = Sys.Date(),
    format = "dd-mm-yyyy",
    language = "pt-BR"
  ),
  selectInput(
    inputId = "estado",
    label = "Estado",
    choices = c("SP", "AM", "SC", "CE", "MT")
  ),
  actionButton(inputId = "enviar", label = "Enviar dados"),
  textOutput(outputId = "texto_confirmacao")
)

server <- function(input, output, session) {

  dados <- eventReactive(input$enviar, {
    tibble::tibble(
      nome = input$nome,
      data_nasc = input$data_nasc,
      estado = input$estado
    )
  })

  output$texto_confirmacao <- renderText({
    write.table(dados(), "dados.txt", append = TRUE)
    glue::glue(
      "Olá, {dados()$nome}! Os seus dados foram gravados!"
    )
  })


}

shinyApp(ui, server)
