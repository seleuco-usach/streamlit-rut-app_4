#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 29 16:11:05 2025

@author: xenomorfo
"""
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
from gspread_dataframe import set_with_dataframe

import pyodbc
import pandas as pd
import numpy as np
from datetime import date

con_1 = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER=158.170.66.56,{1433};"
    f"DATABASE=PROC01ESTUDIO;"
    f"UID=proceso;"
    f"PWD=Estudio.2024;")

print("Conexión exitosa")

####listado de tablas
cursor_1 = con_1.cursor()
cursor_1.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.\
                 TABLES WHERE TABLE_TYPE = 'BASE TABLE';")


for t in cursor_1.fetchall():
    print(t)
    
####listado de campos

cursor_1 = con_1.cursor()
columnas=cursor_1.execute("SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.\
                          COLUMNS WHERE TABLE_NAME='TABLA_MU';")
                          
for c in columnas.fetchall():
    print(c)


MU_2025=pd.read_sql("""SELECT
            m.ANHO_MU,
            m.SEXO,
            m.VIG,
            m.UNICIT,
            m.NIV_GLO,
            m.nombre_carrera,
            m.COD_SIES,
            m.primer_anio,
            COUNT(N_DOC) AS Tot
            FROM TABLA_MU m
            WHERE ANHO_MU='2025' AND VIG=1 AND UNICIT='NO UNICIT'
            GROUP BY
            m.ANHO_MU,
            m.SEXO,
            m.VIG,
            m.UNICIT,
            m.NIV_GLO,
            m.nombre_carrera,
            m.COD_SIES,
            m.primer_anio""", con_1)

MAT[MAT['CODIGO_CARRERA']=="BACHI"]\
    .groupby(['CODIGO_CARRERA', 
              'NIVEL_GLOBAL',
              'ANHO_MAT'])['rut']\
        .nunique()\
        .reset_index()

#tabla_scienceup=pd.DataFrame(tabla_scienceup)


scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
client = gspread.authorize(credentials)
scienceup = client.open_by_key('1n6sqm0afvkmW3DP5Z1eM2Kjur8msew4qXdDwos0iWsM')


#scienceup.del_worksheet(scienceup.worksheet("matricula"))

hoja=scienceup.add_worksheet(rows= "1000", cols="20",title="matricula3")

hoja.clear()


set_with_dataframe(hoja, MU_2025)

tabla_titulados=titulados_coh.groupby(['ANHO', 
                       'SEXO',
                       'ANHO_TIT',
                       'CODIGO_PROGRAMA_SIES',
                       'PLAN',
                       'NIVEL_TIT_GRADO',
                       'oportuno',
                       'exacto',
                       ])['RUT']\
    .nunique()\
    .reset_index()
    
hoja=scienceup.add_worksheet(rows= "1000", cols="20",title="titulados")
set_with_dataframe(hoja, tabla_titulados)
