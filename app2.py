#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 11 09:58:06 2025

@author: xenomorfo
"""

# app.py
import streamlit as st
import pandas as pd

# 1️⃣ Datos de ejemplo
data = {
    'ANHO_MAT': [2021, 2021, 2021, 2022, 2022, 2023],
    'sexo': ['M', 'F', 'M', 'F', 'M', 'F'],
    'NIVEL_GLOBAL': ['PRE', 'PRE', 'POS', 'PRE', 'POS', 'PRE'],
    'CODIGO_CARRERA': [101, 101, 102, 101, 102, 103],
    'COD_FAC': [10, 10, 20, 10, 20, 30],
    'FACULTAD': ['Ciencias', 'Ciencias', 'Ingeniería', 'Ciencias', 'Ingeniería', 'Derecho'],
    'rut': ['1-9', '2-7', '1-9', '3-5', '4-4', '5-2']  # Repetido '1-9' en 2021
}

df = pd.DataFrame(data)

# 2️⃣ Filtrar por año
df_filtrado = df[df['ANHO_MAT'] > 2020]

# 3️⃣ Agrupar y contar RUT distintos
df_resultado = (
    df_filtrado
    .groupby(['ANHO_MAT', 'sexo', 'NIVEL_GLOBAL', 'CODIGO_CARRERA', 'COD_FAC', 'FACULTAD'])
    ['rut']
    .nunique()
    .reset_index(name='total_rut_distintos')
)

# 4️⃣ Mostrar en Streamlit
st.title("Conteo de RUT distintos por agrupación")
st.dataframe(df_resultado)
