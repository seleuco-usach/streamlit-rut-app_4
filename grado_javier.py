#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 21 16:32:35 2025

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
cursor_1.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';")


for t in cursor_1.fetchall():
    print(t)
    
####listado de campos

cursor_1 = con_1.cursor()
columnas=cursor_1.execute("SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='MATRICULA';")

for c in columnas.fetchall():
    print(c)


pac_2025=pd.read_sql("""SELECT *
            FROM PAC_2008_2025
            WHERE ano=2025""", con_1)
            
spreadsheet = client.open_by_key('1FtM7XlFYUDkxCw-eD94hHv8xAmUX9MIHX8y8Azx813U')

worksheet = spreadsheet.get_worksheet(0)
data = worksheet.get_all_values()
worksheet1 = spreadsheet.get_worksheet(1)   # índice 0 es la primera hoja
data1 = worksheet1.get_all_values()

ACADEMICOS_MENOR_GRADO=pd.DataFrame(data[1:], columns=data[0])
ACADEMICOS_MAYOR_GRADO=pd.DataFrame(data1[1:], columns=data1[0])

dfs = [ACADEMICOS_MAYOR_GRADO, ACADEMICOS_MENOR_GRADO]

from functools import reduce
grado_javier=reduce(lambda left, right: pd.merge(left, right, how='outer'), dfs)

grado_javier['RUT']=grado_javier['RUT'].astype(float)

(
grado_javier['GRADO INFORMADO EN CERTIFICADO']
.str.contains("master|magister|magíster", case = False, na=False)
)



grado_javier['grado_certificado']=np.where(grado_javier['GRADO INFORMADO EN CERTIFICADO']
.str.contains("master|magister|magíster|mba|máster|mestre", 
              case = False, na=False), "magister", 
np.where(grado_javier['GRADO INFORMADO EN CERTIFICADO']
.str.contains("doctor|doctora|doctoris|doctorado|doctorat|Doutora|Doutor", 
              case = False, na=False), "doctor", 
np.where(grado_javier['GRADO INFORMADO EN CERTIFICADO']
.str.contains("licenciado|licenciada|Lizentiatin", 
              case = False, na=False), "licenciatura", 
np.where(grado_javier['GRADO INFORMADO EN CERTIFICADO']
.str.contains("especialista|especialidad|subespecialidad|especializacion", 
              case = False, na=False), "eemm", "profesional"))))


#grado_javier['grado_certificado'].value_counts()


pac_2025_grado_javier=pac_2025[['rut', 
          'apellido_paterno', 
          'apellido_materno',
          'nombres',
          'nivel_formacion_corr',
          'cod_nivel_formacion_corr']]  .merge(grado_javier[['ARCHIVO','RUT',
                                                       'GRADO REPORTADO A SIES',
                                                       'GRADO INFORMADO EN CERTIFICADO', 
                                                       'comentarios',
                                                       'grado_certificado']], 
                                                           left_on="rut", right_on="RUT", how="inner")

from gspread_dataframe import set_with_dataframe

set_with_dataframe(spreadsheet.add_worksheet(title="pac_2025_3", rows="4000", cols="90"), 
                   pac_2025_grado_javier)