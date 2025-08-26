#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 30 10:54:08 2025

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
                          COLUMNS WHERE TABLE_NAME='MATRICULA';")

for c in columnas.fetchall():
    print(c)


MAT=pd.read_sql("""
            SELECT 
                m.rut, 
                m.nombres,
                m.ap_paterno,
                m.sexo,
                m.nacionalidad,
                m.cod_plan,
                m.carrera_programa,
                LEFT(periodo_matricula, 4) AS ANHO_MAT,
                CODIGO_CARRERA=cod_carr_prog,
                LEFT(ingreso_plan, 4) AS ANHO_ING,
                CONCAT(m.rut, '-',LEFT(m.ingreso_plan, 4)) AS ID,
                CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan) AS RUT_ANHO_PLAN,
                CONCAT(LEFT(ingreso_plan, 4), '-',cod_plan) AS ANHO_PLAN,
                CONCAT(c.SIES, '-', m.rut) AS SIES_RUT,
                CONCAT(LEFT(m.ingreso_plan, 4),'-' ,c.SIES, '-', m.rut) AS ANHO_SIES_RUT,
                m.via_ingreso,
                m.cod_via,
                m.region,
                m.fecha_nac,
                d.GRUPO_DEPENDENCIA,
                d.INGRESO_PERCAPITA_GRUPO_FA,
                d.PUNTAJE_PONDERADO,
                d.MATEMATICA,
                d.COMP_LECT,
                c.SIES,
                o.Tipo_Carrera,
                o.Jornada,
                o.[Cine-F_13_Área],
                o.Duración_Total,
                o.Nivel_Carrera,
                g.GRATUIDAD,
                f.TIPO AS CAE,
                h.TIPO AS FSCU,
                cc.COD_FAC,
                cc.FACULTAD,
                cc.COD_DEPTO,
                cc.Columna2 AS depto,
                mu.NAC,
                COUNT(m.rut) AS Total
            FROM MATRICULA m
            LEFT JOIN DEMRE_E_2014_2025 d 
            ON CONCAT(m.rut, '-',LEFT(m.ingreso_plan, 4))=d.ID_ANHO
            LEFT JOIN CPP_DR c
            ON CONCAT(LEFT(periodo_matricula,4), '-',m.cod_plan)=c.ANHO_PLAN
            LEFT JOIN OA_SIES_2010_2025_USACH o
            ON CONCAT(c.ANHO, '_', c.SIES)=o.llave
            LEFT JOIN tb_gratuidad g
            ON CONCAT(m.rut, '-',LEFT(m.ingreso_plan, 4))=CONCAT(g.Rut,'-',g.AÑO)
            LEFT JOIN cae f
            ON CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan)=CONCAT(f.RUN, '-',f.AÑO_ING,'-', f.CODIGO_PLAN)
            LEFT JOIN fscu h
            ON CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan)=CONCAT(h.RUN, '-',h.AÑO_ING,'-', h.CODIGO_PLAN)
            LEFT JOIN centro_costo cc
            ON cod_carr_prog = [COD CARRERA]
            LEFT JOIN TABLA_MU mu
            ON CONCAT(LEFT(m.ingreso_plan, 4),'-' ,c.SIES, '-', m.rut) = CONCAT(mu.ANHO_MU, '-', mu.COD_SIES,'-', mu.N_DOC)
            GROUP BY
                m.rut,
                m.nombres,
                m.ap_paterno,
                m.sexo,
                m.nacionalidad,
                m.cod_plan,
                m.carrera_programa,
                LEFT(periodo_matricula, 4),
                CONCAT(m.rut, LEFT(m.ingreso_plan, 4)),
                CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan),
                m.cod_carr_prog,
                CONCAT(LEFT(ingreso_plan, 4), '-',cod_plan),
                CONCAT(ANHO, '_', SIES),
                CONCAT(c.SIES, '-', m.rut),
                CONCAT(LEFT(m.ingreso_plan, 4),'-',c.SIES, '-', m.rut),
                m.ingreso_plan,
                m.via_ingreso,
                m.region,
                m.fecha_nac,
                d.GRUPO_DEPENDENCIA,
                d.INGRESO_PERCAPITA_GRUPO_FA,
                d.PUNTAJE_PONDERADO,
                d.MATEMATICA,
                d.COMP_LECT,
                c.SIES,
                o.Tipo_Carrera,
                o.Jornada,
                o.[Cine-F_13_Área],
                o.Duración_Total,
                o.Nivel_Carrera,
                g.GRATUIDAD,
                f.TIPO,
                h.TIPO,
                cc.COD_FAC,
                cc.FACULTAD,
                cc.COD_DEPTO,
                cc.Columna2,
                m.cod_via,
                mu.NAC;""", con_1)


###NIVEL GLOBAL
MAT['NIVEL_GLOBAL']=np.where(MAT['CODIGO_CARRERA']=="UNICIT", "UNICIT",
    np.where(MAT['CODIGO_CARRERA']=="MIDA", "MAGISTER",
    np.where(MAT['CODIGO_CARRERA'].str[0:3]=="MAG","MAGISTER", 
    np.where(MAT['CODIGO_CARRERA'].str[0:3]=="DOC","DOCTORADO",
    np.where(MAT['CODIGO_CARRERA'].str[0:3]=="DIP","DIPLOMADO",
    np.where(MAT['CODIGO_CARRERA'].str[0:3]=="POS","POSTITUTLO","PREGRADO"))))))


MAT['fecha_nac']=pd.to_datetime(MAT['fecha_nac'])

MAT['fecha_nac']=pd.to_datetime(
    np.where(MAT['fecha_nac'] > pd.to_datetime('2025-01-01'), 
         MAT['fecha_nac'] - pd.DateOffset(years=100), 
    np.where(MAT['fecha_nac'] < pd.to_datetime('1910-01-01'), 
         MAT['fecha_nac'] + pd.DateOffset(years=100),MAT['fecha_nac'])))

MAT.info()
MAT=MAT.fillna(999)

MAT['ANHO_ING']=MAT['ANHO_ING'].astype(int)
#MAT['ANHO_ING']=MAT['ANHO_ING'].astype(str)
MAT['ANHO_MAT']=MAT['ANHO_MAT'].astype(int)

### edad
MAT['edad']=(((pd.to_datetime(date.today())-MAT['fecha_nac']).dt.days)/365).round(2)

#MAT[(MAT['rut']==19828443)]\
 #   .groupby(['rut', 'nombres', 'ap_paterno','via_ingreso','CODIGO_CARRERA'])

VIA_ING_ANIO=[81,63,26,29,	21,	66,	50,	15,	20,	49,	17,	60,	72,	43,	71,	10,	
              70,53,30,54,	55,	44,	16,	87,	95,	97,	85,	37,	68,	86,	19,	75,	
              64,62,76,27,	14,	77,	11,	74,	65,	12,	84,	73,	18,	83,	61, 99, 
              88,39]


###Definición cohorte
MAT['COH']=np.where((np.isin(MAT['cod_via'], VIA_ING_ANIO).astype(int)==1) & 
         (MAT['ANHO_MAT']==MAT['ANHO_ING']),1,0)

MAT['id-anonimo']=MAT['rut']*25+MAT['ANHO_MAT']

####Definicion primer anio amplio
MAT['primer_anio']=np.where((MAT['ANHO_MAT']==MAT['ANHO_ING']),1,0)
###Informado SIES

informado_sies=pd.read_sql("""SELECT
            SIES_RUT
            FROM TABLA_MU
            WHERE VIG=1 AND UNICIT='NO UNICIT'""",con_1)
            
MAT['INFORMADO_SIES']=MAT['SIES_RUT'].isin(informado_sies['SIES_RUT']).astype(int)

####Informado SIES 2

informado_sies_2=pd.read_sql("""SELECT
            SIES_RUT,
            ANHO_SIES_RUT
            FROM TABLA_MU
            WHERE VIG=1 AND UNICIT='NO UNICIT'""",con_1)
            
MAT['INFORMADO_SIES']=MAT['ANHO_SIES_RUT'].isin(informado_sies_2['ANHO_SIES_RUT']).astype(int)

####Tabla cohortes
TABLA_COH=MAT.loc[MAT['COH'] == 1, ['rut',
                                    'RUT_ANHO_PLAN','ANHO_ING',  
                                    'Tipo_Carrera',
                                    'INFORMADO_SIES',
                                    'Duración_Total',
                                    'Nivel_Carrera',
                                    'CODIGO_CARRERA', 
                                    'NIVEL_GLOBAL',
                                    'cod_plan']]


COHORTES=TABLA_COH.merge(MAT[['COH','rut','sexo',
                      'RUT_ANHO_PLAN',
                      'ANHO_MAT',
                      'CODIGO_CARRERA', 
                      'cod_plan', 'SIES']], 
                 on='rut', how='left')
#####RETENCIONES
####RET_1

COHORTES['RET_1']=\
np.where((COHORTES['ANHO_ING']!=COHORTES['ANHO_MAT']) &
         (COHORTES['ANHO_MAT']-COHORTES['ANHO_ING']==1) &
         (COHORTES['cod_plan_x']==COHORTES['cod_plan_y']),1,
np.where((COHORTES['ANHO_ING']!=COHORTES['ANHO_MAT']) &
         (COHORTES['ANHO_MAT']-COHORTES['ANHO_ING']==1) &
         (COHORTES['CODIGO_CARRERA_x']==COHORTES['CODIGO_CARRERA_y']),1,0))

COHORTES['RET_2']=\
np.where((COHORTES['ANHO_ING']!=COHORTES['ANHO_MAT']) &
         (COHORTES['ANHO_MAT']-COHORTES['ANHO_ING']==2) &
         (COHORTES['cod_plan_x']==COHORTES['cod_plan_y']),1,
np.where((COHORTES['ANHO_ING']!=COHORTES['ANHO_MAT']) &
         (COHORTES['ANHO_MAT']-COHORTES['ANHO_ING']==2) &
         (COHORTES['CODIGO_CARRERA_x']==COHORTES['CODIGO_CARRERA_y']),1,0))

COHORTES['RET_3']=\
np.where((COHORTES['ANHO_ING']!=COHORTES['ANHO_MAT']) &
         (COHORTES['ANHO_MAT']-COHORTES['ANHO_ING']==3) &
         (COHORTES['cod_plan_x']==COHORTES['cod_plan_y']),1,
np.where((COHORTES['ANHO_ING']!=COHORTES['ANHO_MAT']) &
         (COHORTES['ANHO_MAT']-COHORTES['ANHO_ING']==3) &
         (COHORTES['CODIGO_CARRERA_x']==COHORTES['CODIGO_CARRERA_y']),1,0))


COHORTES['RET_4']=\
np.where((COHORTES['ANHO_ING']!=COHORTES['ANHO_MAT']) &
         (COHORTES['ANHO_MAT']-COHORTES['ANHO_ING']==4) &
         (COHORTES['cod_plan_x']==COHORTES['cod_plan_y']),1,
np.where((COHORTES['ANHO_ING']!=COHORTES['ANHO_MAT']) &
         (COHORTES['ANHO_MAT']-COHORTES['ANHO_ING']==4) &
         (COHORTES['CODIGO_CARRERA_x']==COHORTES['CODIGO_CARRERA_y']),1,0))


TEST=(TABLA_COH.merge(
    COHORTES[['RUT_ANHO_PLAN_x', 
              'RET_1',
              'RET_3']],
    left_on='RUT_ANHO_PLAN',  # o la columna de TABLA_COH que coincida
    right_on='RUT_ANHO_PLAN_x',
    how='left').drop_duplicates()
    )

MAT.merge(
    COHORTES[['RUT_ANHO_PLAN_x', 
              'RET_1',
              'RET_3']],
    left_on='RUT_ANHO_PLAN',  # o la columna de TABLA_COH que coincida
    right_on='RUT_ANHO_PLAN_x',
    how='left').drop_duplicates()


TABLA_COH.merge(COHORTES[['RUT_ANHO_PLAN', 'RET_1']], on='RUT_ANHO_PLAN', how='left')



#COHORTES.loc[COHORTES['COH']==1, ['ANHO_ING',
#                                  'CODIGO_CARRERA_x', 
 #                                 'RET_1']]
 

#####ret
COHORTES[COHORTES['CODIGO_CARRERA_x'].isin(["PEDEDFIS", 
                        "PEDQUIMBIO", 
                        "PEDBIOQUIM",
                        "PEDINGLES"]) & (COHORTES['ANHO_ING']>2014) &(COHORTES['COH']==1)]\
    .groupby(['CODIGO_CARRERA_x',
                 'sexo',
                 'RET_1',
                 'RET_2',
                 'RET_3',
                 'ANHO_ING',
                 'SIES',
                 'NIVEL_GLOBAL'])['rut'].size().to_clipboard()



(
 COHORTES[
    #(COHORTES['CODIGO_CARRERA_x']=="ARQ") &
    (COHORTES['NIVEL_GLOBAL']=="PREGRADO") &
    (COHORTES['Tipo_Carrera']=="Plan Regular") &
         (COHORTES['ANHO_ING']>2011)]
.groupby(['CODIGO_CARRERA_x', 
          'COH',
          'Tipo_Carrera',
          'Duración_Total',
          'Nivel_Carrera',
          'RET_1',
          'RET_2',
          'RET_3',
          'ANHO_ING'])['rut']
.nunique()
#.to_clipboard()
)





MAT[(MAT['SIES']==999) & 
    (MAT['primer_anio']==1) & (MAT['NIVEL_GLOBAL']=="PREGRADO")]\
    .groupby(['INFORMADO_SIES','ANHO_ING']).size().unstack()
    





MAT[(MAT['ANHO_MAT']==2024) &
    (MAT['NIVEL_GLOBAL']=="PREGRADO")]\
    .groupby(['rut','SIES', 
              'via_ingreso','NIVEL_GLOBAL',
              'INFORMADO_SIES','Tipo_Carrera','ANHO_MAT'])\
        .size().to_clipboard()
        
MAT[MAT['NIVEL_GLOBAL']=="DIPLOMADO"]\
    .groupby(['SIES', 'cod_plan','ANHO_MAT'])\
        .size().to_clipboard()



(
MAT.groupby(['cod_plan', 'SIES', 'carrera_programa'])['rut']
.nunique()
.to_clipboard()
)