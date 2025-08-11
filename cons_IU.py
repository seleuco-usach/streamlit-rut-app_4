
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug  4 16:28:19 2025

@author: xenomorfo
"""
import pandas as pd
import gdown


# ID del archivo infra 21
infra_21_id = "1kX5ltxkd_Wo5x_UPKt3uoXGE4xt4qanW"
url = f"https://drive.google.com/uc?id={infra_21_id}"

# Nombre temporal del archivo
output_infra_21 = "archivo.xlsx"
gdown.download(url, output_infra_21, quiet=False)

# Leer el Excel
infra_2021 = pd.read_excel(output_infra_21)
print(infra_2021.head())

# ID del archivo infra 22
infra_22_id = "1L8yqzQbjOng3GLszx2ZXPpcaGJ9JFnd0"
url = f"https://drive.google.com/uc?id={infra_22_id}"

# Nombre temporal del archivo
output_infra_22 = "archivo.xlsx"
gdown.download(url, output_infra_22, quiet=False)

# Leer el Excel
infra_2022 = pd.read_excel(output_infra_22)
print(infra_2022.head())



# ID del archivo infra 23
infra_23_id = "16FcxyFrDJ67P4G99DvIIwWPNlc7HgPIq"
url = f"https://drive.google.com/uc?id={infra_23_id}"

# Nombre temporal del archivo
output_infra_23 = "archivo.xlsx"
gdown.download(url, output_infra_23, quiet=False)

# Leer el Excel
infra_2023 = pd.read_excel(output_infra_23)
print(infra_2023.head())


# ID del archivo infra 24
infra_24_id = "133Kh6zE4L8hPJtef7-73oGQELZknCChr"
url = f"https://drive.google.com/uc?id={infra_24_id}"

# Nombre temporal del archivo
output_infra_24 = "archivo.xlsx"
gdown.download(url, output_infra_24, quiet=False)

# Leer el Excel
infra_2024 = pd.read_excel(output_infra_24)
print(infra_2024.head())

# ID del archivo infra 25
infra_25_id = "1kd7BRzYV-8_dQJLy8MursAsJyZJ5HQpA"
url = f"https://drive.google.com/uc?id={infra_25_id}"

# Nombre temporal del archivo
output_infra_25 = "archivo.xlsx"
gdown.download(url, output_infra_25, quiet=False)

# Leer el Excel
infra_2025 = pd.read_excel(output_infra_25)
print(infra_2025.head())


len(set(infra_2025.columns) & 
    set(infra_2024.columns) &
    set(infra_2023.columns) &
    set(infra_2022.columns))

from functools import reduce
import pandas as pd

dfs = [infra_2021, 
       infra_2022, 
       infra_2023, 
       infra_2024, 
       infra_2025]


anos = range(2021,2025)

infra = {2021: infra_2021,
         2022: infra_2022,
         2023: infra_2023,
         2024: infra_2024,
         2025: infra_2025}

for i in range(2021, 2026):
    print(f"Año: {i}")
    print(infra[i]['FECHA_INICIO_TENENCIA'].dtype)

for i in range(2021, 2026):
    infra[i]['FECHA_INICIO_TENENCIA']=infra[i]['FECHA_INICIO_TENENCIA'].astype(str)

reduce(lambda left, right: pd.merge(left, right, how='outer'), dfs)

infra_2021['TOTAL_M2_EDIFICADOS'].info()