#Import data
dat <- read.csv("ID_TH_20191209_shiny.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Final Project 02"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("nf",
                  "National Forest:",
                  c("All",
                    unique(as.character(dat$ADMIN_FO_1)))),
      selectInput("act",
                  "Activity:",
                  c("All",
                    unique(as.character(dat$NEW_CODE)))),
      selectInput("proj",
                  "Project:",
                  c("All",
                    unique(as.character(dat$NEPA_DOC_N)))),
      radioButtons("filetype", "File type:",
                   choices = c("csv", "tsv")),
      downloadButton("downloadData", "Download")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      DT::dataTableOutput("table"),
      plotOutput("plot")
    ))
)