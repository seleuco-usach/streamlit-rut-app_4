
#setwd("/media/xenomorfo/Windows/Users/USACH/OneDrive - usach.cl/Escritorio/ANALISTA ESTUDIOS/PAC")
setwd("/home/xenomorfo/PAC")
library(dplyr)
library(openxlsx)
library(lubridate)
library(janitor)

PAC_2025<-
googlesheets4::read_sheet(
  "https://docs.google.com/spreadsheets/d/1NpUYt-BrNSkli5YL9JTQz9WdeL0WtGbjytKDrQh114M/edit?gid=86324282#gid=86324282",
  col_types = paste(rep("c", 42), collapse = ""), skip = 1
) %>% 
  mutate(across(where(is.character), function(x) chartr("ÁÉÍÓÚ", "AEIOU", x)))

PAC_2025<-
PAC_2025 %>% mutate(ESTA.EN.EEMM=ifelse(!is.na(Nivel.de.formación.especialidad),1,0))
###Validacion SIES 2024####
PAC_2025[grep("12140502", PAC_2025$RUT),"Cod..Nivel.Formación"]="3"
PAC_2025[grep("14597410", PAC_2025$RUT),"Cod..Nivel.Formación"]="3"
PAC_2025[grep("14717481", PAC_2025$RUT),"Cod..Nivel.Formación"]="3"
PAC_2025[grep("14731528", PAC_2025$RUT),"Cod..Nivel.Formación"]="3"

PAC_2025[grep("7930955", PAC_2025$RUT),"Cod..Nivel.Formación"]="2"
PAC_2025[grep("7930955", PAC_2025$RUT),"Nombre.del.grado./.tItulo.obtenido"]="MAGISTER EN COMUNICACION SOCIAL"

PAC_2025[grep("10223338", PAC_2025$RUT),"Cod..Nivel.Formación"]="2"
PAC_2025[grep("10223338", PAC_2025$RUT),"Nombre.del.grado./.tItulo.obtenido"]="MASTER OF SCIENCE IN FINANCE"

PAC_2025[grep("15644057", PAC_2025$RUT),"Cod..Nivel.Formación"]="2"
PAC_2025[grep("15644057", PAC_2025$RUT),"Nombre.del.grado./.tItulo.obtenido"]="MASTER UNIVERSITARIO EN INGENIERIA ACUSTICA DE LA EDIFICACION Y MEDIO AMBIENTE"

PAC_2025[grep("12863361", PAC_2025$RUT),"Cod..Nivel.Formación"]="2"
PAC_2025[grep("12863361", PAC_2025$RUT),"Nombre.del.grado./.tItulo.obtenido"]="MASTER EN LIDERAZGO Y DESARROLLO PERSONAL"

PAC_2025<-
PAC_2025[PAC_2025$RUT!=12863361,]

PAC_2025<-
PAC_2025 %>% mutate(Unidad.Mayor_CONTRATO=ifelse(Unidad.Mayor_CONTRATO=="INSTITUTO DE ESTUDIOS AVANZADOS IDEA", 
                           "VICERRECTORIA ACADEMICA", 
                           ifelse(Unidad.Mayor_CONTRATO=="PROGRAMA DE BACHILLERATO", "PROGRAMA BACHILLERATO",
                                  Unidad.Mayor_CONTRATO)))

#PAC_2024[grep("18919096", PAC_2024$RUT),"Cod..Nivel.Formación"]=2


# PAC_2024[grep("10381023", PAC_2024$RUT),"Cod..Nivel.Formación"]=2
# PAC_2024[grep("23912754", PAC_2024$RUT),"Cod..Nivel.Formación"]=2
# PAC_2024[grep("7930955", PAC_2024$RUT),"Cod..Nivel.Formación"]=3


campos_pac<-
read.xlsx("PAC 2024/REVISION_PAC_2024_V.2.xlsx", sheet = "CAMPOS PAC")

PAC_VIPO_2023<-
  read.xlsx("PAC 2023/VIPO_2023_V.2.xlsx")


CC_2023<-
  read.xlsx("PAC 2023/CC_2023.xlsx")

CC_2023<-
  CC_2023 %>% 
  mutate(across(where(is.character), function(x) chartr("áéíóú", "aeiou", x)))


CC_2023$NOMBRE.COMPLETO<-
  toupper(CC_2023$NOMBRE.COMPLETO)

CC_2023$C.Costo<-
  as.numeric(CC_2023$C.Costo)


PAC_2025<-
  PAC_2025[,!grepl("sin.equiv|CALC", names(PAC_2025))]

PAC_2025<-
  PAC_2025 %>%
  mutate(across(where(is.character), function(x) chartr("ÁÉÍÓÚ", "AEIOU", x)),
         across(where(is.character), function(x) gsub(" $","", x, perl=T)),
         Total.Horas=as.numeric(Total.Horas))



####Tablas info adicional PAC####

tab_CC<-
  read.xlsx("PAC 2024/REVISION_PAC_2024_V.2.xlsx", sheet = "5 UNIDADES", startRow = 2)

tab_CC %>% mutate(across(where(is.character), ~toupper(.)),
                  across(where(is.character),~chartr("ÁÉÍÓÚÜÑ","AEIOUUN",.)))

tab_jerarquias<-
  read.xlsx("PAC 2024/REVISION_PAC_2024_V.2.xlsx", sheet = "7 HOMOLOGACIÓN JERARQUÍAS")

fila = data.frame(
  Jeraquía_categoría = "PROFESOR ASISTENTE",
  Tipo.de.Jornada = "Por Jornadas",
  Con_CatJer = "Jerarquia"
  
)

fila2 = data.frame(
  Jeraquía_categoría = "PROFESOR ASOCIADO",
  Tipo.de.Jornada = "Por Jornadas",
  Con_CatJer = "Jerarquia"
  
)


fila3 = data.frame(
  Jeraquía_categoría = "PROFESOR TITULAR",
  Tipo.de.Jornada = "Por Jornadas",
  Con_CatJer = "Jerarquia"
  
)



tab_jerarquias<-
rbind(tab_jerarquias, fila, fila2, fila3)

tab_formacion<-
  read.xlsx("PAC 2024/REVISION_PAC_2024_V.2.xlsx", sheet = "6 NIVEL FORMACIÓN")

tab_paises<-
  read.xlsx("PAC 2023/PAC 2023 JUNIO V.1.xlsx", sheet = "1 TAB PAISES")

tab_paises$NOMBRE.PAIS.OBT.TIT<-tab_paises$NOMBRE.PAIS
tab_paises$NOMBRE.PAIS.OBT.ESP<-tab_paises$NOMBRE.PAIS

PAC_2008_2024<-
  read.xlsx("PAC_2008_2024_V.4.xlsx")

tab_anho_inst<-
  PAC_2008_2024 %>% 
  mutate(anhos_inst=as.numeric(gsub(",",".",Número.de.años.en.la.institución))) %>% 
  group_by(Rut) %>% 
  summarise(anho_2025=max(anhos_inst)+1)

tab_ped<-
  data.frame(CC.PED=c(59,	51,	57,	87,	52,	56,	58,	96),
             ped=c("si", "si", "si", "si", "si", "si", "si", "si"))

tab_grados<-
  data.frame(grado=as.numeric(seq(1:8)), nivel_form=c("DOCTOR",	"MAGÍSTER",	"TÍTULO PROFESIONAL",	"LICENCIATURA",	
                                                      "TÉCNICO DE NIVEL SUPERIOR",	"TÍTULO TÉCNICO DE NIVEL MEDIO",	
                                                      "LICENCIA MEDIA",	"SIN INFORMACIÓN"))

CC<-
data.frame(googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1SJ5rpzMh6622Jqs3UFhEfKlziJtEAWKcEPdegqRNeJU/edit#gid=1027721539",
                                    sheet = "CENTROS DE COSTO"))


Reduce(intersect, list(names(CC),
                       names(tab_CC)))

Reduce(setdiff, list(names(CC),
                     names(tab_CC)))

CC<-
  Reduce(function(x, y) merge(x, y, all=T), list(CC,
                                                 tab_CC))

CC<-
  CC %>% 
  mutate(CC.TEXT_REC=substr(CC.TEXT,ifelse(grepl("-", CC.TEXT), 7, 0),nchar(CC.TEXT)),
         UM.TEXT=substring(UM.TEXT, regexpr("-", UM.TEXT)+2),
         across(where(is.character), ~toupper(.)),
         across(where(is.character), function(x) chartr("ÁÉÍÓÚ", "AEIOU", x)))



tab_CC$CC.CONTRATO.MAYOR<-tab_CC$CC...1

tab_CC$CC.CONTRATO.MENOR<-tab_CC$CC...4

CC$CC.CONTRATO.MAYOR<-CC$CC...1

CC$CC.CONTRATO.MENOR<-CC$CC...4


nuevo_registro <- data.frame(
  `CC...1` = "15",
  `UM.TEXT` = "VICERRECTORIA ACADEMICA",
  `CC...4` = 8,
  `CC.TEXT` = "IDEA",
  `Tipo.Unidad` = "UNIDAD ADMINISTRATIVA",
  UM = "UM015",
  `CC.CONTRATO.MAYOR` = "15",
  `CC.CONTRATO.MENOR` = 8,
  `CC.TEXT_REC` = "INSTITUTO DE ESTUDIOS AVANZADOS IDEA"
)

nuevo_registro2 <- data.frame(
  `CC...1` = "120",
  `UM.TEXT` = "VICERRECTORIA DE VINCULACION CON EL MEDIO",
  `CC...4` = 120,
  `CC.TEXT` = "UNIDAD DE ESTUDIOS E INSTRUMENTOS DE VINCULACION CON EL MEDIO",
  `Tipo.Unidad` = "UNIDAD ADMINISTRATIVA",
  UM = "UM120",
  `CC.CONTRATO.MAYOR` = "120",
  `CC.CONTRATO.MENOR` = 120,
  `CC.TEXT_REC` = "UNIDAD DE ESTUDIOS E INSTRUMENTOS DE VINCULACION CON EL MEDIO"
)



CC<-
  rbind(CC, nuevo_registro, nuevo_registro2)

CC<-
  unique(CC)

CC_MAYOR<-
  CC %>% group_by(UM,UM.TEXT) %>% dplyr::filter(!is.na(UM)) %>% summarise(Tot=n())

CC_MAYOR$UM.TEXT<-
  chartr("ÁÉÍÓÚ", "AEIOU", CC_MAYOR$UM.TEXT)

CC_MAYOR<-
  CC_MAYOR %>% mutate(CC=as.numeric(substr(UM,3,5)))

CC_MAYOR<-
  rbind(CC_MAYOR, data.frame(UM=c("UM081","UM060","UM120",
                                  "UM110", "UM140", "UM015","UM022","UM011",
                                  "UM060", "UM030"),
                             UM.TEXT = c("FAC ARQ Y AMBIENTE CONSTRUIDO",
                                         "FACULTAD DE ADMINIST Y ECONOMI",
                                         "VR VINCULACION CON EL MEDIO",
                                         "VICERRECTORIA DE POSTGRADO",
                                         "VR CAL VIDA GEN EQUID Y DIV",
                                         "VR ACADEMICA",
                                         "VR DE APOYO AL ESTUDIANTE",
                                         "VR INV E INNOVACION Y CREACION",
                                         "FACULTAD DE ADMINISTRACION Y ECONOMIA",
                                         "VR DE FINANZAS Y LOGISTICA"), 
                             Tot=c(0,0,0,0,0,0,0,0,0,0),
                             CC=c(81,60,120,110,140,15,22,11,60,30)))


PAC_2025_REC<-
  unique(PAC_2025 %>% 
           mutate(Clave.Año=paste("2025", RUT, sep = "-"), 
                  Año=ifelse(RUT!=0,"2025", "otro"),
                  RUT=as.numeric(RUT),
                  cod.nac=as.numeric(cod.nac),
                  cod.pais.esp=as.numeric(cod.pais.esp),
                  `cod pais obt tit`=as.numeric(`cod pais obt tit`),
                  Cod..Nivel.Formación=as.numeric(Cod..Nivel.Formación),
                  JCE=ifelse(Total.Horas>=44,1,Total.Horas/44),
                  JCE_GRADO=ifelse(JCE<=3, JCE, 0),
                  JCE_DOC=ifelse(JCE==1, JCE, 0),
                  NPAC_D_Completa=ifelse(Total.Horas>=33, 1, 0),
                  JC40=ifelse(Total.Horas>=40,"JC","OTRA"),
                  JORNADA.INTERNA=ifelse(Total.Horas<11, "HORAS", 
                                         ifelse(Total.Horas<22, "1/4 JORNADA", 
                                         ifelse(Total.Horas<33, "1/2 JORNADA", 
                                         ifelse(Total.Horas<44, "3/4 JORNADA","JORNADA COMPLETA")))),
                  JORNADA.ACREDITACIÓN..CNA.CHILE.=
                           ifelse(Total.Horas<22, "HORAS", 
                           ifelse(Total.Horas<44, "MEDIA JORNADA", "JORNADA COMPLETA")),
                  JORNADA.CNED=ifelse(Total.Horas<20, "HORAS", 
                               ifelse(Total.Horas<33, "MEDIA JORNADA", "JORNADA COMPLETA")),
                  Edad_año=floor(time_length(ymd(Sys.Date()) - as.Date(PAC_2025$FECHA.DE.NACIMIENTO, origin="1901-01-01"), unit = "year")),
                  #Fecha.de.nacimiento=as.Date(PAC_2023$FECHA.DE.NACIMIENTO, origin="1901-01-01"),
                  tramo_edad=ifelse(Edad_año<35, "t1", 
                             ifelse(Edad_año<50, "t2", 
                             ifelse(Edad_año<65,"t3","t4"))),
                  verifica.1=ifelse(as.numeric(`N°.de.horas.con.contrato.a.Contrata.(Plazo.fijo)`) + 
                                      as.numeric(`N°.de.horas.con.contrato.de.Planta.(indefinido)`) + 
                                      as.numeric(`N°.de.horas.con.contrato.a.Honorarios`)==Total.Horas,1,0),
                  verifica.2=ifelse(verifica.1==1,1,0),
                  #Nivel.Formación.CORR=ifelse(Nivel.Formación!=0,Nivel.Formación,0),
                  Cod..Nivel.Formación.CORR=ifelse(Cod..Nivel.Formación!=0,Cod..Nivel.Formación,0),
                  tramo_edad_ACREDITACIÓN=ifelse(Edad_año<35, "t1", 
                                          ifelse(Edad_año<55,"t3",
                                          ifelse(Edad_año<65,"t4","t5"))),
                  COMPARTE.NIVEL=ifelse(as.numeric(`N°.de.horas.con.contrato.a.Contrata.(Plazo.fijo)`) + 
                                          as.numeric(`N°.de.horas.con.contrato.de.Planta.(indefinido)`)>=1,NA,NA),
                  especialidad=ifelse(NIVEL.ESPECIALIDAD==1, "Especialidad", 
                                      ifelse(Nivel.de.formación.especialidad==1 | Nivel.de.formación.especialidad==2, "Especialidad", "")),
                  JCE.35.Times=ifelse(Total.Horas/35<1,Total.Horas/35,1),
                  JC40.DIC=ifelse(Total.Horas>=40, 1,0),
                  JCDOC40=ifelse(Total.Horas>=40,ifelse(Cod..Nivel.Formación==1,1,0),0),
                  Contrato.más.relevante=ifelse(`N°.de.horas.con.contrato.de.Planta.(indefinido)`>0,"PLANTA", 
                                         ifelse(`N°.de.horas.con.contrato.a.Contrata.(Plazo.fijo)`>0,"A CONTRATA","HONORARIOS")),
                  dedicacion.horaria=ifelse(Total.Horas<22,"d1", 
                                     ifelse(Total.Horas<32,"d2",
                                     ifelse(Total.Horas<43,"d3","d4"))),
                  dedicacion.horaria.DESGLOSE=ifelse(Total.Horas<22,"Menos de 22 hrs.  ", 
                                              ifelse(Total.Horas<32,"Entre 22 y 32 hrs. ",
                                              ifelse(Total.Horas<43,"Entre 32 y 43 hrs.",
                                              ifelse(Total.Horas<=45,"Entre 44 y 45 hrs.", "Más de 45 hrs")))),
                  Dedicación.horaria.ACREDITACION=ifelse(Total.Horas<11, "d1",
                                                  ifelse(Total.Horas<23,"d2",
                                                  ifelse(Total.Horas<39,"d3","d4"))),
                  Dedicación.horaria.ACREDITACION.DESGLOSE=
                    ifelse(Total.Horas<11, "Menos de 11 hrs. ",
                    ifelse(Total.Horas<23,"Entre 11 y 23 hrs. ",
                    ifelse(Total.Horas<39,"Entre 23 y 39 hrs.","Mas de 39"))))%>% 
           relocate(Clave.Año, .before =1) %>%
           relocate(Rut=RUT, .after = 1) %>% 
           relocate(Año, .before =2)%>% 
           left_join(distinct(PAC_2008_2024[,c("Rut","Correo.Institucional")]), by ='Rut') %>% 
           left_join(tab_paises[,c("COD_PAIS", "NOMBRE.PAIS")], by=c('cod.nac' = 'COD_PAIS')) %>%
           left_join(tab_paises[,c("COD_PAIS", "NOMBRE.PAIS.OBT.TIT")], by=c('cod pais obt tit' = 'COD_PAIS')) %>% 
           left_join(tab_paises[,c("COD_PAIS", "NOMBRE.PAIS.OBT.ESP")], by=c('cod.pais.esp' = 'COD_PAIS')) %>% 
           left_join(CC[,c("CC.TEXT_REC", "CC...4", "CC.TEXT_REC")], by=c('Unidad_DESEMP' = 'CC.TEXT_REC')) %>% 
           left_join(CC_MAYOR[,c("UM.TEXT", "CC")], by=c('Unidad.Mayor_CONTRATO' = 'UM.TEXT')) %>% 
           left_join(CC[,c("CC.TEXT_REC", "CC.CONTRATO.MENOR")], by=c('Principal.Unidad.Académica_CONTRATO' = 'CC.TEXT_REC')) %>% 
           left_join(tab_anho_inst[,c("Rut", "anho_2025")], by = 'Rut') %>% 
           relocate(Cod_Unidad_DESEMP=CC...4, .after = 12) %>% 
           left_join(tab_ped[,c("CC.PED", "ped")], by = c('Cod_Unidad_DESEMP' = 'CC.PED')) %>% 
           left_join(tab_jerarquias[,c("Jeraquía_categoría", "Tipo.de.Jornada","Con_CatJer")], by = 'Jeraquía_categoría') %>% 
           left_join(tab_formacion[,c("cod", "Formación.CNED", "Tipo.formación", "Nivel.mayor.jerarquía.académica")], by = c('Cod..Nivel.Formación' = 'cod')) %>% 
           rename(Tipo.jornada=Tipo.de.Jornada) %>%
           rename(Depto.c..pedagogia_DESEMP=ped) %>% 
           rename(Número.de.años.en.la.institución=anho_2025) %>% 
           rename(Nacionalidad=NOMBRE.PAIS) %>% 
           #rename(CC_Umayor_DESEMP=CC...1) %>% 
           #rename(Unidad.Mayor_DESEMP=UM.TEXT) %>% 
           #rename(TIPO.FORMACIÓN=TIPO) %>% 
           rename(`JC.(40)`=JC40) %>% 
           rename(Fecha.de.nacimiento=FECHA.DE.NACIMIENTO) %>% 
           rename(`JCE(35)Times`=JCE.35.Times) %>% 
           rename(`JORNADA.ACREDITACIÓN.(CNA.CHILE)`=JORNADA.ACREDITACIÓN..CNA.CHILE.) %>% 
           rename(JC40=JC40.DIC) %>% 
           rename(`Depto.c/.pedagogia_DESEMP`=Depto.c..pedagogia_DESEMP) %>% 
           rename(FORMACIÓN.CNED=Formación.CNED) %>% 
           rename(País.donde.lo.obtuvo=NOMBRE.PAIS.OBT.TIT) %>% 
           rename(País.donde.obtuvo.la.especialidad=NOMBRE.PAIS.OBT.ESP) %>% 
           rename(ccc_CONTRATO=CC.CONTRATO.MENOR) %>% 
           rename(CC_Umayor_CONTRATO=CC))



# PAC_2025_REC<-
# PAC_2025_REC %>%
#   left_join(VIPO[,c("Clave.Año", "Clave.Año")], by = 'Clave.Año') %>%
#   mutate(ESTA.EN.POSTGRADO=ifelse(!is.na(Clave.Año.1),1,0))

# PAC_2025_REC<-
# PAC_2025_REC %>% 
#   left_join(VIPO[, "Clave.Año", drop = FALSE], by = "Clave.Año") %>% 
#   mutate(ESTA.EN.POSTGRADO = ifelse(!is.na(Clave.Año), 1, 0))

PAC_2025_REC$ESTA.EN.POSTGRADO<-PAC_2025_REC$Clave.Año %in% VIPO$Clave.Año



PAC_2025_REC<-
  PAC_2025_REC %>% 
  mutate(JC44=ifelse(Tipo.jornada=="Por Jornadas" & Total.Horas>=44,1,0),
         Número.de.años.en.la.institución=ifelse(is.na(Número.de.años.en.la.institución), 0, 
                                                 Número.de.años.en.la.institución),
         Nivel.de.formación.especialidad=ifelse(Nivel.de.formación.especialidad==0, NA, Nivel.de.formación.especialidad)) %>% 
  rename(Nivel.Formación=Nivel.mayor.jerarquía.académica) %>% 
  rename(TIPO.FORMACIÓN=Tipo.formación)


PAC_2025_REC$Nivel.Formación.CORR<-PAC_2025_REC$Nivel.Formación

PAC_2025_REC$Nivel.Formación.CORR<-
  chartr("ÁÉÍÓÚ", "AEIOU", PAC_2025_REC$Nivel.Formación.CORR)


PAC_2025_REC <- PAC_2025_REC %>%
  mutate(`NIVEL.FORMACIÓN.-.ESP.MED` = case_when(
    Nivel.Formación.CORR == "SIN TITULO NI GRADO" ~ "LICENCIA MEDIA",
    Nivel.Formación.CORR == "LICENCIADO" ~ "Licenciatura",
    Nivel.Formación.CORR == "TECNICO DE NIVEL SUPERIOR" ~ "TECNICO DE NIVEL SUPERIOR",
    Nivel.Formación.CORR == "MAGISTER" & especialidad == "Especialidad" ~ "MAGISTER",
    Nivel.Formación.CORR == "DOCTOR" & especialidad == "Especialidad" ~ "DOCTOR",
    Nivel.Formación.CORR == "TITULO PROFESIONAL" & especialidad == "Especialidad" ~ "Especialidad",
    Nivel.Formación.CORR == "TITULO PROFESIONAL" ~ "TITULO PROFESIONAL",
    TRUE ~ toupper(Nivel.Formación.CORR)
  ))



NROW(Reduce(setdiff, list(names(PAC_2008_2024),
                          names(PAC_2025_REC))))



Reduce(setdiff, list(names(PAC_2008_2024),names(PAC_2025_REC)))

PAC_2025_REC<-
  unique(PAC_2025_REC)


PAC_2008_2025<-
  Reduce(function(x, y) merge(x, y, all=T), list(PAC_2008_2024, 
                                                 PAC_2025_REC))


###espacio final
# PAC_2008_2023<-
# as.data.frame(apply(PAC_2008_2023, 2, function(x) gsub(" $","", x, perl=T)))

PAC_2008_2025<-
  PAC_2008_2025 %>%
  mutate(across(where(is.character), function(x) chartr("ÁÉÍÓÚ", "AEIOU", x)))


# PAC_2008_2023<-
#   PAC_2008_2023 %>%
#   mutate(across(where(is.character), function(x) chartr("áéíóú", "aeiou", x)))

PAC_2008_2025<-
  PAC_2008_2025 %>%
  mutate(across(where(is.character), function(x) gsub(" $","", x, perl=T)))


PAC_2008_2025<-
  PAC_2008_2025 %>% 
  mutate(Edad_año=as.numeric(Edad_año),
         `N°.de.horas.con.contrato.a.Contrata.(Plazo.fijo)`=as.numeric(`N°.de.horas.con.contrato.a.Contrata.(Plazo.fijo)`),
         `N°.de.horas.con.contrato.a.Honorarios`=as.numeric(`N°.de.horas.con.contrato.a.Honorarios`),
         `N°.de.horas.con.contrato.de.Planta.(indefinido)`=as.numeric(`N°.de.horas.con.contrato.de.Planta.(indefinido)`))

#PAC_2023$`Total.Horas.contratadas.para.funciones.académicas.(no.llenar)`<-PAC_2023$Total.Horas

# PAC_2008_2023<-
# PAC_2008_2023 %>%
#   mutate(prueba_campo=
#            ifelse(Año=="2022" | Año=="2023", 
#                   `Total.Horas.contratadas.para.funciones.académicas.(no.llenar)`<-Total.Horas,
#                   `Total.Horas.contratadas.para.funciones.académicas.(no.llenar)`))



PAC_2008_2025<-
  arrange(PAC_2008_2025, desc(Año))


# PAC_2008_2023 %>%
#        mutate(prueba_campo =
#                 ifelse(Año %in% c("2022", "2023"), Total.Horas, 
#                        `Total.Horas.contratadas.para.funciones.académicas.(no.llenar)`))

PAC_2008_2025$`Total.Horas.contratadas.para.funciones.académicas.(no.llenar)`<-
  with(PAC_2008_2025, ifelse(Año %in% c("2022", "2023", "2024"), Total.Horas, 
                             `Total.Horas.contratadas.para.funciones.académicas.(no.llenar)`))

unique(PAC_2025_REC$Unidad.Mayor_CONTRATO[is.na(PAC_2025_REC$CC_Umayor_CONTRATO)])


PAC_2008_2025<-
  PAC_2008_2025[,1:NROW(Reduce(intersect, list(names(PAC_2008_2024),
                                               names(PAC_2025_REC))))]



tab_fecha_nac<-
  unique(PAC_2008_2025[,c(3,9)])

tab_fecha_nac %>% 
  group_by(Rut, Fecha.de.nacimiento) %>% 
  summarise(n=n()) %>% 
  arrange(-n)


tab_fecha_nac %>%
  add_count(Rut) %>%
  dplyr:: filter(n > 1) %>%
  arrange(Rut)

PAC_2008_2025<-
clean_names(PAC_2008_2025)

# PAC_2008_2025<-
# PAC_2008_2025 %>% left_join(VIPO_CONS[,c("Clave.Año", "Clave.Año")], 
#                             by=c("clave_ano"="Clave.Año")) %>% 
#   mutate(ESTA.EN.POSTGRADO_2=ifelse(!is.na(Clave.Año),1,0))
# 
# PAC_2008_2025<-
# PAC_2008_2025 %>%left_join(VIPO_CONS %>% select(Clave.Año, RUT), by = c("clave_ano" = "Clave.Año")) %>%
#   mutate(esta_en_postgrado = ifelse(!is.na(esta_en_postgrado), esta_en_postgrado,
#                                     ifelse(!is.na(RUT), 1, 0)))

library(googledrive)
library(googlesheets4)

sheet_id <- "1NpUYt-BrNSkli5YL9JTQz9WdeL0WtGbjytKDrQh114M"  # tu ID de Google Sheets

# Escribe el data frame completo en la hoja "Nueva_Hoja"
#sheet_write(data = PAC_2025_REC, ss = sheet_id, sheet = "PAC_2025_CAMPOS_CALC")
sheet_write(data = PAC_2008_2025[PAC_2008_2025$ano==2025,], ss = sheet_id, sheet = "PAC_2025_CAMPOS_CALC_v2")
