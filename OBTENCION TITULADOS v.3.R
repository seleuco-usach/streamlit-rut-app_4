####1.1 Conexion####
library(dplyr)
library(odbc)
library(rpivotTable)
setwd("/media/xenomorfo/Windows/Users/USACH/OneDrive - usach.cl/Escritorio/ANALISTA ESTUDIOS/r/TITULADOS")
#setwd("/home/xenomorfo/Documentos/ANALISTA ESTUDIOS/r/TITULADOS")

con_2 <- dbConnect(odbc(),
                 Driver = "ODBC Driver 17 for SQL Server",
                 encoding = "Latin1",
                 Server = "158.170.66.56",
                 Database = "TABLAS_ESTUDIO",
                 UID = "base_estudio",
                 PWD = "Estudio.T4b145",
                 Port = 1433)

con_3 <- dbConnect(odbc(),
                   Driver = "ODBC Driver 17 for SQL Server",
                   Server = "158.170.66.56",
                   encoding = "Latin1",
                   Database = "PROC01ESTUDIO",
                   UID = "proceso",
                   PWD = "Estudio.2024",
                   Port = 1433)


V_CPP_2<-
  data.frame(tbl(con_2, "CPP")) %>%
  mutate(ANO_COD=paste(ANIO_PROGRAMA_SIES,
               CODIGO_PLAN, sep = ""))

library(googledrive)
library(googlesheets4)

gs4_auth(email = "jose.hoyos@usach.cl") 

CPP<-
  data.frame(googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1SJ5rpzMh6622Jqs3UFhEfKlziJtEAWKcEPdegqRNeJU/edit#gid=1027721539", 
                                       sheet = "CARRERAS PROGRAMAS PLANES CORR")) %>% 
  mutate(ANO_COD=paste(AÑO, COD_PLAN2, sep = ""))


inicio<-Sys.time()
library(lubridate)
#####PROCESO TABLA COHORTES#####
####1 Tabla Cohortes####

tabla_coh <-
tbl(con_2, "COHORTE_AL_20240502") %>%
    dplyr::filter(COHORTE_FORM_B == 1) %>%
    group_by(
      RUT,
      ANHO,
      SEXO,
      COD_PLAN,
      PLAN,
      CODIGO_PROGRAMA_SIES,
      DURACION_TOTAL,
      CODIGO_CARRERA,
      VIA_INGRESO,
      COD_VIA_INGRESO,
      INGRESO
    ) %>%
    summarise(frec = n_distinct(RUT), .groups = "keep") %>%
  collect() %>% 
  mutate(
    id = paste(RUT, COD_PLAN, sep = ""),
    id_2 = paste(ANHO, COD_PLAN, sep = ""),
    RUT = as.numeric(RUT),
    COD_PLAN = as.numeric(COD_PLAN),
    ANHO = as.numeric(ANHO),
    RUT_COD_CAR = paste(RUT, CODIGO_CARRERA, sep = "-")
  ) %>%
  left_join(CPP[, c("ANO_COD", "COD_PLAN2")], by = c('id_2' = 'ANO_COD')) %>%
  mutate(rut_cod_plan = paste(RUT, CODIGO_CARRERA, sep = ""))




####2 Tabla Titulados de TITULADOS####
tabla_titulados <-
  unique(
    data.frame(tbl(con_2, "TITULADOS") %>%
        dplyr::filter(NIVEL_TIT_GRADO == "TERMINAL", COD_PLAN != 0) %>%
        mutate(as.integer(COD_PLAN),
               FECHA_TITULO=as.character(FECHA_TITULO)) %>%
        group_by(
          RUT,
          COD_PLAN,
          NIVEL_TIT_GRADO,
          ANHO_ACADEMICO,
          FECHA_RESOL,
          NUM_SEM_SUSP,
          FECHA_TITULO,
          NOMBRE_PLAN,
          NOMBRE_TIT_GRADO) %>%
        #mutate(id = paste(RUT, COD_PLAN, sep = ""))%>%
        summarise(frec = n_distinct(RUT), .groups = "keep")) %>%
       full_join(V_CPP_2[, c("CODIGO_PLAN",
                            "CODIGO_CARRERA")], by = c('COD_PLAN' = 'CODIGO_PLAN'))) %>%
       mutate(rut_cod_plan = paste(RUT, CODIGO_CARRERA, sep = ""))


tabla_titulados$FECHA_TITULO <-
  as.Date(tabla_titulados$FECHA_TITULO, origin = "1899-12-30")
tabla_titulados$FECHA_RESOL <-
  as.Date(tabla_titulados$FECHA_RESOL, origin = "1899-12-30")

####TITULADOS SIES 2024
library(openxlsx)

TIT_SIES_2024<-
read.xlsx("Titulación_Unificada_2024_SIES.xlsx")

cod_plan_carrera<-
tbl(con_3, "MATRICULA") %>% 
  group_by(cod_plan, 
           cod_carr_prog) %>% 
  summarise(n()) %>% collect() %>% rename(COD_PLAN = cod_plan,
                                          CODIGO_CARRERA = cod_carr_prog )

TIT_SIES_2024 <-
  TIT_SIES_2024 %>% select(
    RUT,SEXO,
    COD_PLAN,
    NOMBRE_TIT_GRADO,
    NOMBRE_PLAN,DURACION_TOTAL,
    NIVEL_TIT_GRADO,ANHO_ACADEMICO,
    FECHA_TITULO,FECHA_RESOL
  ) %>%
  left_join(cod_plan_carrera[, c("COD_PLAN", "CODIGO_CARRERA")], by =
              'COD_PLAN') %>%
  mutate(rut_cod_plan = paste(RUT, CODIGO_CARRERA, sep = ""))

TIT_SIES_2024$FECHA_TITULO<-as.Date(TIT_SIES_2024$FECHA_TITULO, origin = "1899-12-30")
TIT_SIES_2024$FECHA_RESOL<-as.Date(TIT_SIES_2024$FECHA_RESOL, origin = "1899-12-30")
TIT_SIES_2024$ANHO_ACADEMICO<-as.Date(TIT_SIES_2024$ANHO_ACADEMICO, origin = "1899-12-30")

intersect(names(tabla_titulados), names(TIT_SIES_2024))
NROW(intersect(names(tabla_titulados), names(TIT_SIES_2024)))

tabla_titulados<-
Reduce(function(x, y) merge(x, y, all=TRUE), list(tabla_titulados, TIT_SIES_2024))

tabla_titulados<-
tabla_titulados[, c(1:NROW(intersect(names(tabla_titulados), names(TIT_SIES_2024))))]


tabla_titulados$NIVEL_TIT_GRADO<-
toupper(tabla_titulados$NIVEL_TIT_GRADO)




####3 Tabla Titulados y COH####
titulados_coh_3 <-
  unique(
    tabla_coh %>%
      full_join(tabla_titulados[, c(
        "rut_cod_plan",
        "NIVEL_TIT_GRADO",
        "ANHO_ACADEMICO",
        "FECHA_RESOL",
        "NUM_SEM_SUSP",
        "FECHA_TITULO",
        "NOMBRE_TIT_GRADO"
      )], by = 'rut_cod_plan') %>%
      mutate(NIVEL_TIT_GRADO = toupper(NIVEL_TIT_GRADO),DUR_ANO = round(DURACION_TOTAL / 2, 1),
        estado = ifelse(is.na(NIVEL_TIT_GRADO), "No", "Si"),
        NIVEL_GLOBAL = ifelse(substr(CODIGO_CARRERA, 1, 3) == "MAG","MAGISTER",
                       ifelse(substr(CODIGO_CARRERA, 1, 3) == "DOC","DOCTORADO",
                       ifelse(substr(CODIGO_CARRERA, 1, 3) == "DIP","DIPLOMADO",
                       ifelse(substr(CODIGO_CARRERA, 1, 3) == "POS","POSTÍTULO",
                       ifelse(CODIGO_CARRERA == "MIDA", "MAGISTER", "PREGRADO"))))))
  )

###3.1 Filtros y NIVEL GLOBAL DIPLOMADO
titulados_coh_3<-
titulados_coh_3 %>% 
  mutate(NIVEL_GLOBAL_2=ifelse(grepl("DIPLOMADO", NOMBRE_TIT_GRADO), "DIPLOMADO", NIVEL_GLOBAL),
         filtro_sal_int=ifelse(grepl("DIPLOMADO", NOMBRE_TIT_GRADO) & NIVEL_GLOBAL=="PREGRADO",1,0),
         filtro_sal_int=ifelse(is.na(filtro_sal_int),0, filtro_sal_int))


dur_anho_acad<-
  with(titulados_coh_3, as.numeric(ifelse(ANHO=="","",
                        ifelse((ANHO_ACADEMICO-ANHO<0),"",ANHO_ACADEMICO-ANHO))))
oportuno_anho_acad<-
  with(titulados_coh_3, ifelse(NIVEL_TIT_GRADO=="TERMINAL",
                        ifelse(DUR_ANO>=dur_anho_acad,"Si","No"),""))



titulados_coh_3$oportuno_anho_acad<-
  with(titulados_coh_3, ifelse(is.na(oportuno_anho_acad), "No",
                               oportuno_anho_acad))

titulados_coh_3<-
cbind(titulados_coh_3, dur_anho_acad)

titulados_coh_3<-
cbind(titulados_coh_3, fecha_act=Sys.Date())

titulados_coh_3<-
titulados_coh_3 %>% 
mutate(ANHO_RES=substr(FECHA_RESOL,1,4),
       ANHO_TIT=substr(FECHA_TITULO,1,4))

# titulados_coh_3<-
# titulados_coh_3 %>% 
#   mutate(filtro_lic=ifelse(CODIGO_CARRERA=="HCS" | is.na(CODIGO_CARRERA), 0,
#                     ifelse(CODIGO_CARRERA=="DERECHO", 0,
#                     ifelse(grepl("LICENC",titulados_coh_3$NOMBRE_TIT_GRADO),1,0))))
# 
# titulados_coh_3<-
# titulados_coh_3 %>% mutate(filtro_lic=ifelse(CODIGO_CARRERA=="HCS" | is.na(CODIGO_CARRERA), 0, 
#                            ifelse(CODIGO_CARRERA=="DERECHO", 0, 
#                            ifelse(grepl("LICENC", NOMBRE_TIT_GRADO),1,0))))
# titulados_coh_3<-
# titulados_coh_3 %>% dplyr::filter(filtro_lic==0)

titulados_coh_3$ANHO_TIT<-
as.integer(titulados_coh_3$ANHO_TIT)

# titulados_coh_3 <-
#   titulados_coh_3 %>% mutate(
#     Periodo_Ing = substr(INGRESO, 6, 7),
#     ANHO_INI = as.Date(ifelse(Periodo_Ing == "01",
#                       paste(ANHO, "01", "01", sep = "-"),
#                       paste(ANHO, "08", "08", sep = "-"))),
#     Duracion_semestres = ifelse(Periodo_Ing == "01",
#       time_length(interval(as.Date(ANHO_INI),as.Date(FECHA_TITULO)), "months") / 6,
#       (time_length(interval(
#         as.Date(ANHO_INI),
#         as.Date(FECHA_TITULO)
#       ), "months") / 6)
#     ),
#     Duracion_semestres_res = ifelse(
#       Periodo_Ing == "01",
#       time_length(interval(as.Date(ANHO_INI), as.Date(FECHA_RESOL)), "months") /
#         6,
#       (time_length(interval(
#         as.Date(ANHO_INI),
#         as.Date(FECHA_TITULO)
#       ), "months") / 6)
#     ),
#     Tiempo_grad = Duracion_semestres - DURACION_TOTAL,
#     exacta_sem = ifelse(
#       estado == "Si",
#       ifelse(Duracion_semestres - DURACION_TOTAL <= 0, 1, 0),
#       0
#     ),
#     oportuno_sem = ifelse(
#       estado == "Si",
#       ifelse(Duracion_semestres - DURACION_TOTAL <= 2, 1, 0),
#       0
#     ),
#     oportuno_sem_res = ifelse(
#       estado == "Si",
#       ifelse(Duracion_semestres_res - DURACION_TOTAL <= 2, 1, 0),
#       0
#     )
#   )



# Función rápida para diferencia en meses (años y meses)
diff_months <- function(start, end) {
  (as.numeric(format(end, "%Y")) - as.numeric(format(start, "%Y"))) * 12 +
    (as.numeric(format(end, "%m")) - as.numeric(format(start, "%m")))
}

titulados_coh_3 <- titulados_coh_3 %>%
  mutate(
    Periodo_Ing = substr(INGRESO, 6, 7),
    ANHO_INI = as.Date(ifelse(Periodo_Ing == "01",
                              paste(ANHO, "01", "01", sep = "-"),
                              paste(ANHO, "08", "08", sep = "-"))),
    FECHA_TITULO = as.Date(FECHA_TITULO),
    FECHA_RESOL = as.Date(FECHA_RESOL),
    Duracion_semestres = diff_months(ANHO_INI, FECHA_TITULO) / 6,
    Duracion_semestres_res = diff_months(ANHO_INI, FECHA_RESOL) / 6,
    Tiempo_grad = Duracion_semestres - DURACION_TOTAL,
    exacta_sem = ifelse(estado == "Si" & (Duracion_semestres - DURACION_TOTAL) <= 0, 1, 0),
    oportuno_sem = ifelse(estado == "Si" & (Duracion_semestres - DURACION_TOTAL) <= 2, 1, 0),
    oportuno_sem_res = ifelse(estado == "Si" & (Duracion_semestres_res - DURACION_TOTAL) <= 2, 1, 0)
  )




titulados_coh_3<-
titulados_coh_3 %>% mutate(ANO_OP=
                     ifelse(DURACION_TOTAL==14 & ANHO==2016, "OP_2023",
                     ifelse(DURACION_TOTAL==12 & ANHO==2017, "OP_2023", 
                     ifelse(DURACION_TOTAL==11 & ANHO==2017, "OP_2023",
                     ifelse(DURACION_TOTAL==10 & ANHO==2018, "OP_2023",
                     ifelse(DURACION_TOTAL==9 & ANHO==2018, "OP_2023",
                     ifelse(DURACION_TOTAL==8 & ANHO==2019, "OP_2023", 
                     ifelse(DURACION_TOTAL==7 & ANHO==2019, "OP_2023",
                     ifelse(DURACION_TOTAL==6 & ANHO==2020, "OP_2023",
                     ifelse(DURACION_TOTAL==5 & ANHO==2020, "OP_2023",
                     ifelse(DURACION_TOTAL==4 & ANHO==2021, "OP_2023",
                     ifelse(DURACION_TOTAL==3 & ANHO==2021, "OP_2023",
                     ifelse(DURACION_TOTAL==2 & ANHO==2022, "OP_2023",
                     ifelse(DURACION_TOTAL==14 & ANHO==2017, "OP_2024",
                     ifelse(DURACION_TOTAL==12 & ANHO==2018, "OP_2024", 
                     ifelse(DURACION_TOTAL==11 & ANHO==2018, "OP_2024",
                     ifelse(DURACION_TOTAL==10 & ANHO==2019, "OP_2024",
                     ifelse(DURACION_TOTAL==9 & ANHO==2019, "OP_2024",
                     ifelse(DURACION_TOTAL==8 & ANHO==2020, "OP_2024", 
                     ifelse(DURACION_TOTAL==7 & ANHO==2020, "OP_2024",
                     ifelse(DURACION_TOTAL==6 & ANHO==2021, "OP_2024",
                     ifelse(DURACION_TOTAL==5 & ANHO==2021, "OP_2024",
                     ifelse(DURACION_TOTAL==4 & ANHO==2022, "OP_2024",
                     ifelse(DURACION_TOTAL==3 & ANHO==2022, "OP_2024",
                     ifelse(DURACION_TOTAL==2 & ANHO==2023, "OP_2024","otro")))))))))))))))))))))))))

# titulados_coh_3<-
# titulados_coh_3 %>% mutate(ING2030=grepl("INGENIERIA CIVIL",PLAN))

ING2030<-c("DOCCSING",	"MAGII",	"MAGCDI",	"MAGEII",	"ICMEC",	"ICELEC",	"ICQUIM",	
  "ICMET",	"ICOBR",	"ICIND",	"ICMIN",	"ICGEOG",	"MAGMA",	"ICINF",	
  "MAGSGI",	"MAGIE",	"ICMECAT",	"ICBIOM",	"ICAMB",	"ICBIO",	"ICTEL",
  "ICGEOM",	"MAGCIME")

titulados_coh_3$ING2030<-ifelse(titulados_coh_3$CODIGO_CARRERA %in% ING2030, 1,0)

VIA_INC<-c(87,21,	72,	26,	81,	71,	70,	89,	30,	97,	88,	78,	75,	99,	20, 40)

titulados_coh_3$VIA_INC<-
ifelse(titulados_coh_3$COD_VIA_INGRESO %in% VIA_INC,1,0)



rpivotTable(
  titulados_coh_3 %>% 
    group_by(CODIGO_CARRERA, ANHO,COD_PLAN, estado, NIVEL_GLOBAL, 
             oportuno_sem, oportuno_sem_res, SEXO, ANHO_TIT, ANHO_RES, VIA_INC) %>% 
    summarise(n=n_distinct(RUT)),
  subtotals = T,
  rows = c("CODIGO_CARRERA","COD_PLAN","estado"),
  cols = "ANHO",
  aggregatorName = "Integer Sum",
  inclusions = list(CODIGO_CARRERA = list("ARQ")),
  vals = "n")



final<-Sys.time()

final - inicio

dbWriteTable(con_3, "TITULADOS", tabla_titulados, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "COHORTE_AL_20240502", tbl(con_2, "COHORTE_AL_20240502") %>% collect() %>% select(everything()), append = TRUE, row.names = FALSE)


open