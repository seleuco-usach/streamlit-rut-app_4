#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 23 13:34:52 2025

@author: xenomorfo
"""

from io import BytesIO
import requests
import pandas as pd

result = requests.get("https://www.mifuturo.cl/wp-content/uploads/2024/07/MAT_2007_2024_WEB_02072024.zip")
df = pd.read_csv(BytesIO(result.content),compression='zip', header=0, sep=';', quotechar='"', encoding='latin-1',on_bad_lines='skip')
print(df)

MAT_USACH=df[df['CÓDIGO DE INSTITUCIÓN']==71]

MAT_USACH['AÑO']=MAT_USACH['AÑO'].str.replace('MAT_', '', regex=True).astype(int)



MAT_USACH[(MAT_USACH['NIVEL GLOBAL']=="Pregrado") &
        (MAT_USACH['AÑO']>2021)].groupby(['CÓDIGO CARRERA', 
                                          'NOMBRE CARRERA', 
                                          'NIVEL GLOBAL', 
                                          'TIPO DE PLAN DE LA CARRERA',
                                          'NOMBRE INSTITUCIÓN','ACREDITACIÓN CARRERA',
                                          'AÑO'])['TOTAL MATRICULADOS']\
    .sum()\
    .to_clipboard()


result = requests.get("https://mifuturo.cl/wp-content/uploads/2025/05/TITULADO_2007-2024_web_19_05_2025_E.zip")
df_3 = pd.read_csv(BytesIO(result.content),compression='zip', header=0, sep=';', quotechar='"', encoding='latin-1',on_bad_lines='skip')
print(df_3)

OA_USACH=df_3[df_3['CÓDIGO INSTITUCIÓN']==71]

OA_USACH['AÑO']=OA_USACH['AÑO'].str.replace('TIT_', '', regex=True).astype(int)

OA_USACH[(OA_USACH['NIVEL GLOBAL']=="Pregrado") &
        (OA_USACH['AÑO']>2021)].groupby(['CÓDIGO PROGRAMA', 
                                          'NOMBRE CARRERA', 
                                          'NIVEL GLOBAL', 
                                          'TIPO DE PLAN DE LA CARRERA',
                                          'AÑO'])['TOTAL TITULACIONES']\
    .sum()\
    .unstack().to_clipboard()


result = requests.get("https://mifuturo.cl/wp-content/uploads/2025/06/Oferta_Academica_2010_al_2025_SIES_02_06_2025_WEB_E.zip")
df_2 = pd.read_csv(BytesIO(result.content),compression='zip', header=0, sep=';', quotechar='"', encoding='latin-1',on_bad_lines='skip')
print(df_2)

OA_USACH=df_2[df_2['Código IES']==71]

OA_USACH['Año']=OA_USACH['Año'].str.replace('OFE_', '', regex=True).astype(int)

OA_USACH[(OA_USACH['Nivel Global']=="Pregrado") &
        (OA_USACH['Año']>2022)].groupby(['Código Único', 
                                          'Nombre Carrera', 
                                          'Nivel Global', 
                                          'Tipo Carrera',
                                          'Acreditación Carrera o Programa',
                                          'Año'])\
    .size()\
    .unstack().to_clipboard()

