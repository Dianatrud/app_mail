#Librerias
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(htmltools)
library(glue)
library(lubridate)
library(tidyverse)
library(blastula)
library(fresh)
library(bslib)
library(shinyjs)
library(reactable)
library(htmlwidgets)
library(magick)
library(shinyalert)


#Funciones

control_mail     <- function(asunto, texto1, imagen1, texto2, texto3,
                            texto4, texto5, imagen2){

  imagen1 <- add_image(imagen1, align = "center",float = "none")
  imagen2 <- add_image(imagen2, align = "center",float = "none", width = 230)
  boton <- add_cta_button(url = texto2,text = "Haz clik aquí",align = "center")
  espacio <- br()


  mensaje <- glue("{texto1}
                  {espacio}
                  {espacio}
                  {texto3}
                  {espacio}
                  {espacio}
                  {texto4}
                  {espacio}
                  {espacio}
                  {texto5}
                  {espacio}
                  ")
  asunto_mail <- str_glue("{asunto}")

  # LOGO <- add_image(imagen1, align = "center",float = "none")

  correo <- compose_email(
    body =
      blocks(
        condiciones_titulo(md(imagen2)),
        block_spacer(),
        condiciones_titulo(md(paste0("**",asunto_mail,"**"))),
        imagen1,
        block_spacer(),
        boton,
        block_spacer(),
        block_text(md(mensaje))),

    content_width = "600px"
  )

  return(correo)
}


condiciones_titulo   <- function(title){
  tags$h1(class = "message-block condiciones_titulo", style = css(color = "#222222",
                                                             font_weight = "300", line_height = "1.4",
                                                             margin = "0", font_size = "24px", margin_bottom = "4px",
                                                             text_align = "center"), title)}


despliegue_correo   <- function(correo, destino, titulo){

  correo %>%
    smtp_send(
      from = "tucorreo@gmail.com",
      to = destino,
      subject = str_glue("{titulo}"),
       credentials = creds_file("gmail_creds")

      )

}
