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
st.title("Demo interactiva con Streamlit")

# Entrada de texto
nombre = st.text_input("¿Cuál es tu nombre?", "Invitado")
st.write(f"Hola, **{nombre}** 👋")

# Generar y mostrar un gráfico
st.subheader("Gráfico de línea con datos aleatorios")

df = pd.DataFrame(
    np.random.randn(20, 3),
    columns=['Serie A', 'Serie B', 'Serie C']
)
st.line_chart(df)

# Contador de clics
if "contador" not in st.session_state:
    st.session_state.contador = 0

if st.button("¡Haz clic aquí!"):
    st.session_state.contador += 1

st.write(f"Has hecho clic **{st.session_state.contador}** veces.")

# Despedida
st.markdown("---")
st.write("Gracias por probar esta demo de Streamlit.")
