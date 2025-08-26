#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Aug 15 22:50:57 2025

@author: xenomorfo
"""
import pandas as pd

tabla_raul=(
MAT[MAT['ANHO_ING']>2020].groupby(['ANHO_ING',
             'ANHO_MAT',
             'rut',
             'sexo',
             'nacionalidad',
             'NAC',
             'cod_plan',
             'SIES',
             'carrera_programa',
             'via_ingreso',
             'COD_DEPTO',
             'depto',
             'NIVEL_GLOBAL',
             'CODIGO_CARRERA',
             'COD_FAC',
             'FACULTAD',
             'primer_anio'])['rut']
.nunique()
.reset_index(name = "tot")
)

