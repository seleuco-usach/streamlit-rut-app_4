# -*- coding: utf-8 -*-
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd

# Configurar el alcance y credenciales
scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
credentials = ServiceAccountCredentials.from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-4bb0ff85e8a2.json', scope)
client = gspread.authorize(credentials)
#jose-hoyos-usach-cl@bamboo-sweep-465617-i4.iam.gserviceaccount.com 
# Abrir la hoja de cálculo por ID
spreadsheet = client.open_by_key('1NpUYt-BrNSkli5YL9JTQz9WdeL0WtGbjytKDrQh114M')
credentials = ServiceAccountCredentials.\
from_json_keyfile_name('/home/xenomorfo/Descargas/bamboo-sweep-465617-i4-06b9bd6f36a5.json', scope)
client = gspread.authorize(credentials)
#jose-hoyos-usach-cl@bamboo-sweep-465617-i4.iam.gserviceaccount.com 
# Abrir la hoja de cálculo por ID
spreadsheet = client.open_by_key('1NpUYt-BrNSkli5YL9JTQz9WdeL0WtGbjytKDrQh114M')
worksheet = spreadsheet.get_worksheet(6)  # índice 0 es la primera hoja
data = worksheet.get_all_values()

# Convertir a DataFrame
PAC_CARGA= pd.DataFrame(data[1:], columns=data[0])

pd.set_option('display.max_columns', None)

print(PAC_CARGA.head())
while True:
    rut_buscado=input("Ingresa rut:")
    if rut_buscado=="Salir":
        break
    campo_extra=input("Ingresa campo:")
    if rut_buscado in PAC_CARGA['rut'].values:
        print(PAC_CARGA.loc[PAC_CARGA['rut']==rut_buscado, 
                              ['rut', 
                               'apellido_paterno', 
                               'apellido_materno',
                               'sexo',
                               'fecha_de_nacimiento', campo_extra]])
    else: print("no encontrado")


####No hay datos perdidos
tabla_na=PAC_CARGA.isnull().sum()
PAC_CARGA.columns

PAC_CARGA[PAC_CARGA['cod_unidad_desemp'] == ''].sum()
PAC_CARGA[PAC_CARGA['cod_unidad_desemp']].eq('').sum()

reg_blanco=PAC_CARGA[PAC_CARGA['cod_unidad_desemp'] == ''].eq('').sum()


campos_pac=[PAC_CARGA.columns]

lista_blancos = []
for i in campos_pac:
    resultado=(PAC_CARGA[i] == '').sum()
    resultado=[resultado]
    
lista_blancos