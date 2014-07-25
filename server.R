
# Required packages -------------------------------------------------------
library(shiny)

# Data Import -------------------------------------------------------------

# dataset (Italian Open Data Licence v2.0)
# importa il file CSV in R e salva in un dataframe

# fileURL <- "http://opendatasalute.cloudapp.net/DataBrowser/DownloadCsv?container=datacatalog&entitySet=DATASETDISPOSITIVIMEDICI2012SPESA&filter=Nessun%20Filtro"
# df <- read.csv(fileURL)

df <- read.csv("DATASETDISPOSITIVIMEDICI2012SPESA.csv")
# la riga 48962 era vuota (ne ignoro il motivo), quindi la escludo
df <- na.omit(df)

# Define server logic -----------------------------------------------------
shinyServer(function(input, output) { 
  
  # seleziona un subset dei dati in base alla regione scelta
  reactiveDf <- reactive({ 
    # seleziona solo le aziende sanitarie della Regione scelta e ordinale per nome
    subset( x      = df[order(df$denominazione_azienda_sanitaria), ],
            subset = (denominazione_regione == input$regione) )
  })
  
  # crea dinamicamente il secondo selectInput sulla base della Regione scelta
  output$azSanRegSelInp <- renderUI({
    azSanReg <- sort(unique(reactiveDf()$denominazione_azienda_sanitaria))
    selectInput(inputId="aziendeSanReg", label="ASL - Aziende Ospedaliere - IRCCS",
                choices=azSanReg,
                selected=azSanReg[1])
  })

  # spese sostenute dall'azienda selezionata
  output$listView1 <- renderTable({
    subset(x      = reactiveDf()[order(reactiveDf()$descrizione_cnd), ],
           subset = (denominazione_azienda_sanitaria==input$aziendeSanReg),
           select = c(descrizione_cnd, codice_cnd, spesa_sostenuta_per_acquisto)
           )
  })
  
  # spese sostenute per acquistare il DM selezionato
  output$listView2 <- renderTable({
    subset(x      = reactiveDf()[order(reactiveDf()$denominazione_azienda_sanitaria), ],
           subset = (descrizione_cnd==input$dmScelto), ###
           select = c(denominazione_azienda_sanitaria, spesa_sostenuta_per_acquisto)
    )
  })
  
  # crea il titolo della tabella
  output$caption1 <- renderText({
    paste("Regione: ", input$regione, " - Azienda Sanitaria: ", input$aziendeSanReg)
  })
  
  # crea il titolo della tabella
  output$caption2 <- renderText({
    paste("Spese sostenute per l'acquisto di: ", input$dmScelto)
  })
  
  # text widget per limitare la ricerca del DM con una regular expression
  output$value <- renderPrint({ input$text })

  # crea dinamicamente il selectInput del DM sulla base del testo inserito
  output$dmSelInp <- renderUI({
    searchString <- toupper(input$text)
    dmRegExpr <- sort(unique(df$descrizione_cnd[grep(pattern=searchString, x=df$descrizione_cnd)]))
    selectInput(inputId="dmScelto", label="DM ricercato SelInp",
                choices=dmRegExpr,
                selected=dmRegExpr[1])
    })
  
})