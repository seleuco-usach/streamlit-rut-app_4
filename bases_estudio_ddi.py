

import pandas as pd
import numpy as np
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd

# Configurar el alcance y credenciales
scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
client = gspread.authorize(credentials)
#jose-hoyos-usach-cl@bamboo-sweep-465617-i4.iam.gserviceaccount.com 
# Abrir la hoja de cálculo por ID
spreadsheet = client.open_by_key('1Esxf-EdZGe71IGv_IOQhf3eRpTicYUueCHAQFvwA7bo')
credentials = ServiceAccountCredentials.\
from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
# Abrir la hoja de cálculo por ID


worksheet = spreadsheet.get_worksheet(0)  # índice 0 es la primera hoja
data = worksheet.get_all_values()[2:]

worksheet2 = spreadsheet.get_worksheet(1)  # índice 0 es la primera hoja
data2 = worksheet2.get_all_values()[2:]

# Convertir a DataFrame
bd_academicos_numero=pd.DataFrame(data[1:], columns=data[0])
bd_academicos_jce=pd.DataFrame(data2[1:], columns=data2[0])

bd_academicos_numero["anho"] = bd_academicos_numero["Periodo"].str[-4:]
bd_academicos_jce["anho"] = bd_academicos_jce["Periodo"].str[-4:]

bd_academicos_numero['id'] = bd_academicos_numero['anho'] + "-" + bd_academicos_numero['Código institución']
bd_academicos_jce['id'] = bd_academicos_jce['anho'] + "-" + bd_academicos_jce['Código institución']




bd_sies_doc=(
bd_academicos_numero
.merge(bd_academicos_jce,
                        on='id', 
                        how='left', 
                        suffixes=('_numero','_jce'))
)



shimago = client.open_by_key('1j6jUDHaNNmeeG8to0TXQ_iEKjcs4xZ_Q9XoH7WieRo8')
credentials = ServiceAccountCredentials.\
from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)

worksheet3 = shimago.get_worksheet(1)
data3 = worksheet3.get_all_values()# índice 0 es la primera hoja

bd_shimago=pd.DataFrame(data3[1:], columns=data3[0])


bd_shimago['id'] = bd_shimago['Año'] + "-" + bd_shimago['cod_inst']


bd_sies_shimago=bd_sies_doc.merge(
        bd_shimago,
                 on='id', 
                 how='left', 
                 suffixes=('_sies', '_shimago'))



bd_sies_shimago['Total Mujeres_numero'].dtype
bd_academicos_numero['Total Mujeres'].dtype

#bd_sies_shimago['Total Mujeres_numero']=(
#    bd_sies_shimago['Total Mujeres_numero']
#.str.replace('.', '', regex=False) 
#)

#bd_sies_shimago['Total Mujeres_numero']=(
#    bd_sies_shimago['Total Mujeres_numero']
#.str.replace('.', '', regex=False) 
#)


#for col in bd_sies_shimago.columns[bd_sies_shimago
 #        .columns
  #       .str
   #      .contains("numero",regex=True)]:
    #bd_sies_shimago[col] = (
     #   bd_sies_shimago[col]
      #  .astype(str)
       # .str.replace(',', '', regex=False)
    #)


(
bd_sies_shimago[bd_sies_shimago['universidad']=="1"]
.to_csv("bd_sies_shimago.csv", 
        index=False)
)




bd_sies_shimago[bd_sies_shimago['universidad']=="1"].to_csv(
    "bd_sies_shimago.csv",
    index=False,
    sep=',',   # usa punto y coma para separar columnas
    decimal='.',  # fuerza que los decimales sean con punto
    float_format="%.0f"
)



pd.DataFrame(bd_sies_shimago.columns).to_clipboard()