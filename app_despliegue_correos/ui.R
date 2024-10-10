

ui <- page_navbar(title =  "Despliegue Mail",
                  fillable = T,
                  fillable_mobile = T,
                  lang = "es",
                  theme = shinytheme("yeti"),
                  useShinyalert(),
                  nav_panel(
                    title = "Formulario ",
                    fluidRow(
                             wellPanel(useShinyjs(),
                                       textInput(inputId = "titulo", label = "Asunto",
                                                 placeholder = "Ecribir..."),
                                       fileInput(inputId = "imagen2",label = "Imagen Titulo", buttonLabel = "Explorar...",
                                                 placeholder = "seleccione la imagen deseada"),
                                       fileInput(inputId = "archivos_destinatarios", label = "Destinatarios",
                                                 accept = ".xlsx",buttonLabel = "Explorar...",
                                                 placeholder = "Seleccione un archivo .xlsx"),
                                       textInput(inputId = "asunto", width = 500, label = "Titulo Correo",
                                                 placeholder = "Escribir..."),
                                       fileInput(inputId = "imagen1",label = "Banner", buttonLabel = "Explorar...",
                                                 placeholder = "seleccione la imagen deseada"),
                                       textInput(inputId = "texto1", label = "Texto Introductorio",
                                                 placeholder = "Escribir..."),
                                       textInput(inputId = "texto2", label = "Url del Boton",
                                                 placeholder = "(Opcional)",value = ""),
                                       textInput(inputId = "texto3", label = "Parrafo 1",
                                                 placeholder = "(Opcional)",value = ""),
                                       textInput(inputId = "texto4", label = "Parrafo 2",
                                                 placeholder = "(Opcional)",value = ""),
                                       textInput(inputId = "texto5", label = "Parrafo 3",
                                                 placeholder = "(Opcional)",value = ""),
                                       actionButton(inputId = "preview", label = "PREVIEW",
                                                    class = "btn-primary"),
                                       
                                       br(),br(),
                                       
                             ))
                    
                    
                  ),
                  
                  nav_panel(
                    title = "Visualizacion",
                    wellPanel(useShinyjs(),
                    reactableOutput("tabla_correo"),
                    htmlOutput("preview_correo"),
                    actionButton(inputId = "enviar", label = "ENVIAR",
                                 class = "btn-primary"),
                  ))
                  
                  )
