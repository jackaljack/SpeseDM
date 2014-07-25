shinyUI(pageWithSidebar(
  
  headerPanel("Dispositivi medici - Spesa rilevata per Azienda Sanitaria nel 2012", windowTitle = "SpeseDM"),
  
  sidebarPanel(
    
    selectInput("regione", "Regione", c("ABRUZZO","BASILICATA", "CALABRIA", "CAMPANIA",
                                        "EMILIA ROMAGNA", "FRIULI VENEZIA GIULIA", "LAZIO", "LIGURIA",
                                        "LOMBARDIA", "MARCHE", "MOLISE", "PIEMONTE", 
                                        "PROV. AUTON. BOLZANO", "PROV. AUTON. TRENTO", "PUGLIA", "SARDEGNA",
                                        "SICILIA", "TOSCANA", "UMBRIA", "VALLE D'AOSTA",
                                        "VENETO")),
    
    conditionalPanel(condition = "input.tabName == 'Spesa per Azienda'",
                     # crea il secondo selectInput dinamicamente,
                     # sulla base della Regione scelta (vedi server.R)
                     uiOutput("azSanRegSelInp"),
                     hr(),
                     helpText(strong("Come usare questo tab:")),
                     helpText("1.Seleziona una regione"),
                     helpText("2.Seleziona un'azienda sanitaria")
                     ),
    
    conditionalPanel(condition = "input.tabName == 'Spesa per DM'",
                     # textInput per restringere la ricerca dei DM
                     textInput("text", label = "DM ricercato TextInput", value = ""),
                     uiOutput("dmSelInp"),
                     hr(),
                     helpText(strong("Come usare questo tab:")),
                     helpText("1.Seleziona una regione"),
                     helpText("2.Seleziona un dispositivo medico")
    ),
 
    # Credit
    hr(),
    helpText( "Dati ottenuti da: ", a("dati.salute.gov.it", href="http://www.dati.salute.gov.it/dati/dettaglioDataset.jsp?menu=dati&idPag=63", target="_blank") ),
    helpText( "Classificazione Nazionale Dispositivi Medici (CND): ", a("salute.gov.it", href="http://www.salute.gov.it/portale/temi/SceltaDispomedDispositivi.jsp", target="_blank") )
    
  ), # end of sidebarPanel
  
  mainPanel(    
    
    tabsetPanel(
      tabPanel( "Spesa per Azienda", h4(textOutput("caption1")), tableOutput("listView1") ),
      tabPanel( "Spesa per DM",      h4(textOutput("caption2")), tableOutput("listView2")),
      id="tabName")   
    
  ) # end of mainPanel
  
  ) # end of pageWithSidebar
)