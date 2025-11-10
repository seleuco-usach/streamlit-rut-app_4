

from io import BytesIO
import requests
import pandas as pd



result = requests.get("https://mifuturo.cl/wp-content/uploads/2025/07/Matricula_2007_2025_WEB_15_07_2025.zip")
df = pd.read_csv(BytesIO(result.content),compression='zip', 
                 header=0, sep=';', 
                 quotechar='"', 
                 encoding='latin-1')
print(df)

df['anho'] = (
df['AÑO']
.str
.replace('MAT_', '', regex=True)
.astype(int)
)
       
mat = df[['anho',
          'CÓDIGO DE INSTITUCIÓN',
          'TOTAL MATRÍCULA', 
          'CARRERA CLASIFICACIÓN NIVEL 1',
          'TOTAL MATRÍCULA MUJERES']]

mat['anho'] = mat['anho'].astype(str)
mat['CÓDIGO DE INSTITUCIÓN'] = mat['CÓDIGO DE INSTITUCIÓN'].astype(str)

mat['id'] = mat['anho'] + '-' + mat['CÓDIGO DE INSTITUCIÓN']

mat_postgrado = mat[(mat['CARRERA CLASIFICACIÓN NIVEL 1'] == "Magister") |
    (mat['CARRERA CLASIFICACIÓN NIVEL 1'] == "Doctorado")]


mat_postgrado_agg_largo = (
mat_postgrado.groupby(['anho',
             'id',
             'CARRERA CLASIFICACIÓN NIVEL 1',
             'CÓDIGO DE INSTITUCIÓN'])['TOTAL MATRÍCULA']
.sum()
.reset_index()
)

mat_postgrado_ancho = mat_postgrado_agg_largo.pivot_table(
    index=['anho','id','CÓDIGO DE INSTITUCIÓN'],
    columns='CARRERA CLASIFICACIÓN NIVEL 1',
    values='TOTAL MATRÍCULA',
    fill_value=0
).reset_index()



mat_postgrado_ancho.to_clipboard()
