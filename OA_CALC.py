
from io import BytesIO
import requests
import pandas as pd

oa_histo = pd.read_csv("/home/xenomorfo/Documentos/ANALISTA ESTUDIOS/BBBDD SIES/OFERTA/OA_2010_2025.csv")


result = requests.get("https://mifuturo.cl/wp-content/uploads/2025/06/Oferta_Academica_2010_al_2025_SIES_02_06_2025_WEB_E.zip")
oa_histo = pd.read_csv(BytesIO(result.content),compression='zip', 
                 header=0, sep=';', 
                 quotechar='"', 
                 encoding='latin-1')
print(oa_histo)

(
oa_histo[oa_histo['Nivel Carrera']=="Doctorado"]
.groupby(['Año', 'Código Único'])
.size()
)

(
oa_histo[oa_histo['Nivel Carrera']=="Doctorado"]
.groupby(['Año', 
          'Código Único',
          'Nivel Carrera',
          'Vigencia'])
.size()
.reset_index(name='freq')
)


postgrado_prog = (
    oa_histo[(oa_histo['Nivel Carrera'] == "Doctorado") &
            (oa_histo['Vigencia'] == "Vigente con estudiantes nuevos")]
    .groupby([
        'Año',
        'Código IES',
        'Vigencia'
    ])['Código Único']
    .nunique()
    .reset_index(name='conteo_programas')
)

postgrado_prog['Año'] = postgrado_prog['Año'].str.replace("OFE_", "", regex=False)

postgrado_prog['Año'] = postgrado_prog['Año'].astype(str)
postgrado_prog['Código IES'] = postgrado_prog['Código IES'].astype(str)


postgrado_prog['id'] = postgrado_prog['Año'] + '-' +postgrado_prog['Código IES']

postgrado_prog.to_clipboard()