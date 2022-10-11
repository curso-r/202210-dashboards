library(shiny)

ui <- fluidPage(
  h1("Esse é o título do meu app!"),
  hr(style = "border-color: #0000ff;"),
  h2("Sobre este app"),
  includeMarkdown("texto_intro.md"),
  hr(),
  # centralizando usando css
  # img(src = "cursor.png", width = "50%", style = "display: block; margin: auto;")
  # centralizando usando o grid system
  fluidRow(
    column(
      offset = 5,
      width = 2,
      img(src = "cursor.png", width = "100%")
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
