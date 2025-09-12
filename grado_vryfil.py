
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
                          COLUMNS WHERE TABLE_NAME='VRYFIL';")

for c in columnas.fetchall():
    print(c)


grado_vryfil=pd.read_sql("""SELECT
            "RANGO[NUM_DOCUMENTO]" as rut,
            "NUEVO GRADO\n[AL 31/05 DE 2025]" as nuevo_grado,
            "ADJUNTA_CERTIFICADO\n[LINK REPOSITORIO U OTRO CANAL DE EVIDENCIA]" as evidencia
            FROM VRYFIL
            """, con_1)

grado_vryfil['grado']=np.where(grado_vryfil['nuevo_grado']
.str.contains("master|magister|magíster|mba|máster|mestre", 
              case = False, na=False), "magister", 
np.where(grado_vryfil['nuevo_grado']
.str.contains("doctor|doctora|doctoris|doctorado|doctorat|Doutora|Doutor|Dr.", 
              case = False, na=False), "doctor", 
np.where(grado_vryfil['nuevo_grado']
.str.contains("licenciado|licenciada|Lizentiatin", 
              case = False, na=False), "licenciatura", 
 np.where(grado_vryfil['nuevo_grado']
.str.contains("especialista|especialidad|subespecialidad|especializacion", 
              case = False, na=False), "eemm",
np.where(grado_vryfil['nuevo_grado']
.str.contains("no|''", 
              case = False, na=False), "s/i","profesional")))))




