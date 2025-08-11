#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug  5 13:45:02 2025

@author: xenomorfo
"""

import fitz  # PyMuPDF
import pandas as pd
import PyMuPDF

doc = fitz.open("/home/xenomorfo/Documentos/ANALISTA ESTUDIOS/PEDIDOS/2023.ACTUALIZACION GRADO PAC/CONSOLIDACION INFO PAC/DERECHO/diploma_prueba.pdf")
for page in doc:
    text = page.get_text()
    print(text)

pd.DataFrame(text)
