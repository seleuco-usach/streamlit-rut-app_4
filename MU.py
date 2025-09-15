#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 18 10:27:34 2025

@author: xenomorfo
"""

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
    
pd.read_sql("""SELECT
            ANHO_MU,
            NIV_GLO,
            COUNT(N_DOC) AS TOT
            FROM TABLA_MU
            WHERE VIG=1 AND UNICIT='NO UNICIT' AND ANHO_MU>2017
            GROUP BY 
            ANHO_MU,
            NIV_GLO""", con_1)


MU=pd.read_sql("""SELECT
            N_DOC,
            COD_SIES,
            ANHO_MU,
            NIV_GLO,
            primer_anio
            FROM TABLA_MU
            WHERE VIG=1 AND 
            UNICIT='NO UNICIT' AND 
            ANHO_MU>2020 AND 
            NIV_GLO<>'POSTITULO'""", con_1)
            
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
from gspread_dataframe import set_with_dataframe

# Configurar el alcance y credenciales
scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
client = gspread.authorize(credentials)
#jose-hoyos-usach-cl@bamboo-sweep-465617-i4.iam.gserviceaccount.com 
# Abrir la hoja de cálculo por ID
spreadsheet = client.open_by_key('1paFv1Dn2mcRubtCgVHL1xPmLPN9T9bvZr4JGVGqByaU')
credentials = ServiceAccountCredentials.\
from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
# Abrir la hoja de cálculo por ID



set_with_dataframe(spreadsheet.add_worksheet(title="TABLA_MU_2", rows=130000, cols= 20), MU)
