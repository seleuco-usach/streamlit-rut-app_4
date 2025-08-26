#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug  4 11:34:38 2025

@author: xenomorfo
"""

import streamlit as st
import pandas as pd
import numpy as np

# Título
st.title("Retencion USACH")

# Entrada de texto
nombre = st.text_input("¿Cuál es tu nombre?", "Invitado")
st.write(f"Hola, **{nombre}** 👋")

# Generar y mostrar un gráfico
st.subheader("Retencion 2007 - 2025")


#df = pd.DataFrame(
 #   np.random.randn(20, 4),
 #   columns=['grupo','Serie A', 'Serie B', 'Serie C']
#)

import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
from gspread_dataframe import set_with_dataframe

# Abrir la hoja de cálculo por ID
scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
client = gspread.authorize(credentials)


spreadsheet = client.open_by_key('1paFv1Dn2mcRubtCgVHL1xPmLPN9T9bvZr4JGVGqByaU')

credentials = ServiceAccountCredentials.\
from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)

worksheet = spreadsheet.get_worksheet(5)  # índice 0 es la primera hoja
tabla_ret = worksheet.get_all_values()

#tabla_ret= pd.DataFrame(tabla_ret[1:], columns=tabla_ret[0])

tabla_ret=pd.DataFrame(tabla_ret[1:], columns=tabla_ret[0])

tabla_ret['ret_1']=(
tabla_ret['ret_1']
.str.replace(",", ".")
.replace('','0')
.astype(float)
)

tabla_ret['ret_2']=(
tabla_ret['ret_2']
.str.replace(",", ".")
.replace('','0')
.astype(float)
)

tabla_ret['ret_3']=(
tabla_ret['ret_3']
.str.replace(",", ".")
.replace('','0')
.astype(float)
)


tabla_ret=(tabla_ret.groupby(['ANHO_ING',])
.agg({'ret_1': 'mean', 
      'ret_2': 'mean', 
      'ret_3': 'mean'})
.reset_index()
)


st.line_chart(
    data=tabla_ret,
    x="ANHO_ING",
    y=["ret_1", "ret_2", "ret_3"]
)


#st.line_chart(tabla_ret)




# Contador de clics
if "contador" not in st.session_state:
    st.session_state.contador = 0

if st.button("¡Haz clic aquí!"):
    st.session_state.contador += 1

st.write(f"Has hecho clic **{st.session_state.contador}** veces.")

# Despedida
st.markdown("---")
st.write("Gracias por probar esta demo de Streamlit.")
