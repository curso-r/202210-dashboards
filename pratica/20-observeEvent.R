library(shiny)

ui <- fluidPage(
  textInput("email", label = "Digite o seu e-mail", value = ""),
  actionButton("enviar", label = "Enviar")
)

server <- function(input, output, session) {

  observeEvent(input$enviar, {
    write(input$email, "emails.txt", append = TRUE)

    showModal(
      modalDialog(
        title = "Aviso",
        "O seu e-mail foi registrado com sucesso!",
        footer = modalButton("Fechar"),
        easyClose = TRUE
      )
    )

  })

}

shinyApp(ui, server)
