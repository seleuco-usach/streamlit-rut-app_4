#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul  8 09:56:57 2025

@author: xenomorfo
"""

import pyodbc
import pandas as pd
import numpy as np
from datetime import date
from sklearn.preprocessing import StandardScaler, MinMaxScaler

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
                          COLUMNS WHERE TABLE_NAME='MU_PRE_POST_2012_2025';")

for c in columnas.fetchall():
    print(c)
    
    
MU_SIES=pd.read_sql("""SELECT 
            s.periodo_matricula,
            CONCAT(s.periodo_matricula, '-', s.mc_codigo_unico) AS llave,
            s.mm_n_documento,
            s.mm_ape_paterno,
            s.mm_ape_materno,
            s.mm_nombres,
            s.mm_sexo,
            s.mm_anio_origen,
            s.mm_anio_actual,
            s.mc_codigo_unico,
            s.mc_nivel_global,
            s.mc_nomb_inst
            FROM MU_SIES s""", con_1)
    
    
    
MU_SIES=pd.read_sql("""SELECT 
            s.periodo_matricula,
            CONCAT(s.periodo_matricula, '-', s.mc_codigo_unico) AS llave,
            s.mm_n_documento,
            s.mm_ape_paterno,
            s.mm_ape_materno,
            s.mm_nombres,
            s.mm_sexo,
            s.mm_anio_origen,
            s.mm_anio_actual,
            s.mc_codigo_unico,
            s.mc_nivel_global,
            s.mc_nomb_inst,
            s.mm_forma_ingreso_uni,
            d.COMP_LECT,
            d.MATEMATICA
            FROM MU_PRE_POST_2012_2025 s
            LEFT JOIN DEMRE_E_2014_2025 d
            ON CONCAT(s.mm_n_documento, '-',s.periodo_matricula, '-', s.mc_codigo_unico)= CONCAT(d.NUMERO_DOCUMENTO,'-',d.ANYO_PROCESO, '-', d.codigo_unico)""", con_1)


###tabla mu para calculo de puntajes            
(
MU_SIES[MU_SIES['mc_codigo_unico']
.isin(["I71S1C43J1V1", 
       "I71S1C145J1V1", 
       "I71S1C145J1V2",
       "I71S1C395J1V1",
       "I71S1C395J1V2"])]
.groupby(['mm_n_documento', 
          'mm_sexo',
          'periodo_matricula',
          'COMP_LECT', 
          'MATEMATICA', 
          'mc_codigo_unico'])['mm_n_documento']
.nunique()
.reset_index(name='rut_unicos')
#.to_clipboard()
)

####distribucion pruebas comprension lectora y matematica
MU_SIES['PAES']=(MU_SIES['COMP_LECT'] + MU_SIES['MATEMATICA'])/2

MinMaxScaler(MU_SIES['PAES'])

MU_SIES[MU_SIES['periodo_matricula']==2025][[
         'mm_n_documento',
         'periodo_matricula',
         'COMP_LECT', 
         'MATEMATICA', 'PAES']].describe().round(2)

MU_SIES[MU_SIES['periodo_matricula'] == 2025][[
         #'mm_n_documento',
         'periodo_matricula',
         'COMP_LECT', 
         'MATEMATICA', 
         'PAES']].quantile([0.25, 0.5, 0.6, 0.75])


(
MU_SIES
.groupby(['periodo_matricula'])[['COMP_LECT', 'MATEMATICA']]
.describe()
)
####tabla 3.1
(
MU_SIES[MU_SIES['mc_codigo_unico']
.isin(["I71S1C43J1V1", 
       "I71S1C145J1V1", 
       "I71S1C145J1V2",
       "I71S1C395J1V1",
       "I71S1C395J1V2"])]
.groupby(['mm_n_documento', 
          'mm_sexo',
          'periodo_matricula',
          'mm_forma_ingreso_uni',
          'mc_codigo_unico'])['mm_n_documento']
.nunique()
.reset_index(name='rut_unicos')
#.to_clipboard()
)



###Frecuencia por codigo unico            
(                                                        
MU_SIES[MU_SIES['mc_codigo_unico']
.isin(["I71S1C43J1V1", 
       "I71S1C145J1V1", 
       "I71S1C145J1V2",
       "I71S1C395J1V1",
       "I71S1C395J1V2"])]
.groupby(['mc_codigo_unico'])['mm_n_documento']
.nunique()
.reset_index(name='rut_unicos')     
)                          


#####????
(                              
MU_SIES[MU_SIES['mc_codigo_unico']
.isin(["I71S1C43J1V1", 
       "I71S1C145J1V1", 
       "I71S1C145J1V2", 
       "I71S1C395J1V1", 
       "I71S1C395J1V2"
])]
)


####????
(
MU_SIES
.groupby([
    'mm_n_documento', 
    'mm_sexo',
    'periodo_matricula',
    'COMP_LECT', 
    'MATEMATICA', 
    'mc_codigo_unico'
])['mm_n_documento']
.nunique()
.reset_index(name='rut_unicos')
)                                                      


####Tabla sobre cupos
(
pd.read_sql("""SELECT
            v.vacantes,
            v.sobre_cupo,
            v.ano_proceso,
            v.cod_usach,
            c.SIES,
            CONCAT(v.ano_proceso, '-', v.cod_usach) AS anho_cod
            FROM VAC_SOBRE_CUPOS v
            LEFT JOIN CPP_DR c
            ON CONCAT(v.ano_proceso, '-', v.cod_usach)=c.ANHO_PLAN""", con_1)
#.to_clipboard()
)            

####Media compr_lect y matematica por codigo unico y año
(
MU_SIES[MU_SIES['mc_codigo_unico']
.isin(["I71S1C43J1V1", 
       "I71S1C145J1V1", 
       "I71S1C145J1V2",
       "I71S1C395J1V1",
       "I71S1C395J1V2"])]
.groupby(['mc_codigo_unico', 
          'periodo_matricula'])[['COMP_LECT', 'MATEMATICA']]
.mean()
.mean(axis=1)
#.to_clipboard()
                                                                     
)                                                                  
                                                       