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


import pandas as pd
import numpy as np



tabla_ret=pd.read_csv("tabla_ret.csv")

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

#import plotly.express as px
import altair as alt

#px.line(tabla_ret, x='ANHO_ING', y=['ret_1', 
 #                                  'ret_2', 
  #                                 'ret_3']) 

chart = alt.Chart(tabla_ret).mark_line().encode(
    x="ANHO_ING:O",
    y=alt.Y("value:Q"),
    color="variable:N"
).transform_fold(
    ["ret_1", "ret_2", "ret_3"], 
    as_=["variable", "value"]
)

st.altair_chart(chart, use_container_width=True)


tabla_ret_largo=tabla_ret.melt(id_vars=['ANHO_ING'], 
             value_vars=['ret_1', 'ret_2', 'ret_3'])

ret_sel = st.radio("Selecciona la retención a visualizar:", 
         ('ret_1', 'ret_2', 'ret_3'), index=0)


#st.line_chart(tabla_ret)

tabla_ret_largo_filtrado=tabla_ret_largo[tabla_ret_largo['variable']==ret_sel]

chart = alt.Chart(tabla_ret).mark_line().encode(
    x="ANHO_ING:O",
    y=alt.Y(ret_sel, title = "Retención"),
    color="variable:N"
).transform_fold(
    ["ret_1", "ret_2", "ret_3"], 
    as_=["variable", "value"]
)


# Contador de clics
if "contador" not in st.session_state:
    st.session_state.contador = 0

if st.button("¡Haz clic aquí!"):
    st.session_state.contador += 1

st.write(f"Has hecho clic **{st.session_state.contador}** veces.")

# Despedida
st.markdown("---")
st.write("Gracias por probar esta demo de Streamlit.")
