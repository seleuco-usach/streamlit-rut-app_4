
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug  4 16:28:19 2025

@author: xenomorfo
"""
import pandas as pd
import gdown

# ID del archivo infra 20
infra_20_id = "1gvIuiRApzbwqikxiroTshD57TSD3J1sC"
url = f"https://drive.google.com/uc?id={infra_20_id}"

campos_20_id = "1ks1IlFRTuKVke5m26Ws3kG_-MM7STP9_"
url_campos_20 = f"https://drive.google.com/uc?id={campos_20_id}"

# Nombre temporal del archivo
output_infra_20 = "archivo.csv"
gdown.download(url, output_infra_20, quiet=False)

output_campos_20_id = "campos_rchivo.csv"
gdown.download(url_campos_20, output_campos_20_id, quiet=False)


# Leer el csv
infra_2020 = pd.read_csv(output_infra_20, encoding="Latin1", sep=";")
print(infra_2020.head())

campos_2020 = pd.read_csv(output_campos_20_id, encoding="Latin1", sep=";")
print(campos_2020.head())

infra_2020.columns=campos_2020.columns


infra_2020['anho']="2020"

infra_2020.columns


# ID del archivo infra 21
infra_21_id = "1kX5ltxkd_Wo5x_UPKt3uoXGE4xt4qanW"
url = f"https://drive.google.com/uc?id={infra_21_id}"

# Nombre temporal del archivo
output_infra_21 = "archivo.xlsx"
gdown.download(url, output_infra_21, quiet=False)


#infra_2021.columns

# Leer el Excel
infra_2021 = pd.read_excel(output_infra_21)
print(infra_2021.head())

infra_2021['anho']="2021"

# ID del archivo infra 22
infra_22_id = "1L8yqzQbjOng3GLszx2ZXPpcaGJ9JFnd0"
url = f"https://drive.google.com/uc?id={infra_22_id}"

# Nombre temporal del archivo
output_infra_22 = "archivo.xlsx"
gdown.download(url, output_infra_22, quiet=False)

# Leer el Excel
infra_2022 = pd.read_excel(output_infra_22)
print(infra_2022.head())

infra_2022['anho']="2022"

# ID del archivo infra 23
infra_23_id = "16FcxyFrDJ67P4G99DvIIwWPNlc7HgPIq"
url = f"https://drive.google.com/uc?id={infra_23_id}"

# Nombre temporal del archivo
output_infra_23 = "archivo.xlsx"
gdown.download(url, output_infra_23, quiet=False)

# Leer el Excel
infra_2023 = pd.read_excel(output_infra_23)
print(infra_2023.head())

infra_2023['anho']="2023"


# ID del archivo infra 24
infra_24_id = "133Kh6zE4L8hPJtef7-73oGQELZknCChr"
url = f"https://drive.google.com/uc?id={infra_24_id}"

# Nombre temporal del archivo
output_infra_24 = "archivo.xlsx"
gdown.download(url, output_infra_24, quiet=False)

# Leer el Excel
infra_2024 = pd.read_excel(output_infra_24)
print(infra_2024.head())

infra_2024['anho']="2024"


# ID del archivo infra 25
infra_25_id = "1kd7BRzYV-8_dQJLy8MursAsJyZJ5HQpA"
url = f"https://drive.google.com/uc?id={infra_25_id}"

# Nombre temporal del archivo
output_infra_25 = "archivo.xlsx"
gdown.download(url, output_infra_25, quiet=False)

# Leer el Excel
infra_2025 = pd.read_excel(output_infra_25)
print(infra_2025.head())

infra_2025['anho']="2025"



len(set(infra_2025.columns) & 
    set(infra_2024.columns) &
    set(infra_2023.columns) &
    set(infra_2022.columns) &
    set(infra_2021.columns) &
    set(infra_2020.columns))

from functools import reduce
import pandas as pd

dfs = [infra_2020, 
       infra_2021, 
       infra_2022, 
       infra_2023, 
       infra_2024, 
       infra_2025]


for col in infra_2020:
    infra_2020[col] = (
        infra_2020[col]
        .astype(str)
        .str.replace(",", ".")) 

for col in infra_2020.columns[infra_2020.columns.str.contains("TOTAL", regex=True)]:
    infra_2020[col] = (
        infra_2020[col]
        .astype(str)
        .str.replace(",", ".")
        .astype(float))



for col in infra_2021.columns[infra_2021.columns.str.contains("TOTAL", regex=True)]:
    infra_2021[col] = (
        infra_2021[col]
        .astype(str)
        .str.replace(",", ".")
        .astype(float))

for col in infra_2023.columns[infra_2021.columns.str.contains("TOTAL", regex=True)]:
    infra_2023[col] = (
        infra_2023[col]
        .astype(str)
        .str.replace(",", ".")
        .astype(float))
    


infra = {2020: infra_2020,
         2021: infra_2021,
         2022: infra_2022,
         2023: infra_2023,
         2024: infra_2024,
         2025: infra_2025}


for i in range(2020, 2026):
    print(f"Año: {i}")
    print(infra[i]['TOTAL_M2_TERRENO'].dtype)
    
anos = range(2020,2025)

for i in range(2020, 2026):
    infra[i]['FECHA_INICIO_TENENCIA']=infra[i]['FECHA_INICIO_TENENCIA'].astype(str)
    infra[i]['DESCRIPCION_OTRA_TENENCIA']=infra[i]['DESCRIPCION_OTRA_TENENCIA'].astype(str)
    infra[i]['FECHA_TERMINO']=infra[i]['FECHA_TERMINO'].astype(str)
    infra[i]['CAPACIDAD_AUDITORIOS']=infra[i]['CAPACIDAD_AUDITORIOS'].astype(float)
    infra[i]['TIPO_INFRAESTRUCTURA']=infra[i]['TIPO_INFRAESTRUCTURA'].astype(int)
    infra[i]['SITUACION_TENENCIA']=infra[i]['SITUACION_TENENCIA'].astype(float)
    infra[i]['ANIO_INICIO_USO_INMUEBLE']=infra[i]['ANIO_INICIO_USO_INMUEBLE'].astype(float)
    infra[i]['USO_EXCLUSIVO']=infra[i]['USO_EXCLUSIVO'].astype(float)
    infra[i]['PORCENTAJE_USO']=infra[i]['PORCENTAJE_USO'].astype(float)
    infra[i]['CAPACIDAD_SALAS_CLASES']=infra[i]['CAPACIDAD_SALAS_CLASES'].astype(float)
    infra[i]['UR_SITUACION_TENENCIA']=infra[i]['UR_SITUACION_TENENCIA'].astype(float)
    infra[i]['HORAS_PERSONAL_BIBLIOTECA']=infra[i]['HORAS_PERSONAL_BIBLIOTECA'].astype(float)
    infra[i]['VIGENCIA']=infra[i]['VIGENCIA'].astype(int)

infra_cons=reduce(lambda left, right: pd.merge(left, right, how='outer'), dfs)

reduce(lambda left, right: pd.merge(left, right, how='outer'), dfs)

infra_cons=infra_cons[['anho'] + [col for col in infra_cons.columns if col!= 'anho']]

infra_2021['TOTAL_M2_EDIFICADOS'].info()

infra_cons.to_clipboard()

infra_2024['SITUACION_TENENCIA']