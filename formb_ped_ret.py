#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 24 21:33:55 2025

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

MAT_PER=pd.read_sql("""
            SELECT 
                m.rut, 
                m.nombres,
                m.ap_paterno,
                m.sexo,
                m.cod_plan,
                m.periodo_matricula,
                LEFT(periodo_matricula, 4) AS ANHO_MAT,
                cod_carr_prog AS CODIGO_CARRERA,
                LEFT(ingreso_plan, 4) AS ANHO_ING,
                CONCAT(m.rut, '-',LEFT(m.ingreso_plan, 4)) AS ID,
                CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan) AS RUT_ANHO_PLAN,
                CONCAT(LEFT(ingreso_plan, 4), '-',m.cod_plan) AS ANHO_PLAN,
                CONCAT(c.SIES, '-', m.rut) AS SIES_RUT,
                m.via_ingreso,
                m.cod_via,
                m.region,
                m.fecha_nac,
                d.GRUPO_DEPENDENCIA,
                d.INGRESO_PERCAPITA_GRUPO_FA,
                c.SIES,
                o.Tipo_Carrera,
                o.Jornada,
                o.[Cine-F_13_Área],
                o.Duración_Total,
                o.Nivel_Carrera,
                g.GRATUIDAD,
                f.TIPO AS CAE,
                h.TIPO AS FSCU
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
            ON CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan)=CONCAT(h.RUN, '-',h.AÑO_ING,'-', h.CODIGO_PLAN);""", con_1)
            
            
            
MAT_PER[['rut','SIES','periodo_matricula']]


    MAT[MAT['CODIGO_CARRERA'].isin(["PEDEDFIS", 
                                    "PEDQUIMBIO", 
                                    "PEDBIOQUIM","PEDINGLES"])\
        & (MAT['ANHO_MAT']>2014)] \
    .groupby(['ANHO_MAT',
              'SIES', 
              'CODIGO_CARRERA',             
              'Duración_Total']).size().to_clipboard()
    
    
COHORTES.groupby(['CODIGO_CARRERA_x',
                 'RET_1',
                 'RET_2',
                 'RET_3',
                 'ANHO_ING',
                 'SIES',
                 'NIVEL_GLOBAL']).size()

MAT[MAT['CODIGO_CARRERA'].isin(["PEDEDFIS", 
                                "PEDQUIMBIO", 
                                "PEDBIOQUIM",
                                "PEDINGLES"])].groupby(['primer_anio',
                                                        'COH',
                                                        'sexo',
                                                        'SIES', 
                                                        'cod_plan',
                                                        'ANHO_ING',
                                                        'MATEMATICA',
                                                        'COMP_LECT'])['rut']\
                                                        .nunique()\
                                                        .reset_index(name='n_rut_unicos')\
                                                        .to_clipboard()

                                                        
MAT[MAT['via_ingreso']=="CUPO EDUCADORES LIDERES - PROGRAMA GABRIELA MISTRAL"]

MAT[MAT['CODIGO_CARRERA'].isin(["PEDEDFIS", 
                                "PEDQUIMBIO", 
                                "PEDBIOQUIM",
                                "PEDINGLES"])].groupby(['rut', 
                                                        'ANHO_MAT',
                                                        'via_ingreso', 
                                                        'CODIGO_CARRERA', 
                                                        'SIES'])['rut']\
                                                        .nunique()\
                                                        .reset_index(name='rut_unicos')\
                                                        .to_clipboard()
                                                        
MAT[MAT['ANHO_ING']>2024].groupby(['CODIGO_CARRERA', 'ANHO_ING']).size()
MAT[MAT['ANHO_ING']==2024].groupby(['CODIGO_CARRERA', 'ANHO_ING']).size()