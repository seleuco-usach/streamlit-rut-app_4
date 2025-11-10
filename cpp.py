

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





####listado de tablas
cursor_1 = con_1.cursor()
cursor_1.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.\
                 TABLES WHERE TABLE_TYPE = 'BASE TABLE';")


for t in cursor_1.fetchall():
    print(t)


# Cadena de conexión compatible con SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy import create_engine, text

server = "158.170.66.56,1433"
database = "PROC01ESTUDIO"
username = "proceso"
password = "Estudio.2024"

connection_string = (
    f"mssql+pyodbc://{username}:{password}@{server}/{database}"
    "?driver=ODBC+Driver+17+for+SQL+Server"
)

engine = create_engine(connection_string)
with engine.connect() as conn:
    result = conn.execute(text("""
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_TYPE = 'BASE TABLE';"""))
    
    for t in result:
        print(t)

print("Conexión exitosa")

    
####listado de campos

cursor_1 = con_1.cursor()
columnas=cursor_1.execute("SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.\
                          COLUMNS WHERE TABLE_NAME='PAC_2008_2025';")

for c in columnas.fetchall():
    print(c)
    

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
#https://docs.google.com/spreadsheets/d/17LhWP9zmDMxmyqkmlB-PTc8kf7_p6LcFHdCGAhEvi9E/edit?gid=1818427118#gid=1818427118
# Abrir la hoja de cálculo por ID
spreadsheet = client.open_by_key('17LhWP9zmDMxmyqkmlB-PTc8kf7_p6LcFHdCGAhEvi9E')
credentials = ServiceAccountCredentials.\
from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
# Abrir la hoja de cálculo por ID


CPP_DR = (
gspread.authorize(credentials)
.open_by_key('17LhWP9zmDMxmyqkmlB-PTc8kf7_p6LcFHdCGAhEvi9E')
.get_worksheet(0)
.get_all_values()
# índice 0 es la primera hoja
)

CPP_DR = pd.DataFrame(CPP_DR[1:], columns=CPP_DR[0])



# Cadena de conexión compatible con SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy import create_engine, text
connection_string = (
    f"mssql+pyodbc://{username}:{password}@{server}/{database}"
    "?driver=ODBC+Driver+17+for+SQL+Server"
)

engine = create_engine(connection_string)
with engine.begin() as conn:
    result = conn.execute(text("""
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_TYPE = 'BASE TABLE';"""))
    
    for t in result:
        print(t)
        
    CPP_DR.to_sql("CPP_DR2", conn, if_exists='replace', index=False)



pd.read_sql("""SELECT * FROM CPP_DR2""", con_1)

(
pd.read_sql("""SELECT * FROM PAC_2008_2025
            WHERE ano = 2024""", con_1)
.to_csv("PAC_2024.csv", 
        index=False, 
        sep=';', 
        decimal=',', 
        encoding='utf-8')
)

pd.read_sql("""SELECT *
            FROM PAC_2008_2025""", con_1)


pd.read_sql("""SELECT * FROM cpp_cc""", con_1).to_csv("cpp_cc.csv", index=False)

pd.read_sql("""SELECT * FROM CPP_DR""", con_1).to_csv("CPP_DR.csv", index=False)

pd.read_sql("""SELECT * FROM CPP_DR""", con_1)