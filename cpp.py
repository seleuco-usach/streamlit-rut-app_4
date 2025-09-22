

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
                          COLUMNS WHERE TABLE_NAME='cpp_cc';")

for c in columnas.fetchall():
    print(c)
    

pd.read_sql("""SELECT * FROM cpp_cc""", con_1).to_csv("cpp_cc.csv", index=False)

pd.read_sql("""SELECT * FROM CPP_DR""", con_1).to_csv("CPP_DR.csv", index=False)

pd.read_sql("""SELECT * FROM PAC_2008_2025""", con_1).to_csv("PAC_2008_2025.csv", index=False)