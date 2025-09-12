library(dplyr)
library(clipr)

install.packages("languageserver")
library(languageserver)

names( COH_RET_REG_ALT )

write_clip(COH_RET_REG_ALT%>%
             filter(CODIGO_CARRERA.x=="MAGCM")%>%
            select(RUT, 
                CODIGO_CARRERA.x,
                ANHO.x, 
                RET_1, 
                RET_2, 
                RET_3, 
                RET_4))


clipr::write_clip(COH_RET_REG_ALT %>% 
            mutate(DESERTA=ifelse(RET_1 == 0 | RET_2 == 0, 1, 0)) %>%
            filter(CODIGO_CARRERA.x == "MAGCM") %>%
            select(RUT, SEXO,
                   CODIGO_CARRERA.x,
                   ANHO.x,
                   RET_1,
                   RET_2,
                   RET_3,
                   RET_4,
                   DESERTA))


planeacion_2025<-read.xlsx("/home/xenomorfo/Descargas/01_Planeacion_Docente_2025-01_(11-06-2025).xlsx")

inscripcion <- read.xlsx("/home/xenomorfo/Descargas/02_Inscripcion_2025-01_(11-06-2025).xlsx")

inscripcion<-inscripcion %>%
  left_join(planeacion_2025[, c("COD_ASIG", "ASIGNATURA")], by = "COD_ASIG")



