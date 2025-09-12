library(googledrive)
library(googlesheets4)
library(dplyr)

####vrifyl
DERECHO<-
googlesheets4::read_sheet(
  "https://docs.google.com/spreadsheets/d/1tdHEVMxxTFR5Q8ft1VVPuHqc-28TGzMQsJqYInzuOY8/edit?usp=sharing",
  sheet = "DERECHO",
  col_types = paste(rep("c", 32), collapse = "")
)

names(DERECHO)<-
toupper(names(DERECHO))

names(DERECHO)<-
chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(DERECHO))

DERECHO<-
DERECHO %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "DERECHO", "OTRO"))

DERECHO %>% View()

FQYB<-
googlesheets4::read_sheet(
  "https://docs.google.com/spreadsheets/d/1TdgyA3VBbiNL14RO4pSJzgBBK0xvT66WIiKxY20j2Lk/edit?usp=sharing",
  sheet = "FQYB",
  col_types = paste(rep("c", 31), collapse = "")
)

FQYB<-
  FQYB %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "FQYB", "OTRO"))

names(FQYB)<-
  toupper(names(FQYB))

names(FQYB)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(FQYB))

FAHU<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1ovb4llQkTAHeyy_FxksjRJ0qc4KJsfEnavZqVmN7a38/edit?usp=sharing",
    sheet = "FAHU",
    col_types = paste(rep("c", 31), collapse = "")
  )

names(FAHU)<-
  toupper(names(FAHU))

names(FAHU)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(FAHU))

FAHU<-
  FAHU %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "FAHU", "OTRO"))


TECNO<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1KcEbq0k1ES8D9YeAfHn1hKBS2GC5YIdNtybOsqqA8eQ/edit?usp=sharing",
    sheet = "TECNO",
    col_types = paste(rep("c", 31), collapse = "")
  )

names(TECNO)<-
  toupper(names(TECNO))

names(TECNO)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(TECNO))

TECNO<-
  TECNO %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "TECNO", "OTRO"))


FARAC<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1RaEgpreewmZMe8khBWHTmP3BwXNw-toDK9UE0hsPl90/edit?usp=sharing",
    sheet = "FARAC",
    col_types = paste(rep("c", 31), collapse = "")
  )

names(FARAC)<-
  toupper(names(FARAC))

names(FARAC)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(FARAC))

FARAC<-
  FARAC %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "FARAC", "OTRO"))


FCIENCIA<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1ouBLOyoJstxBx_qfm0z4i9UbQxstclik0sjqaY_FE-Y/edit?usp=sharing",
    sheet = "FCIENCIA",
    col_types = paste(rep("c", 35), collapse = "")
  )

names(FCIENCIA)<-
  toupper(names(FCIENCIA))

names(FCIENCIA)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(FCIENCIA))

FCIENCIA<-
  FCIENCIA %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "FCIENCIA", "OTRO"))


FACIMED<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1DpDnayuaWOsLEIf7Ep1rnckIWt0sDFBrmGuzWMb-boA/edit?usp=sharing",
    sheet = "FACIMED",
    col_types = paste(rep("c", 32), collapse = "")
  )

names(FACIMED)<-
  toupper(names(FACIMED))

names(FACIMED)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(FACIMED))

FACIMED<-
  FACIMED %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "FACIMED", "OTRO"))


OBP<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1Lt-Ip4vuhmO96XY4mOJqlNqSv7mZFCmj_qotRl9Ad9Y/edit?usp=sharing",
    sheet = "OBP",
    col_types = paste(rep("c", 32), collapse = "")
  )

names(OBP)<-
  toupper(names(OBP))

names(OBP)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(OBP))

OBP<-
  OBP %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "OBP", "OTRO"))


KINE<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1pbhcSjSrm7QsnBuMq4hcvfkw_Or1WvQdrh1_UnWElkU/edit?usp=sharing",
    sheet = "KINE",
    col_types = paste(rep("c", 32), collapse = "")
  )

names(KINE)<-
  toupper(names(KINE))

names(KINE)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(KINE))

KINE<-
  KINE %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "KINE", "OTRO"))


IDEA<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1e7RZeoEpSouf89vqdxiVPU2ELBau4rvf83B8YWdr5fQ/edit?usp=sharing",
    sheet = "IDEA",
    col_types = paste(rep("c", 31), collapse = "")
  )

names(IDEA)<-
  toupper(names(IDEA))

names(IDEA)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(IDEA))

FAE<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/1R63MPomIp5g-QIoMGcuonSmpYQz0676uxvxMdvwie4o/edit?usp=sharing",
    sheet = "FAE",
    col_types = paste(rep("c", 31), collapse = "")
  )

names(FAE)<-
  toupper(names(FAE))

names(FAE)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(FAE))

FAE<-
  FAE %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "FAE", "OTRO"))


FING<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/12K9ggGq7aXwL66-JJKtg7K18ctkfT1sfkoV9nIbdraw/edit?usp=sharing",
    sheet = "FING",
    col_types = paste(rep("c", 34), collapse = "")
  )
names(FING)<-
  toupper(names(FING))

names(FING)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(FING))

FING<-
  FING %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "FING", "OTRO"))


FING_2<-
  googlesheets4::read_sheet(
    "https://docs.google.com/spreadsheets/d/12K9ggGq7aXwL66-JJKtg7K18ctkfT1sfkoV9nIbdraw/edit?usp=sharing",
    sheet = "FALTANTES",
    col_types = paste(rep("c", 31), collapse = "")
  )

names(FING_2)<-
  toupper(names(FING_2))

names(FING_2)<-
  chartr("ÁÉÍÓÚÜÑ","AEIOUUN", names(FING_2))

FING_2<-
  FING_2 %>% mutate(ORIGEN=ifelse(`RANGO[NUM_DOCUMENTO]`!=0, "FING_2", "OTRO"))


# HONORARIOS<-
#   googlesheets4::read_sheet(
#     "https://docs.google.com/spreadsheets/d/16pKc0c6W7s1XgTFzpoXbiimvlErotlZpcH5hKab73Xs/edit?gid=0#gid=0",
#     sheet = "HONORARIOS", skip = 1,
#     col_types = paste(rep("c", 39), collapse = "")
#   )


NROW(Reduce(intersect, list(names(DERECHO),
                            names(FQYB),
                            names(FAHU),
                            names(TECNO),
                            names(FARAC),
                            names(FCIENCIA),
                            names(FACIMED),
                            names(IDEA),
                            names(FAE),
                            names(FING),
                            names(FING_2),
                            names(OBP),
                            names(KINE))))

VRYFIL_2<-
Reduce(function(x, y) merge(x, y, all=TRUE), list(DERECHO,
                                                  FQYB,
                                                  FAHU,
                                                  TECNO,
                                                  FARAC,
                                                  FCIENCIA,
                                                  FACIMED,
                                                  IDEA,
                                                  FAE,
                                                  FING,
                                                  FING_2,
                                                  KINE,
                                                  OBP))

VRYFIL_2<-
VRYFIL_2 %>% 
  mutate(across(where(is.character),
                ~toupper(.)),
    across(where(is.character),
                ~chartr("ÁÉÍÓÚÜÑ","AEIOUUN",.)),
         across(where(is.character), 
                ~gsub(",|[()]|&|-", "", .)),
         across(where(is.character), ~gsub("\\s+", " ", trimws(.))))


install.packages("janitor")
library(janitor)
VRYFIL_2<-
clean_names(VRYFIL_2)

VRYFIL$`RANGO[FECHA_OBT_TIT_O_GRADO]`<-as.Date(VRYFIL$`RANGO[FECHA_OBT_TIT_O_GRADO]`,format = "%d-%m-%y")

tab_paises$NOMBRE.PAIS<-
chartr("ÁÉÍÓÚÜÑ","AEIOUUN",tab_paises$NOMBRE.PAIS)

tab_paises$NOMBRE.PAIS<-
trimws(tab_paises$NOMBRE.PAIS)



sheet_id <- "17QyYfIt0ZxJFOLyDeTFCYmpYAJA83qmxKaRr70OjDuw"  # tu ID de Google Sheets

# Escribe el data frame completo en la hoja "Nueva_Hoja"
sheet_write(data = VRYFIL, ss = sheet_id, sheet = "VRYFIL_4")



VRYFIL_2%>% select(
    ORIGEN, 
    'RANGO[NUM_DOCUMENTO]',
    'NUEVO GRADO\n[AL 31/05 DE 2025]',
    'ADJUNTA_CERTIFICADO\n[LINK REPOSITORIO U OTRO CANAL DE EVIDENCIA]')

VRYFIL_2%>% is.na('NUEVO GRADO\n[AL 31/05 DE 2025]')

VRYFIL_2