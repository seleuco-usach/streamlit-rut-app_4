
import pyodbc
import pandas as pd
import numpy as np


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
                          COLUMNS WHERE TABLE_NAME='DEMRE_E_2014_2025';")

                          
for c in columnas.fetchall():
    print(c)


DEMRE=pd.read_sql("""SELECT
            NUMERO_DOCUMENTO,
            DV,
            ANYO_PROCESO,
            PATERNO,
            MATERNO,	
            NOMBRES,	
            NACIONALIDAD,
            SEXO,
            PREFERENCIA,
            CODIGO,	
            RAMA_EDUCACIONAL,
            GRUPO_DEPENDENCIA,
            CODIGO_REGION,
            ESTADO_DE_LA_POSTULACION
            FROM DEMRE_E_2014_2025""", con_1)




def buscar_rut(DEMRE):
    rut_buscado = int(input("Ingresa rut: "))
    if rut_buscado in DEMRE['NUMERO_DOCUMENTO'].values:
        print(DEMRE.loc[DEMRE['NUMERO_DOCUMENTO'] == rut_buscado, [
            'NUMERO_DOCUMENTO',
            'DV',
            'ANYO_PROCESO',
            'PATERNO',
            'MATERNO',	
            'NOMBRES',	
            'NACIONALIDAD',
            'SEXO',
            'PREFERENCIA',
            'CODIGO',	
            'RAMA_EDUCACIONAL',
            'GRUPO_DEPENDENCIA',
            'CODIGO_REGION',
            'ESTADO_DE_LA_POSTULACION'
        ]])
    else:
        print("no encontrado")

# Luego llama:
buscar_rut(DEMRE)