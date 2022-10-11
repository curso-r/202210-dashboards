library(shiny)

retangulo <- function(text = "") {
  div(
    style = "background: purple; height: 100px; text-align: center; color: white; font-size: 24px;",
    text
  )
}

ui <- fluidPage(
  fluidRow(
    column(
      width = 3,
      retangulo(1)
    ),
    column(
      width = 4,
      retangulo(2)
    ),
    column(
      width = 5,
      retangulo(3)
    )
  ),
  br(),
  br(),
  fluidRow(
    column(
      width = 6,
      retangulo(4)
    ),
    column(
      width = 2,
      offset = 4,
      retangulo(5)
    )
  ),
  # cuidado para não esquecer das linhas
  column(
    width = 4,
    retangulo(6)
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)

