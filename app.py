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


#from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
import numpy as np
#from gspread_dataframe import set_with_dataframe



tabla_ret=pd.read_csv("tabla_ret.csv")




#tabla_ret['ret_1']=(
#tabla_ret['ret_1']
#.astype(str)
#.str.replace(",", ".")
#.replace('','0')
#.astype(float)
#)

#tabla_ret['ret_2']=(
#tabla_ret['ret_2']
#.astype(str)
#.str.replace(",", ".")
#.replace('','0')
#.astype(float)
#)

#tabla_ret['ret_3']=(
#tabla_ret['ret_3']
#.astype(str)
#.str.replace(",", ".")
#.replace('','0')
#.astype(float)
#)


tabla_ret=(tabla_ret.groupby(['ANHO_ING',])
.agg({'ret_1': 'mean', 
      'ret_2': 'mean', 
      'ret_3': 'mean'})
.reset_index()
)


#tabla_ret=tabla_ret[['ANHO_ING','ret_1', 
#                     'ret_2', 'ret_3']].replace(0, np.nan)


#st.line_chart(
 #   data=tabla_ret,
  #  x="ANHO_ING",
   # y=["ret_1", "ret_2", "ret_3"]
#)

import altair as alt

chart = alt.Chart(tabla_ret).mark_line().encode(
    x="ANHO_ING:O",
    y=alt.Y("value:Q"),
    color="variable:N"
).transform_fold(
    ["ret_1", "ret_2", "ret_3"], 
    as_=["variable", "value"]
)

st.altair_chart(chart, use_container_width=True)


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
