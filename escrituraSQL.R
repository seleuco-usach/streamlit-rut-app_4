##revisa el espacio por tablas
library(DBI)
library(odbc)
ifelse(dbExistsTable(con_3, "titulados_coh_5"),1,0)

con_3 <- dbConnect(odbc(),
                   Driver = "ODBC Driver 17 for SQL Server",
                   Server = "158.170.66.56",
                   encoding = "Latin1",
                   Database = "PROC01ESTUDIO",
                   UID = "proceso",
                   PWD = "Estudio.2024",
                   Port = 1433)

# Inserta los datos

###TABLA MAT UNIFICADA###
mi_tabla<-
  MU_CONS[,1:4]

dbWriteTable(con_3, "TABLA_MU", MU_CONS, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "RA_CONSOLIDADA", RA_CONSOLIDADA, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "TITULADOS_rev", tit_op_ex, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "TITULADOS_V_10", titulados_coh_3, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "DEMRE_E_2014_2025", DEMRE_E_CONSOLIDADA, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "MU_SIES", fread("usach20122023pregrado_202409121610.csv"), append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "CPP_DR", CPP_DR, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "ADMINISTRATIVOS_2021_2024", adm_2021_2024, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "PAC_2008_2025", PAC_2008_2025, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "tab_paises", tab_paises, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "VRYFIL", VRYFIL_2, append = TRUE, row.names = FALSE)
dbWriteTable(con_3, "INSCRIPCION_2025", inscripcion, append = TRUE, row.names = FALSE)



DBI::dbExecute(con_3, "INSERT INTO Mitabla ( columna1, columna2) 
               values ('nicole', 0)")

DBI::dbRemoveTable(con_3, "ADMINISTRATIVOS_2022_2024")

DBI::dbRemoveTable(con_3, "centro_costo")
