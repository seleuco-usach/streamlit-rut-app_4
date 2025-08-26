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


pd.read_sql("""SELECT *
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