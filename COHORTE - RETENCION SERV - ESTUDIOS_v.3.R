library(odbc)
library(dplyr)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 encoding = "UTF-8",
                 Server = "158.170.66.56",
                 Database = "DDI_DATOS",
                 UID = "vW_estudio",
                 PWD = "Estudio.V1st4",
                 Port = 1433)

con_2 <- dbConnect(odbc(),
                   Driver = "ODBC Driver 17 for SQL Server",
                   encoding = "UTF-8",
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


#CPP_DR<-
#  data.frame(googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1SJ5rpzMh6622Jqs3UFhEfKlziJtEAWKcEPdegqRNeJU/edit#gid=1027721539", 
                                       #sheet = "CARRERAS PROGRAMAS PLANES CORR"))
CPP_DR<-
data.frame(tbl(con_3, "CPP_DR")) %>% select(everything())

#CPP_EST<-
#data.frame(tbl(con_2, "CPP")) %>% 
 # select(everything())

ing_2030=c("ICELEC",	"ICIND",	"ICMEC",	"ICMIN",	"ICELEC",	"ICINF",	"ICOBR",	
           "ICGEOG",	"ICINF",	"ICMIN",	"ICOBR",	"ICIND",	"ICMEC",	"ICMET",	
           "ICQUIM",	"ICAMB",	"ICBIOM",	"ICBIO",	"ICMECAT",	"ICTEL",	"IGEOGEO",	
           "DOCCSING",	"MAGEII",	"MAGMA",	"MAGII",	"MAGSGI",	"MAGIE",	"MAGCDI")

VIA_ING_ANIO=c(81,63,26,29,	21,	66,	50,	15,	20,	49,	17,	60,	72,	43,	71,	10,	
              70,53,30,54,	55,	44,	16,	87,	95,	97,	85,	37,	68,	86,	19,	75,	
              64,62,76,27,	14,	77,	11,	74,	65,	12,	84,	73,	18,	83,	61, 99)

######Carga Tabla Matrícula##########
#MAT<-
#data.frame(tbl(con_2, "MATRICULA_ESTUDIOS_AL_20240502")) %>% 
 # mutate(ANHO=substr(PERIODO_MATRICULA,1,4),
  #       RUT=as.numeric(RUT),
   #      ANHO_PLAN=paste(ANHO,"-",COD_PLAN, sep = ""),
    #     ING_2030=ifelse(COD_CARR_PROG %in% ing_2030,1,0)) %>% 
  #group_by(RUT,ANHO, ANHO_PLAN,COD_PLAN,CODIGO_CARRERA=COD_CARR_PROG,  ING_2030) %>% 
  #summarise(freq=n_distinct(RUT))


# data.frame(tbl(con_3, "MATRICULA")) %>%
#   mutate(
#     anho = substr(periodo_matricula, 1, 4),
#     rut = as.numeric(rut),
#     ANHO_PLAN = paste0(anho, cod_plan, sep = "-")
#   ) %>%
#   group_by(rut, anho, ANHO_PLAN, cod_plan, CODIGO_CARRERA = cod_carr_prog) %>%
#   summarise(freq = n_distinct(rut))
# 
# tbl(con_3, "MATRICULA") %>% mutate(
#   anho = substr(periodo_matricula, 1, 4),
#   rut = as.numeric(rut),
#   ANHO_PLAN = paste(anho, "-", cod_plan, sep = ""),
#   sql("CONCAT(anho, "-" ,cod_plan)")
# ) %>%
#   group_by(anho, rut) %>% summarise(n_distinct(rut))


MAT<-
tbl(con_3, "MATRICULA") %>% 
  mutate(
    rut = as.numeric(rut),
    ANHO = substr(periodo_matricula, 1, 4),
    ANHO_ING = substr(ingreso_plan, 1, 4),
    ANHO_PLAN = paste0(as.character(ANHO), "-", as.character(cod_plan)),
    ING_2030 = ifelse(cod_carr_prog %in% ing_2030, 1, 0),
    COH = ifelse(cod_via %in% VIA_ING_ANIO & ANHO_ING == ANHO, 1, 0)
    ) %>%
  group_by(ANHO, 
           rut,
           COH,
           sexo, 
           cod_plan,
           ING_2030,
           ANHO_PLAN,
           CODIGO_CARRERA=cod_carr_prog,
           via_ingreso, 
           cod_via,
           carrera_programa) %>% 
  summarise(n_distinct(rut)) %>% 
  collect()

MAT<-
MAT %>% rename(RUT=rut, COD_PLAN=cod_plan)


CPP_DR<-
  cbind(CPP_DR, ANHO_PLAN=with(CPP_DR, paste(ANHO,"-", COD_PLAN2, sep = "")))


####Interrelación tablas############
MAT <-
  merge(MAT, CPP_DR[, c("ANHO_PLAN", "LLAVE_SIES")],
        by = "ANHO_PLAN", all.x = T)


#COH <-
 # tbl(con_2, "COHORTE_AL_20240502") %>%
 # dplyr::filter(COHORTE_FORM_B == 1) %>%
  #mutate(
   # ING_2030 = ifelse(CODIGO_CARRERA %in% ing_2030, 1, 0),
    #RUT = as.numeric(RUT),
    #ID = paste(as.character(ANHO), as.character(RUT), as.character(COD_PLAN), sep = "-"),
    #ID_2 = paste(as.character(RUT), as.character(CODIGO_CARRERA), sep = "-")
  #) %>%
  #group_by(
   # ID,
   # ID_2,
   # RUT,
    #ANHO,
    #COD_PLAN,
    #DURACION_TOTAL,
    #INGRESO,
    #CODIGO_CARRERA,
    #COHORTE_FORM_B,
    #SEXO,
    #COD_DEPTO,
    #CODIGO_PROGRAMA_SIES,
    #VIA_INGRESO,
    #ING_2030
  #) %>%
  #summarise(freq = n_distinct(RUT)) %>% collect()

COH<-
tbl(con_3, "MATRICULA") %>%
  mutate(
    rut = as.numeric(rut),
    ANHO = substr(periodo_matricula, 1, 4),
    ANHO_ING = substr(ingreso_plan, 1, 4),
    ANHO_PLAN = paste0(as.character(ANHO), "-", as.character(cod_plan)),
    ING_2030 = ifelse(cod_carr_prog %in% ing_2030, 1, 0),
    COH = ifelse(cod_via %in% VIA_ING_ANIO & ANHO_ING == ANHO, 1, 0)
  ) %>%
  rename(RUT = rut,
         COD_PLAN = cod_plan,
         SEXO = sexo) %>%
  filter(COH == 1) %>%
  group_by(ANHO,
           RUT,
           COH,
           SEXO,
           COD_PLAN,
           ING_2030,
           ANHO_PLAN,
           CODIGO_CARRERA=cod_carr_prog,
           via_ingreso,
           cod_via,
           carrera_programa) %>%
  summarise(n_distinct(RUT)) %>%
  collect() %>%
  data.frame() %>%
  left_join(
    CPP_DR[, c("ANHO_PLAN", "LLAVE_SIES", "SIES")],
    by = "ANHO_PLAN"
  )


tbl(con_3, "MATRICULA") %>% filter(rut == "14741793") %>%
  select(rut, ap_paterno, ap_materno, nombres)


BASE_RET_ALT <-
unique(merge(COH, 
             MAT[,c("RUT", "ANHO", "COD_PLAN",
                    "CODIGO_CARRERA","COH" ,"ING_2030")], 
             by = "RUT", all = T))

BASE_RET_ALT%>% filter(RUT=="14741793")%>%
  select(RUT, 
         ANHO.x, 
         ANHO.y, 
         CODIGO_CARRERA.x, 
         COD_PLAN.x)

#BASE_RET_ALT<-
 # BASE_RET_ALT %>%
  #mutate(LLAVE_SIES_REC=paste(ANHO.x, CODIGO_PROGRAMA_SIES, sep = "-"))

BASE_RET_ALT$ANHO.x<-
  as.numeric(BASE_RET_ALT$ANHO.x)


BASE_RET_ALT$ANHO.y<-
  as.numeric(BASE_RET_ALT$ANHO.y)

###Construcción NIVEL GLOBAL################

BASE_RET_ALT<-
  cbind(BASE_RET_ALT, NIVEL_GLOBAL=with(BASE_RET_ALT, 
                                            ifelse(substr(CODIGO_CARRERA.x,1,3)=="DOC", "DOCTORADO",
                                            ifelse(substr(CODIGO_CARRERA.x,1,3)=="MAG", "MAGISTER", 
                                            ifelse(substr(CODIGO_CARRERA.x,1,3)=="DIP", "DIPLOMADO",
                                            ifelse(substr(CODIGO_CARRERA.x,1,3)=="POS", "POSTÍTULO",
                                            ifelse(CODIGO_CARRERA.x=="MIDA", "MAGISTER", "PREGRADO")))))))



###Calculo Cohorte######
#BASE_RET_ALT<-
 # cbind(BASE_RET_ALT, COH=with(BASE_RET_ALT, ifelse(ANHO.x==ANHO.y & 
  #                                                  COD_PLAN.x==COD_PLAN.y,1,0)))


###Agregación ID######
BASE_RET_ALT<-
  BASE_RET_ALT%>%
  mutate(ID=paste(RUT, ANHO.x, COD_PLAN.x, sep = "-"))

#BASE_RET_ALT%>%
#mutate(ID_ANHO=paste(RUT, ANHO.x, sep = "-"))

OA_2025<-
data.frame(tbl(con_3, "OA_SIES_2010_2025_USACH")) %>% select(everything())

BASE_RET_ALT <-
  merge(BASE_RET_ALT,
        OA_2025[, c("llave",
                    "Tipo_Carrera",
                    "Duración_Total",
                    "Demre",
                    "Código_Único")],
        by.x = "LLAVE_SIES",
        by.y = "llave",
        all = T)


###Calculo retención primer año##########

BASE_RET_ALT<-
  cbind(BASE_RET_ALT, RET_1=with(BASE_RET_ALT, ifelse(ANHO.x!=ANHO.y & 
                                                        ANHO.y-ANHO.x==1 & 
                                                        COD_PLAN.x==COD_PLAN.y, 1,
                                               ifelse(ANHO.x!=ANHO.y & ANHO.y-ANHO.x==1 & 
                                                        COD_PLAN.x!=COD_PLAN.y & 
                                                        CODIGO_CARRERA.x==CODIGO_CARRERA.y,1,0))))

BASE_RET_ALT<-
  cbind(BASE_RET_ALT, RET_INST=with(BASE_RET_ALT, 
                                    ifelse(ANHO.x!=ANHO.y & ANHO.y-ANHO.x==1,1,
                                    ifelse(ANHO.x!=ANHO.y & ANHO.y-ANHO.x==1,1,0))))

BASE_RET_ALT<-
BASE_RET_ALT %>% mutate(RET_1_ING_2030=ifelse(ING_2030.x==1 & RET_1==1,1,
                                       ifelse(ING_2030.x==1 & ANHO.x!=ANHO.y &
                                              ANHO.y-ANHO.x==1 & ING_2030.x==ING_2030.y,1,0)))

###Calculo retención segundo año##########

BASE_RET_ALT<-
  cbind(BASE_RET_ALT, RET_2=with(BASE_RET_ALT, ifelse(ANHO.x!=ANHO.y & 
                                                        ANHO.y-ANHO.x==2 & 
                                                        COD_PLAN.x==COD_PLAN.y, 1,
                                                ifelse(ANHO.x!=ANHO.y & ANHO.y-ANHO.x==2 & 
                                                        COD_PLAN.x!=COD_PLAN.y & 
                                                        CODIGO_CARRERA.x==CODIGO_CARRERA.y,1,0))))



BASE_RET_ALT<-
  BASE_RET_ALT %>% mutate(RET_2_ING_2030=ifelse(ING_2030.x==1 & RET_2==1,1,
                                                ifelse(ING_2030.x==1 & ANHO.x!=ANHO.y &
                                                         ANHO.y-ANHO.x==2 & ING_2030.x==ING_2030.y,1,0)))


###Calculo retención tercer año##########

BASE_RET_ALT<-
  cbind(BASE_RET_ALT, RET_3=with(BASE_RET_ALT, ifelse(ANHO.x!=ANHO.y & 
                                                        ANHO.y-ANHO.x==3 & 
                                                        COD_PLAN.x==COD_PLAN.y, 1,
                                                ifelse(ANHO.x!=ANHO.y & 
                                                        ANHO.y-ANHO.x==3 & 
                                                        CODIGO_CARRERA.x==CODIGO_CARRERA.y, 1,0))))


BASE_RET_ALT<-
  BASE_RET_ALT %>% mutate(RET_3_ING_2030=ifelse(ING_2030.x==1 & RET_3==1,1,
                                         ifelse(ING_2030.x==1 & ANHO.x!=ANHO.y &
                                                ANHO.y-ANHO.x==3 & ING_2030.x==ING_2030.y,1,0)))


###Calculo retención cuarta año##########

BASE_RET_ALT<-
  cbind(BASE_RET_ALT, RET_4=with(BASE_RET_ALT, ifelse(ANHO.x!=ANHO.y & 
                                                        ANHO.y-ANHO.x==4 & 
                                                        COD_PLAN.x==COD_PLAN.y, 1,
                                                      ifelse(ANHO.x!=ANHO.y & 
                                                               ANHO.y-ANHO.x==4 & 
                                                               CODIGO_CARRERA.x==CODIGO_CARRERA.y, 1,0))))


BASE_RET_ALT<-
  BASE_RET_ALT %>% mutate(RET_4_ING_2030=ifelse(ING_2030.x==1 & RET_4==1,1,
                                                ifelse(ING_2030.x==1 & ANHO.x!=ANHO.y &
                                                         ANHO.y-ANHO.x==4 & ING_2030.x==ING_2030.y,1,0)))


#####Selección Niveles Pertinentes###########
# BASE_RET_ALT<-
#   subset(BASE_RET_ALT, 
#          NIVEL_GLOBAL=="PREGRADO" 
#          | NIVEL_GLOBAL=="DOCTORADO" 
#          | NIVEL_GLOBAL=="MAGISTER")



BASE_RET_ALT%>%
  dplyr::filter(ANHO.x==2022, COD_PLAN.x==9109)%>%
  group_by(NIVEL_GLOBAL, RET_1, COD_PLAN.x)%>%
  summarise(n=n_distinct(RUT))


#######TABLA RAPIDA SIN GUARDADO######
#BASE_RET_ALT%>%
 # dplyr::filter(RET_1!="", NIVEL_GLOBAL=="PREGRADO")%>%
  #group_by(ANHO.x, SEXO, CODIGO_CARRERA.x, NOMBRE_DEPTO, RET_1)%>%
  #distinct(RUT)%>%
  #summarise(freq=n())

BASE_RET_ALT%>%
  dplyr::filter(COD_PLAN.x==9109, ANHO.x==2022)%>%
  group_by(RET_1, ANHO.x)%>%
  summarise(n_distinct(RUT))


#####1.1 Extracción Cohorte R#######

names(BASE_RET_ALT)

COH_REG_ALT<-
  data.frame(subset(BASE_RET_ALT, COH.x==1 & 
                      #NIVEL_GLOBAL=="PREGRADO" & 
                      ANHO.x>2010)%>%
               #dplyr::filter(COH==1 | NIVEL_GLOBAL== "PERGRADO")%>%
               group_by(ID, RUT, ANHO.x, SEXO, 
                        COD_PLAN.x, COH.x, CODIGO_CARRERA.x,
                        NIVEL_GLOBAL, Tipo_Carrera, Demre,
                        SIES)%>%
               summarise(n_distinct(RUT)))



#####1.2 Identificador cod demre####
COH_REG_ALT<-
  COH_REG_ALT%>%
  mutate(RUT_ANHO_DEMRE=paste(RUT, ANHO.x, Demre, sep = "-"))


RETENIDOS_ALT<-
  subset(BASE_RET_ALT, RET_1==1)

RETENIDOS_ALT_2<-
  subset(BASE_RET_ALT, RET_2==1)

RETENIDOS_ALT_3<-
  subset(BASE_RET_ALT, RET_3==1)

RETENIDOS_ALT_4<-
  subset(BASE_RET_ALT, RET_4==1)


RETENIDOS_ALT_INST<-
  subset(BASE_RET_ALT, RET_INST==1)


####ret ing 20230#####
RETENIDOS_ALT_ING2030<-
  subset(BASE_RET_ALT, RET_1_ING_2030==1)

RETENIDOS_ALT_2_ING2030<-
  subset(BASE_RET_ALT, RET_2_ING_2030==1)

RETENIDOS_ALT_3_ING2030<-
  subset(BASE_RET_ALT, RET_3_ING_2030==1)

RETENIDOS_ALT_4_ING2030<-
  subset(BASE_RET_ALT, RET_4_ING_2030==1)



COH_RET_REG_ALT<-
  unique(merge(COH_REG_ALT, RETENIDOS_ALT[,c("ID", "RET_1")], 
               by="ID", all.x = T))

COH_RET_REG_ALT<-
  unique(merge(COH_RET_REG_ALT, RETENIDOS_ALT_2[,c("ID", "RET_2")], 
               by="ID", all.x = T))

COH_RET_REG_ALT<-
  unique(merge(COH_RET_REG_ALT, RETENIDOS_ALT_3[,c("ID", "RET_3")], 
               by="ID", all.x = T))

COH_RET_REG_ALT<-
  unique(merge(COH_RET_REG_ALT, RETENIDOS_ALT_4[,c("ID", "RET_4")], 
               by="ID", all.x = T))

COH_RET_REG_ALT<-
  unique(merge(COH_RET_REG_ALT, RETENIDOS_ALT_INST[,c("ID", "RET_INST")], 
               by="ID", all.x = T))

####Ing2030####
COH_RET_REG_ALT<-
  unique(merge(COH_RET_REG_ALT, RETENIDOS_ALT_ING2030[,c("ID", "RET_1_ING_2030")], 
               by="ID", all.x = T))

COH_RET_REG_ALT<-
  unique(merge(COH_RET_REG_ALT, RETENIDOS_ALT_2_ING2030[,c("ID", "RET_2_ING_2030")], 
               by="ID", all.x = T))

COH_RET_REG_ALT<-
  unique(merge(COH_RET_REG_ALT, RETENIDOS_ALT_3_ING2030[,c("ID", "RET_3_ING_2030")], 
               by="ID", all.x = T))

COH_RET_REG_ALT<-
  unique(merge(COH_RET_REG_ALT, RETENIDOS_ALT_4_ING2030[,c("ID", "RET_4_ING_2030")], 
               by="ID", all.x = T))

COH_RET_REG_ALT$RET_1[is.na(COH_RET_REG_ALT$RET_1)]<-0
COH_RET_REG_ALT$RET_2[is.na(COH_RET_REG_ALT$RET_2)]<-0
COH_RET_REG_ALT$RET_3[is.na(COH_RET_REG_ALT$RET_3)]<-0
COH_RET_REG_ALT$RET_4[is.na(COH_RET_REG_ALT$RET_4)]<-0

COH_RET_REG_ALT$RET_INST[is.na(COH_RET_REG_ALT$RET_INST)]<-0

COH_RET_REG_ALT$RET_1_ING_2030[is.na(COH_RET_REG_ALT$RET_1_ING_2030)]<-0
COH_RET_REG_ALT$RET_2_ING_2030[is.na(COH_RET_REG_ALT$RET_2_ING_2030)]<-0
COH_RET_REG_ALT$RET_3_ING_2030[is.na(COH_RET_REG_ALT$RET_3_ING_2030)]<-0
COH_RET_REG_ALT$RET_4_ING_2030[is.na(COH_RET_REG_ALT$RET_4_ING_2030)]<-0

################base retención################################

write_clip(COH_RET_REG_ALT %>% group_by(ANHO.x, COD_PLAN.x, NIVEL_GLOBAL,
                                        CODIGO_CARRERA.x, COH,RET_1) %>% summarise(n()))

####Agregación información DEMRE#####
COH_RET_REG_ALT<-
  merge(COH_RET_REG_ALT, DEMRE_E[,c("ID_ANHO_CARRERA", 
                                    "PROMEDIO_NOTAS", "PTJE_NEM", 
                                    "PTJE_RANKING", "RAMA_EDUCACIONAL",
                                    "GRUPO_DEPENDENCIA", "ESTADO_DE_LA_POSTULACION",
                                    "EDAD_2","PUNTAJE_PONDERADO","INGRESO_PERCAPITA_GRUPO_FA",
                                    "CODIGO_COMUNA", "COMP_LECT","MATEMATICA","HIST_CS_SOC",
                                    "CIENCIAS","PROMEDIO", "CODIGO_REGION")], 
        by.x = "RUT_ANHO_DEMRE", by.y = "ID_ANHO_CARRERA", all.x = T)

COH_RET_REG_ALT<-
  cbind(COH_RET_REG_ALT, ESTA_DEMRE=with(COH_RET_REG_ALT, ifelse(is.na(PROMEDIO_NOTAS) & 
                                                                   is.na(PTJE_NEM) &
                                                                   is.na(PTJE_RANKING),"0", "1")))

COH_RET_REG_ALT<-
  cbind(COH_RET_REG_ALT, TIPO_ACCESO=with(COH_RET_REG_ALT, ifelse(VIA_INGRESO=="CUPO P.S.U." |
                                                                    VIA_INGRESO=="CUPO P.D.T." |
                                                                    VIA_INGRESO=="CUPO BEA" |
                                                                    VIA_INGRESO=="CUPO OFICIO DEMRE",

COH_RET_REG_ALT %>% filter(RUT == "14741793") %>% 
select(RUT, ANHO.x, RET_1, RET_2)

NROW(COH_RET_REG_ALT)
names(COH_RET_REG_ALT)


# write.xlsx(COH_RET_REG_ALT, "COH_RET_REG.xlsx")
# openXL("COH_RET_REG.xlsx")

write.csv2(COH_RET_REG_ALT, "COH_RET_REG_ALT_INST.csv")

NROW(COH_RET_REG_ALT %>% 
       #dplyr::filter(CODIGO_CARRERA.x=="ARQ") %>% 
       group_by(ANHO.x, CODIGO_CARRERA.x, RET_1) %>% 
       summarise(n=n_distinct(RUT)))

spread(COH_RET_REG_ALT %>% 
         dplyr::filter(CODIGO_CARRERA.x=="ARQ") %>% 
         group_by(ANHO.x, CODIGO_CARRERA.x, RET_1) %>% 
         summarise(n=n_distinct(RUT)), ANHO.x, n)

write.xlsx(COH_RET_REG_ALT, "COH_RET_REG.xlsx")
openXL("COH_RET_REG.xlsx")

write.csv2(COH_RET_REG_ALT, "COH_RET_REG_ALT.csv")

NROW(merge(COH_RET_REG_ALT, BASE_RET_ALT[,c("ID", "RET_2")], by="ID", all.x = T))

###GUARDADO TABLA########## 

#write.xlsx(BASE_RET_ALT%>%
#            dplyr::filter(CODIGO_CARRERA=="MED")%>%
#           group_by(ANHO.x, SEXO, CODIGO_CARRERA, NOMBRE_DEPTO, RET_1)%>%
#          summarise(freq=n_distinct(RUT)), "visor.xlsx")
#openXL("visor.xlsx")

#write.xlsx(BASE_RET_ALT%>%
#            dplyr::filter(RET_1!="", NIVEL_GLOBAL=="PREGRADO")%>%
#           group_by(ANHO.x, SEXO, CODIGO_CARRERA, NOMBRE_DEPTO, RET_1)%>%
#          distinct(RUT)%>%
#         summarise(freq=n(), "visor2.xlsx"))

#openXL("visor2.xlsx")


#rpivotTable(
#BASE_RET_ALT%>%
# dplyr::filter(RET_1!="", NIVEL_GLOBAL=="PREGRADO")%>%
#  group_by(ANHO.x, SEXO, CODIGO_CARRERA, NOMBRE_DEPTO, RET_1, RET_2)%>%
#  distinct(RUT)%>%
#  summarise(freq=n())%>%
#  mutate(percent = paste(round((freq/sum(freq)),2)*100, "%", sep = "")), 
#  subtotals = F,
# rows = c("CODIGO_CARRERA","RET_1"),
#  cols = "ANHO.x")


#tabla_test<-
#with(subset(BASE_RET_ALT, CODIGO_CARRERA=="PSI"), addmargins(table(RET_3, ANHO.x)))

#write.xlsx(BASE_RET_ALT, "BASE_RET_ALT.xlsx")

