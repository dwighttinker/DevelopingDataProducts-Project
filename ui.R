shinyUI(fluidPage(
  tags$h2("Gas Prices"),
  fluidRow(
    column(width=6,
      p("This app uses the Google GeoCoding and mygasfeed apis to compare gas prices based on location using an NVD3 Rchart."),
      p("Source code:",
        a(href="https://github.com/jcheng5/shiny-js-examples/tree/master/output", "@jcheng5/shiny-js-examples/output"))
    )
  ),
  fluidRow(
    column(width=9,
      lineChartOutput("mychart")
     
    ),
    column(width=3,
      textInput(inputId = "address", label = "Address or Area Code", value = "49685"),
      textOutput("text1"),
      br(),
      br(),
      div(class="span6", checkboxInput(inputId = "rank", label = "Rank by distance", value = FALSE)),
      div(class="span6", submitButton("Chart prices"))
    )
  ),
    
    fluidRow(
    column(width=2,
      br(),
      br(),
      br(),
      p("Notes:"),
      p("Broken series lines will may be visible for NULL data points."),
      p("Clicking on the key markers will show/hide a series."),
      p("If Google cannot parse the location the page will need to be refreshed."),
      p("If no gas prices are tracked in the chosen location the page will need to be refreshed.")
    )
  )
  
))
