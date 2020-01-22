# Define server logic required to draw a histogram
server <- function(input, output) {
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    thedata <- dat
    if (input$nf != "All") {
      thedata <- thedata[thedata$ADMIN_FO_1 == input$nf,]
    }
    if (input$act != "All") {
      thedata <- thedata[thedata$NEW_CODE == input$act,]
    }
    if (input$proj != "All") {
      thedata <- thedata[thedata$NEPA_DOC_N == input$proj,]
    }
    thedata <<- thedata
  }))
  
  
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste("customTable", input$filetype, sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
      
      # Write to a file specified by the 'file' argument
      write.table(thedata, file, sep = sep,
                  row.names = TRUE)
    }
  )
  
  
  output$plot <- renderPlot({
    thedata <- dat
    if (input$nf != "All") {
      thedata <- thedata[thedata$ADMIN_FO_1 == input$nf,]
    }
    if (input$act != "All") {
      thedata <- thedata[thedata$NEW_CODE == input$act,]
    }
    if (input$proj != "All") {
      thedata <- thedata[thedata$NEPA_DOC_N == input$proj,]
    }
    thedata <<- thedata
    Year <- thedata$YC
    Time_Lag <- thedata$TIME_LAG
    ggplot(thedata, aes(Year, Time_Lag)) + geom_point(colour = "darkgreen", size=3)
  })

}

