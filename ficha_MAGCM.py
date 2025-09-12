
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


inscripcion_2025=pd.read_sql("""SELECT 
            RUT_ESTUDIANTE,
            COD_PLAN,
            PERIODO,
            ASIGNATURA,
            COD_ASIG
            FROM INSCRIPCION_2025
            WHERE COD_PLAN=9224""", con_1).drop_duplicates()



import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
from gspread_dataframe import set_with_dataframe

# Configurar el alcance y credenciales
scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
client = gspread.authorize(credentials)


credentials = ServiceAccountCredentials.\
from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)


spreadsheet = client.open_by_key('1Cug89XL65vKHc5hBlgBXlQmq9ksMJfo3yDahAINJRBI')

set_with_dataframe(spreadsheet.add_worksheet(title="planeacion-inscripcion", rows=1000, cols= 10), 
                   inscripcion_2025)