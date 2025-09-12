#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 17 10:10:13 2025

@author: xenomorfo
"""

import pyodbc
import pandas as pd
import numpy as np


con_1 = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER=158.170.66.56,{1433};"
    f"DATABASE=PROC01ESTUDIO;"
    f"UID=proceso;"
    f"PWD=Estudio.2024;")

con_2 = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER=158.170.66.56,{1433};"
    f"DATABASE=TABLAS_ESTUDIO;"
    f"UID=base_estudio;"
    f"PWD=Estudio.T4b145;")

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
                          COLUMNS WHERE TABLE_NAME='COHORTE_AL_20240502';")

                          
for c in columnas.fetchall():
    print(c)

                    
titulados_coh=pd.read_sql("""SELECT
          c.RUT ,
          c.ANHO,
          c.SEXO,
          c.COD_PLAN,
          c.[PLAN],
          c.CODIGO_PROGRAMA_SIES,
          c.DURACION_TOTAL,
          c.NOMBRE_CARRERA_PROGRAMA_SIES,
          c.CODIGO_CARRERA,
          c.VIA_INGRESO,
          c.COD_VIA_INGRESO,
          c.INGRESO,
          UPPER(t.NIVEL_TIT_GRADO) AS NIVEL_TIT_GRADO,
          t.ANHO_ACADEMICO,
          t.FECHA_RESOL,
          t.FECHA_TITULO,
          t.NOMBRE_TIT_GRADO,
          t.rut_cod_plan,
          LEFT(t.FECHA_TITULO, 4) AS ANHO_TIT,
          LEFT(t.FECHA_RESOL, 4) AS ANHO_RES,             
          RIGHT(c.INGRESO,2) AS Periodo_Ing,
          COUNT(DISTINCT c.RUT) AS frec,
          CONCAT(c.RUT, '-', c.COD_PLAN) AS id,
          CONCAT(c.ANHO, '-', c.COD_PLAN) AS id_2,
          CONCAT(c.RUT, c.CODIGO_CARRERA) AS  RUT_COD_CAR,
          CONCAT(c.ANHO, c.COD_PLAN),
          CONCAT(t.RUT, t.CODIGO_CARRERA) AS RUT_COD_CAR_TIT
          FROM COHORTE_AL_20240502 c
          FULL JOIN TITULADOS t
          ON CONCAT(c.RUT, c.CODIGO_CARRERA)=rut_cod_plan
          WHERE COHORTE_FORM_B = 1
          GROUP BY
          c.RUT,
          c.ANHO,
          c.SEXO,
          c.COD_PLAN,
          c.[PLAN],
          c.CODIGO_PROGRAMA_SIES,
          c.DURACION_TOTAL,
          c.NOMBRE_CARRERA_PROGRAMA_SIES,
          c.CODIGO_CARRERA,
          c.VIA_INGRESO,
          c.COD_VIA_INGRESO,
          c.INGRESO,
          t.NIVEL_TIT_GRADO,
          t.ANHO_ACADEMICO,
          t.FECHA_RESOL,
          t.FECHA_TITULO,
          t.NOMBRE_TIT_GRADO,
          t.rut_cod_plan,
          LEFT(t.FECHA_TITULO, 4),
          CONCAT(c.RUT, '-', c.COD_PLAN),
          CONCAT(c.ANHO, '-', c.COD_PLAN),
          CONCAT(c.RUT, '-', c.CODIGO_CARRERA),
          CONCAT(t.RUT, t.CODIGO_CARRERA)
            """, con_1)



###NIVEL GLOBAL
titulados_coh['NIVEL_GLOBAL']=np.where(titulados_coh['CODIGO_CARRERA']=="UNICIT", "UNICIT",
    np.where(titulados_coh['CODIGO_CARRERA']=="MIDA", "MAGISTER",
    np.where(titulados_coh['CODIGO_CARRERA'].str[0:3]=="MAG","MAGISTER", 
    np.where(titulados_coh['CODIGO_CARRERA'].str[0:3]=="DOC","DOCTORADO",
    np.where(titulados_coh['CODIGO_CARRERA'].str[0:3]=="DIP","DIPLOMADO",
    np.where(titulados_coh['CODIGO_CARRERA'].str[0:3]=="POS","POSTITUTLO","PREGRADO"))))))
titulados_coh['NIVEL_GLOBAL_2']=np.where(titulados_coh['NOMBRE_TIT_GRADO']\
                                         .str.contains("DIPLOMADO", na=False) & 
         (titulados_coh['NIVEL_GLOBAL']=="PREGRADO"),1,titulados_coh['NIVEL_GLOBAL'])


titulados_coh['ANHO_INI']=np.where(titulados_coh['Periodo_Ing'] == "01",  
                                   titulados_coh['ANHO'].astype(str) +"-01-01",
                                   titulados_coh['ANHO'].astype(str)+ "-08-08")


titulados_coh['ANHO_INI']=pd.to_datetime(titulados_coh['ANHO_INI'], 
                                         format='%Y-%m-%d')
titulados_coh['FECHA_TITULO']=pd.to_datetime(titulados_coh['FECHA_TITULO'], 
                                             format='%Y-%m-%d')



#titulados_coh['Duracion_semestres']=((titulados_coh['FECHA_TITULO'] - 
#                                      titulados_coh['ANHO_INI']).dt.days/30)/6

####Calculo 2
titulados_coh['Duracion_semestres'] = (round((titulados_coh['FECHA_TITULO'] - 
                                              titulados_coh['ANHO_INI']).dt.days,0)/30.4)/6

titulados_coh['titulado']=np.where(titulados_coh['NIVEL_TIT_GRADO']=="TERMINAL", 1,0)


titulados_coh['NIVEL_TIT_GRADO'].value_counts()


titulados_coh=titulados_coh.fillna(999)


titulados_coh['NIVEL_TIT_GRADO']=titulados_coh['NIVEL_TIT_GRADO'].fillna("999")

titulados_coh['exacto']=np.where((titulados_coh['NIVEL_TIT_GRADO']=="TERMINAL") & 
                                 ((titulados_coh['Duracion_semestres'] - 
                                  titulados_coh['DURACION_TOTAL']).fillna(999)<=0),1,0)

titulados_coh['oportuno']=np.where((titulados_coh['NIVEL_TIT_GRADO']=="TERMINAL") & 
                                   ((titulados_coh['Duracion_semestres'] - 
                                    titulados_coh['DURACION_TOTAL']).fillna(999)<=2),1,0)




titulados_coh['titulado'].value_counts()
titulados_coh['exacto'].value_counts()
titulados_coh['oportuno'].value_counts()
titulados_coh['NIVEL_TIT_GRADO'].value_counts()

titulados_coh.groupby(['NIVEL_TIT_GRADO', 'NIVEL_GLOBAL_2']).size()

titulados_coh['DURACION_TOTAL']
titulados_coh['Duracion_semestres']

rut_buscado=input("Ingresa rut:")


###busqueda rut
if rut_buscado in titulados_coh['RUT'].values:
    print(titulados_coh.loc[titulados_coh['RUT']==rut_buscado, 
                              ['RUT', 'ANHO', 
                               'ANHO_TIT', 
                               'NIVEL_TIT_GRADO', 
                               'CODIGO_CARRERA', 
                               'RUT_COD_CAR', 
                               'Duracion_semestres',
                               'DURACION_TOTAL',
                               'exacto',
                               'oportuno',
                               'FECHA_TITULO',
                               'ANHO_INI']])
else: print("no encontrado")


pd.set_option('display.max_columns', None) 
pd.set_option('display.width', None)  

# titulados_coh[titulados_coh['ANHO_TIT']=="2025"]\
#     .groupby(['NIVEL_TIT_GRADO', 
#               'ANHO_TIT', 
#               'PLAN',
#               'CODIGO_CARRERA'])\
#     .size()
    
# titulados_coh.groupby(['ANHO', 
#                        'SEXO',
#                        'ANHO_TIT',
#                        'CODIGO_PROGRAMA_SIES',
#                        'NIVEL_TIT_GRADO',
#                        'oportuno',
#                        'exacto',
#                        ])\
#     .size()
(
titulados_coh[(titulados_coh['NIVEL_TIT_GRADO']=="TERMINAL") &
              (titulados_coh['CODIGO_CARRERA']=="MAGCM")]
.groupby(['ANHO', 
          'CODIGO_CARRERA',
          'NIVEL_TIT_GRADO',
          'ANHO_TIT',
          'ANHO_RES',
          'SEXO'])['RUT']
.nunique()
.reset_index(name="tot tit")
.to_clipboard()
    
)