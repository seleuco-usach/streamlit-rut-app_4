#####CARGA DE TABLAS#########

# con <- dbConnect(odbc(),
#                  Driver = "SQL Server",
#                  encoding = "UTF-8",
#                  Server = "158.170.66.56",
#                  Database = "DDI_DATOS",
#                  UID = "vW_estudio",
#                  PWD = "Estudio.V1st4",
#                  Port = 1433)
# 
# con_2 <- dbConnect(odbc(),
#                  Driver = "SQL Server",
#                  encoding = "UTF-8",
#                  Server = "158.170.66.56",
#                  Database = "TABLAS_ESTUDIO",
#                  UID = "base_estudio",
#                  PWD = "Estudio.T4b145",
#                  Port = 1433)
library(odbc)
con_3 <- dbConnect(odbc(),
                   Driver = "ODBC Driver 17 for SQL Server",
                   Server = "158.170.66.56",
                   encoding = "Latin1",
                   Database = "PROC01ESTUDIO",
                   UID = "proceso",
                   PWD = "Estudio.2024",
                   Port = 1433)

# packageurl <- "http://cran.r-project.org/src/contrib/Archive/odbc/odbc_1.3.4.tar.gz"
# install.packages(packageurl, repos=NULL, type="binary")



# library(googlesheets4)
# CPP<-
#   data.frame(googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1SJ5rpzMh6622Jqs3UFhEfKlziJtEAWKcEPdegqRNeJU/edit#gid=1027721539",
#                                        sheet = "CARRERAS PROGRAMAS PLANES CORR"))
# 
# CPP<-
# CPP %>% mutate(ANHO_SIES=paste(AÑO,SIES, sep ="-")) %>% relocate(ANHO_SIES, .before = AÑO)


#setwd("C:/proyectos r studio/ANALISTA USACH/MATRICULA UNIFICADA")
#setwd("/media/xenomorfo/Windows/proyectos r studio/ANALISTA USACH/MATRICULA UNIFICADA")
setwd("/home/xenomorfo/Documentos/proyectos r studio/ANALISTA USACH/MATRICULA UNIFICADA")
library(openxlsx)
library(dplyr)
library(data.table)

tab_paises <-
  tbl(con_3, "tab_paises") %>% select(everything()) %>% collect()

tab_paises <-
  tab_paises %>% mutate(
    NOMBRE.PAIS = chartr("ÁÉÍÓÚ", "AEIOU", tab_paises$NOMBRE.PAIS),
    NOMBRE.PAIS = gsub(" ", "", NOMBRE.PAIS)
  )



MU_2016<-
  read.xlsx("MU_2016.xlsx", sheet = "Matriculados", startRow = 7)

MU_2016$NAC_<-gsub(" ", "",MU_2016$NAC_)

MU_2016<-
MU_2016 %>% left_join(tab_paises[,c("NOMBRE.PAIS", "COD_PAIS")],
                      by = c('NAC_'='NOMBRE.PAIS')) %>% 
  rename(NAC=COD_PAIS)

MU_2016<-
  cbind(ANHO_MU=with(MU_2016, ifelse(N_DOC!=0, "2016", "OTRO")), MU_2016)


MU_2017<-
read.xlsx("MU_2017.xlsx", sheet = "Matriculados", startRow = 7)

MU_2017$NAC_<-gsub(" ", "",MU_2017$NAC_)

MU_2017<-
  MU_2017 %>% left_join(tab_paises[,c("NOMBRE.PAIS", "COD_PAIS")],
                        by = c('NAC_'='NOMBRE.PAIS')) %>% 
  rename(NAC=COD_PAIS)

MU_2017<-
  cbind(ANHO_MU=with(MU_2017, ifelse(N_DOC!=0, "2017", "OTRO")), MU_2017)

MU_2018<-
  read.xlsx("MU 2018 ALT.xlsx")


MU_2018<-
  cbind(ANHO_MU=with(MU_2018, ifelse(N_DOC!=0, "2018", "OTRO")), MU_2018)

MU_2019<-
  read.xlsx("MU MAYO 2019.xlsx")


MU_2019<-
  cbind(ANHO_MU=with(MU_2019, ifelse(N_DOC!=0, "2019", "OTRO")), MU_2019)

MU_2020<-
  read.xlsx("MU MAYO 2020.xlsx")


MU_2020<-
cbind(ANHO_MU=with(MU_2020, ifelse(N_DOC!=0, "2020", "OTRO")), MU_2020)


MU_2021<-
read.xlsx("MU MAYO 2021.xlsx" )

MU_2021<-
  cbind(ANHO_MU=with(MU_2021, ifelse(N_DOC!=0, "2021", "OTRO")), MU_2021)


MU_2022<-
  read.xlsx("MU ABRIL 2022.xlsx")

MU_2022<-
  cbind(ANHO_MU=with(MU_2022, ifelse(N_DOC!=0, "2022", "OTRO")), MU_2022)


# MU_2023<-
#   read.xlsx("MU MAYO 2023.xlsx")

MU_2023<-
fread("MU MAYO 2023.csv")

MU_2023<-
  cbind(ANHO_MU=with(MU_2023, ifelse(N_DOC!=0, "2023", "OTRO")), MU_2023)


MU_2024<-
fread("https://docs.google.com/spreadsheets/d/e/2PACX-1vScuhzyo_mAllAhM5kLss5g9JpRBcOPqWS6Wp0QoRdl1ehNheE9rjnLJTxKDqJs8g/pub?gid=1441801262&single=true&output=csv")

MU_2024<-
  cbind(ANHO_MU=with(MU_2024, ifelse(N_DOC!=0, "2024", "OTRO")), MU_2024)



MU_2025<-
  fread("https://docs.google.com/spreadsheets/d/e/2PACX-1vTWES-vLwcKuZyURsz2swadGSzJXQvMBjQ-F5qyu1A7thTE-iQH4gpe53V-Rw-JQIPxvcRj5nWUaiiP/pub?gid=1483413853&single=true&output=csv")

MU_2025<-
  cbind(ANHO_MU=with(MU_2025, ifelse(N_DOC!=0, "2025", "OTRO")), MU_2025)

# MU_2023_1<-
#   read.xlsx("MU FEBRERO 2023.xlsx")
# 
# MU_2023_1<-
#   cbind(ANHO_MU=with(MU_2023_1, ifelse(N_DOC!=0, "2023", "OTRO")), MU_2023_1)
# 
# 
# MU_2023<-
#   read.xlsx("MU ABRIL 2023.xlsx")
# 
#

####Agregacion postgrado 2020 - 2022#####

MAT_2020_POST<-
  read.xlsx("MAT_2020_POST.xlsx")

MAT_2020_POST<-
  cbind(ANHO_MU=with(MAT_2020_POST, ifelse(N_DOC!=0, "2020", "")), MAT_2020_POST)


MAT_2021_POST<-
  read.xlsx("MAT_2021_POST.xlsx")

MAT_2021_POST<-
  cbind(ANHO_MU=with(MAT_2021_POST, ifelse(N_DOC!=0, "2021", "")), MAT_2021_POST)

MAT_2022_POST<-
  read.xlsx("MAT_2022_POST.xlsx")

MAT_2022_POST<-
  cbind(ANHO_MU=with(MAT_2022_POST, ifelse(N_DOC!=0, "2022", "")), MAT_2022_POST)

MAT_2023_POST<-
  read.xlsx("MAT_2023_POST.xlsx")

MAT_2023_POST<-
  cbind(ANHO_MU=with(MAT_2023_POST, ifelse(N_DOC!=0, "2023", "")), MAT_2023_POST)

MAT_2024_POST<-
  read.xlsx("MAT_2024_POST.xlsx")

MAT_2024_POST<-
  cbind(ANHO_MU=with(MAT_2024_POST, ifelse(N_DOC!=0, "2024", "")), MAT_2024_POST)


MAT_2025_POST<-
  fread("https://docs.google.com/spreadsheets/d/e/2PACX-1vSzuD-ajH9yI_XH4VWiQ5-Dg7nsNHJgoZ75X_Jxm2G0RdcqSGbuVmMuZgdfiv1yGXVp3DaCfbdbUPbW/pub?gid=320575398&single=true&output=csv")

MAT_2025_POST<-
  cbind(ANHO_MU=with(MAT_2025_POST, ifelse(N_DOC!=0, "2025", "")), MAT_2025_POST)

NROW(Reduce(intersect, list(names(MU_2018),
                            names(MU_2016),
                            names(MU_2017),
                            names(MU_2019),
                            names(MU_2020), 
                            names(MU_2021),
                            names(MU_2022),
                            names(MU_2023),
                            #names(MU_2023_1),
                            names(MU_2024),
                            names(MU_2025),
                            names(MAT_2020_POST),
                            names(MAT_2021_POST),
                            names(MAT_2022_POST),
                            names(MAT_2023_POST),
                            names(MAT_2024_POST),
                            names(MAT_2025_POST))))

Reduce(intersect, list(names(MU_2021),
                            names(MU_2022), 
                            names(MU_2020)))

Reduce(setdiff, list(names(MU_2021),
                       names(MU_2022), names(MU_2020)))

MU<-
Reduce(function(x, y) merge(x, y, all=TRUE), list(MU_2019,
                                                  MU_2016,
                                                  MU_2017,
                                                  MU_2018,
                                                  MU_2020, 
                                                  MU_2021, 
                                                  MU_2022,
                                                  MU_2023,
                                                  MU_2024,
                                                  MU_2025,
                                                  #MU_2023_1,
                                                  MAT_2021_POST,
                                                  MAT_2023_POST,
                                                  MAT_2022_POST,
                                                  MAT_2020_POST,
                                                  MAT_2024_POST,
                                                  MAT_2025_POST))
# OA_2024<-
# read.xlsx("OA_2024.xlsx")
library(janitor)
OA_2025<-
tbl(con_3, "OA_SIES_2010_2025_USACH")%>% select(everything())%>%collect()

OA_2025<-
clean_names(OA_2025)

OA_2025<-
OA_2025%>%mutate(ANHO_SIES=paste(ano, codigo_unico, sep = "-"),
                 UNICIT=ifelse(nombre_ies=="UNIVERSIDAD DE SANTIAGO DE CHILE (* CARRERA EN CONVENIO U. IBEROAMERICANA)",
                        "UNICIT", "NO UNICIT"))

# with(subset(MU, VIG==1), table(ORIGEN,COD_NIV_GLO,ANHO_MU))
# 
# with(subset(MU, VIG==1), table(ORIGEN,NID_GEN,ANHO_MU))
#   
# with(subset(MU, VIG==1), round(prop.table(table(ORIGEN, ANHO_MU),2),3))

# write.xlsx(MU%>%
#              group_by(ORIGEN, COD_SIES,COD_NIV_GLO, NIV_GLO, ANHO_MU, VIG)%>%
#              summarise(n()), "extranjero_pre_post.xlsx")
# openXL("extranjero_pre_post.xlsx")


MU_CONS<-
MU[, c(1:NROW(Reduce(intersect, list(names(MU_2018),
                                     names(MU_2019),
                                     names(MU_2020),
                                     names(MU_2021),
                                     names(MU_2022),
                                     names(MU_2023),
                                     names(MU_2024),
                                     #names(MU_2023_1),
                                     names(MAT_2020_POST),
                                     names(MAT_2021_POST),
                                     names(MAT_2022_POST),
                                     names(MAT_2023_POST),
                                     names(MAT_2024_POST)))))]

MU_CONS<-
  cbind(COD_SIES=with(MU_CONS, paste("I", COD_IES, 
                                "S", COD_SED, 
                                "C", COD_CAR, 
                                "J", JOR, 
                                "V", VERSION, sep = "")), MU_CONS)

#MU_CONS<-
 # cbind(ORIGEN=with(MU_CONS, ifelse(NAC==38, "NACIONAL", "EXTRANJERO")), MU_CONS)

#MU_CONS<-
 # cbind(MU_CONS, NIV_GLO=with(MU_CONS, ifelse(COD_NIV_GLO==1, "PREGRADO",
  #                                     ifelse(COD_NIV_GLO==2, "POSTGRADO",
   #                                    ifelse(COD_NIV_GLO==3, "POSTITULO", "")))))
MU_CONS<-
MU_CONS %>% mutate(ORIGEN=ifelse(NAC==38, "NACIONAL", "EXTRANJERO"),
                   NIV_GLO=ifelse(COD_NIV_GLO==1, "PREGRADO",
                           ifelse(COD_NIV_GLO==2, "POSTGRADO",
                           ifelse(COD_NIV_GLO==3, "POSTITULO", ""))),
                   SIES_RUT=paste(COD_SIES,N_DOC,sep = "-"),
                   ANHO_SIES_RUT=paste(ANHO_MU, COD_SIES,N_DOC,sep = "-"),
                   primer_anio=ifelse(ANHO_MU==ANIO_ING_ORI, 1, 0))
# MU_CONS<-
# subset(MU_CONS, VIG==1)

# MU_CONS<-
# MU_CONS[,-1]

MU_CONS<-
  unique(MU_CONS)


ing_2030 <- as.character(c(I71S1C119J2V1,	I71S1C119J2V2,	I71S1C120J2V1,	I71S1C120J4V1,	I71S1C121J2V1,	
                           I71S1C122J2V1,	I71S1C122J2V2,	I71S1C122J2V3,	I71S1C14J1V1,	I71S1C14J1V2,	I71S1C154J2V1,	
                           I71S1C154J2V2,	I71S1C156J2V1,	I71S1C156J2V2,	I71S1C156J2V3,	I71S1C15J1V1,	I71S1C15J1V2,	
                           I71S1C16J1V1,	I71S1C16J1V2,	I71S1C17J1V1,	I71S1C17J1V2,	I71S1C18J1V1,	I71S1C18J1V2,	I71S1C19J1V1,	
                           I71S1C19J1V2,	I71S1C20J1V1,	I71S1C20J1V2,	I71S1C21J1V1,	I71S1C21J1V2,	I71S1C22J1V1,	I71S1C22J1V2,	
                           I71S1C22J2V3,	I71S1C777J1V1,	I71S1C777J2V2,	I71S1C778J1V1,	I71S1C779J1V1,	I71S1C780J1V1,	
                           I71S1C781J1V1,	I71S1C852J1V1,	I71S1C113J1V1,	I71S1C62J2V1,	I71S1C162J2V1,	I71S1C63J2V1,	
                           I71S1C279J2V1,	I71S1C783J1V1,	I71S1C114J1V1,	I71S1C131J1V1,	I71S1C393J1V1,	I71S1C91J1V1,	
                           I71S1C206J1V1,	I71S1C54J1V1,	I71S1C55J1V1,	I71S1C56J1V1, I71S1C92J1V1))


ing2030<-c("I71S1C119J2V1",	"I71S1C119J2V2",	"I71S1C120J2V1",	"I71S1C120J4V1",	"I71S1C121J2V1",	"I71S1C122J2V1",	
           "I71S1C122J2V2",	"I71S1C122J2V3",	"I71S1C14J1V1",	"I71S1C14J1V2",	"I71S1C154J2V1",	"I71S1C154J2V2",	
           "I71S1C156J2V1",	"I71S1C156J2V2",	"I71S1C156J2V3",	"I71S1C15J1V1",	"I71S1C15J1V2",	"I71S1C16J1V1",	
           "I71S1C16J1V2",	"I71S1C17J1V1",	"I71S1C17J1V2",	"I71S1C18J1V1",	"I71S1C18J1V2",	"I71S1C19J1V1",	"I71S1C19J1V2",	
           "I71S1C20J1V1",	"I71S1C20J1V2",	"I71S1C21J1V1",	"I71S1C21J1V2",	"I71S1C22J1V1",	"I71S1C22J1V2",	"I71S1C22J2V3",	
           "I71S1C777J1V1",	"I71S1C777J2V2",	"I71S1C778J1V1",	"I71S1C779J1V1",	"I71S1C780J1V1",	"I71S1C781J1V1",	
           "I71S1C852J1V1",	"I71S1C113J1V1",	"I71S1C62J2V1",	"I71S1C162J2V1",	"I71S1C63J2V1",	"I71S1C279J2V1",	"I71S1C783J1V1",	
           "I71S1C114J1V1",	"I71S1C131J1V1",	"I71S1C393J1V1",	"I71S1C91J1V1",	"I71S1C206J1V1",	"I71S1C54J1V1",	"I71S1C55J1V1",	
           "I71S1C56J1V1",	"I71S1C92J1V1")

MU_CONS<-
MU_CONS %>% mutate(ING_2030=ifelse(COD_SIES %in% ing2030,1,0))



# MU_CONS<-
#   MU_CONS %>% 
#   mutate(COD_SIES_CAR=substr(COD_SIES, 1,str_locate(COD_SIES, "J")[,1]))


library(stringr)
MU_CONS<-
MU_CONS %>% mutate(
  ANHO_SIES=paste(ANHO_MU, COD_SIES, sep = "-")) %>%
  relocate(ANHO_SIES, .before = ANHO_MU) %>% 
  mutate(ANHO_SIES_CAR=substr(ANHO_SIES, 1,str_locate(ANHO_SIES, "J")[,1])) %>% 
  relocate(ANHO_SIES_CAR, .before = ANHO_MU) %>% 
  left_join(OA_2025[,c("ANHO_SIES", "UNICIT", 
                       "nombre_carrera","nivel_carrera",
                       "tipo_carrera", "duracion_total")],  
            by ='ANHO_SIES')


unique(MU_CONS %>% mutate(anho_rut_sies=paste(ANHO_MU, N_DOC, COD_SIES, sep = "-")) %>% 
  left_join(MU_CONS_RET[,c("anho_rut_sies", "RET_1", "RET_3")], by='anho_rut_sies'))


MU_CONS %>% 
  left_join(MU_CONS_RET[,c("anho_rut_sies", "RET_1", "RET_3")], by='anho_rut_sies')
# write.xlsx(MU_CONS %>% 
#              select(COD_SIES, ANHO_MU, N_DOC, DV, A_PAT, A_MAT, NOMBRE, SEXO, VIG), "MU CONSOLIDADA_2.xlsx")
# openXL("MU CONSOLIDADA_2.xlsx")

MU_CONS<-
unique(MU_CONS %>% 
         #dplyr::filter(ANHO_MU==2023, NIV_GLO=="PREGRADO") %>% 
         left_join(tabla_depto_fac[,c("ANHO_SIES_CAR", "COD_DEPTO", "COD_FACULTAD")], 
                   by='ANHO_SIES_CAR',
                   relationship = "many-to-many"))
