library(dplyr)
library(openxlsx)


con_3 <- dbConnect(odbc(),
                   Driver = "ODBC Driver 17 for SQL Server",
                   Server = "158.170.66.56",
                   encoding = "Latin1",
                   Database = "PROC01ESTUDIO",
                   UID = "proceso",
                   PWD = "Estudio.2024",
                   Port = 1433)

adm_2022_2024<-
tbl(con_3, "ADMINISTRATIVOS_2022_2024") %>% select(everything()) %>% collect()

adm_2021<-
read.xlsx("/home/xenomorfo/Descargas/2021_ADMINISTRATIVOS_CONSOLIDADO.xlsx")



NROW(Reduce(intersect, list(names(adm_2022_2024),
                       names(adm_2021))))

Reduce(intersect, list(names(adm_2022_2024),
                            names(adm_2021)))

adm_2021_2024<-
Reduce(function(x, y) merge(x, y, all=TRUE), list(adm_2022_2024,
                                                  adm_2021))

