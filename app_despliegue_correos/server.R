
function(input, output, session) {
  asunto     <<- reactive(input$asunto)
  texto1     <<- reactive(input$texto1)

  
  
  imagen1    <<- eventReactive((input$preview | input$enviar),{
    file <- input$imagen1
    path <- file$datapath
    return(path)
  })
  
  
  imagen2    <<- eventReactive((input$preview | input$enviar),{
    file <- input$imagen2
    path <- file$datapath
    return(path)
  })
  
  
  texto2     <<- reactive(input$texto2)
  texto3     <<- reactive(input$texto3)
  texto4     <<- reactive(input$texto4)
  texto5     <<- reactive(input$texto5)
  
  observe({
    condicion <- if (!is.null(input$archivos_destinatarios) & input$asunto != "" & input$texto1 != ""){
      shinyjs::enable("enviar")
      shinyjs::enable("preview")
    }else{
      shinyjs::disable("enviar")
      shinyjs::disable("preview")
    }
    
  })
  
  destinatarios <- eventReactive(eventExpr = input$preview,{
    
    file <- input$archivos_destinatarios
    path <- file$datapath
    
    mails <- readxl::read_excel(path = path)
    
    clientes <- mails %>% distinct(correo, .keep_all = T) %>%
      mutate(correo = str_to_lower(correo),
             segundo_nombre = ifelse(is.na(segundo_nombre),'',segundo_nombre),
             nombre_completo = paste0(primer_apellido," ",segundo_apellido," ",
                                      primer_nombre," ",segundo_nombre) %>% str_to_title()) %>%
      select(nombre_completo,correo)
    return(clientes)
    
  })
  
  output$tabla_correo <- renderReactable({
    reactable(destinatarios(),
              defaultColDef = colDef(align = "center"),
              columns = list(
                nombre_completo = colDef(name = "Nombre Completo"),
                correo = colDef(name = "Correo")
              ))
    
  })
  
  correo                <- eventReactive(eventExpr = input$preview, {
    
   correo <-  control_mail(asunto = asunto(), imagen1 = imagen1(),
                texto1 = texto1(), texto2  = texto2(),
                texto3 = texto3(), texto4  = texto4(),
                texto5 = texto5(), imagen2())
    
  })
  output$preview_correo <- renderUI({
    
    correo()$html_html

     

  })
  
  observeEvent(input$preview, {
    
    shinyalert("Excelente!", "Revisa tu Preview en la pestaña de visualización.")
  })
  
  correo_enviar <- eventReactive(eventExpr = input$enviar,{
    
    emails <- destinatarios() %>%
      mutate(mail = list(correo())) %>% select(destino = correo, correo = mail)
    
    return(emails)
    
  })
  
  correo_gmail          <- observeEvent(eventExpr = input$enviar, {
    numero <- length(destinatarios()$correo) %>% as.numeric()
    info_des <- correo_enviar()
    
    # Create a Progress object
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    
    progress$set(message = "Enviando", value = 0)
    
    titulo = input$titulo
    if (numero == 0) {
    } else{
      for (i in 1:numero) {
        despliegue_correo(correo = correo(), info_des$destino[i], titulo)
        
        #incremento
        progress$inc(1 / numero, detail = paste("correo numero: ", i))
        
        Sys.sleep(5)
      }
    }
    
  })
  
  observeEvent(input$enviar, {
    
    shinyalert("¡Todo un exito!", "Tu mail ya ha sido enviado.")
  })
  

}
