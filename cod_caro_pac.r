library(odbc)
library(dplyr)
library(stringr)
library(stringi)
con_3 <- dbConnect(odbc(),
                   Driver = "ODBC Driver 17 for SQL Server",
                   Server = "158.170.66.56",
                   encoding = "Latin1",
                   Database = "PROC01ESTUDIO",
                   UID = "proceso",
                   PWD = "Estudio.2024",
                   Port = 1433)

tbl(con_3, pac_2008_2025)%>%
select(everything())

PAC_2008_2025 <-tbl(con_3, "PAC_2008_2025") %>%
select(everything())%>%
collect()

tabla_7_pac<- PAC_2008_2025 %>%
  collect()%>%
  mutate(jerarquia = case_when( 
    str_detect(jeraquia_categoria,"PROFESOR ASOCIADO") ~ "PROFESOR ASOCIADO",
    str_detect(jeraquia_categoria,"ASOCIADO") ~ "ASOCIADO",
    str_detect(jeraquia_categoria,"ASISTENTE") ~ "ASISTENTE",
    str_detect(jeraquia_categoria,"TITULAR") ~ "TITULAR",
    str_detect(jeraquia_categoria,"ADJUNTO I") ~ "SIN JERARQUIZAR",
    str_detect(jeraquia_categoria,"ADJUNTO II") ~ "SIN JERARQUIZAR",
    str_detect(jeraquia_categoria,"INSTRUCTOR I") ~ "SIN JERARQUIZAR",
    str_detect(jeraquia_categoria,"INSTRUCTOR II") ~ "SIN JERARQUIZAR",
    str_detect(jeraquia_categoria,"AYUDANTE DE PROFESOR") ~ "AYUDANTE DE PROFESOR",
    str_detect(jeraquia_categoria,"ADJUNTO CATEGORIA I") ~ "ADJUNTO CATEGORIA I Y II",
    str_detect(jeraquia_categoria,"INSTRUCTOR CATEGORIA I") ~ "INSTRUCTOR CATEGORIA I Y II",
    str_detect(jeraquia_categoria,"INSTRUCTOR CATEGORIA II") ~ "INSTRUCTOR CATEGORIA I Y II",
    str_detect(jeraquia_categoria,"ADJUNTO CATEGORIA I") ~ "ADJUNTO CATEGORIA I Y II",
    str_detect(jeraquia_categoria,"ADJUNTO CATEGORIA II") ~ "ADJUNTO CATEGORIA I Y II",
    str_detect(jeraquia_categoria,"INSTRUCTOR") ~ "INSTRUCTOR",
    str_detect(jeraquia_categoria,"NO APLICA") ~ "OTRAS JERARQUIAS",
    str_detect(jeraquia_categoria,"SINCATEGORIZAR") ~ "OTRAS JERARQUIAS",
    str_detect(jeraquia_categoria,"HONORARIOS") ~ "HONORARIOS",
    TRUE ~ "OTRAS JERARQUIAS"),
    jerarquizado_o_no=case_when( 
      str_detect(jeraquia_categoria,"ADJUNTO I") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"ADJUNTO II") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"INSTRUCTOR I") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"INSTRUCTOR II") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"AYUDANTE DE PROFESOR") ~ "JERARQUIA",
      str_detect(jeraquia_categoria,"ADJUNTO CATEGORIA I") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"INSTRUCTOR CATEGORIA I") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"INSTRUCTOR CATEGORIA II") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"ADJUNTO CATEGORIA I") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"ADJUNTO CATEGORIA II") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"NO APLICA") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"SINCATEGORIZAR") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"HONORARIOS") ~ "SIN JERARQUIZAR",
      str_detect(jeraquia_categoria,"PROFESOR ASOCIADO") ~ "JERARQUIA",
      str_detect(jeraquia_categoria,"ASOCIADO") ~ "JERARQUIA",
      str_detect(jeraquia_categoria,"ASISTENTE") ~ "JERARQUIA",
      str_detect(jeraquia_categoria,"TITULAR") ~ "JERARQUIA",
      str_detect(jeraquia_categoria,"INSTRUCTOR") ~ "JERARQUIA",
      TRUE ~ "SIN JERARQUIZAR"),
    mayor_a_39_horas=ifelse(total_horas>=39,1,0)) %>% 
  group_by(ano,sexo,jerarquizado_o_no,tipo_jornada,jeraquia_categoria) %>% 
  summarise(n=n(),
            jce_suma = round(sum(jce),2)) %>% 
  mutate(llave=paste(jeraquia_categoria,ano,sexo,sep="_",collapse=NULL)) %>% 
  relocate(llave)

library(clipr)
write_clip(tabla_7_pac)
