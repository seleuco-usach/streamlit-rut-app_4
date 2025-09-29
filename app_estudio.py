
import streamlit as st
import pandas as pd
import numpy as np

# Título
st.title("grafico prueba")

# Entrada de texto
#nombre = st.text_input("¿Cuál es tu nombre?", "Invitado")
st.write(f"grafico prueba")

# Generar y mostrar un gráfico
st.subheader("grafico prueba")


import pandas as pd
import numpy as np



tabla_estudio_2=pd.read_csv("bd_sies_shimago.csv")

ues_list=[70,86,87,20,71,89,90,88,76,31]

sigla_instituciones = {
    "PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE": "PUC",
    "PONTIFICIA UNIVERSIDAD CATOLICA DE VALPARAISO": "PUCV",
    "UNIVERSIDAD ADOLFO IBAÑEZ": "UAI",
    "UNIVERSIDAD ALBERTO HURTADO": "UAH",
    "UNIVERSIDAD ANDRES BELLO": "UNAB",
    "UNIVERSIDAD ARTURO PRAT": "UNAP",
    "UNIVERSIDAD AUSTRAL DE CHILE": "UACH",
    "UNIVERSIDAD AUTONOMA DE CHILE": "UA",
    "UNIVERSIDAD CATOLICA DE LA SANTISIMA CONCEPCION": "UCSC",
    "UNIVERSIDAD CATOLICA DE TEMUCO": "UCT",
    "UNIVERSIDAD CATOLICA DEL MAULE": "UCM",
    "UNIVERSIDAD CATOLICA DEL NORTE": "UCN",
    "UNIVERSIDAD DE ANTOFAGASTA": "UANTOF",
    "UNIVERSIDAD DE CHILE": "UCHILE",
    "UNIVERSIDAD DE CONCEPCION": "UDEC",
    "UNIVERSIDAD DE LA FRONTERA": "UFRO",
    "UNIVERSIDAD DE LA SERENA": "USERENA",
    "UNIVERSIDAD DE LOS ANDES": "UANDES",
    "UNIVERSIDAD DE LOS LAGOS": "ULAGOS",
    "UNIVERSIDAD DE PLAYA ANCHA DE CIENCIAS DE LA EDUCACION": "UPLA",
    "UNIVERSIDAD DE SANTIAGO DE CHILE": "USACH",
    "UNIVERSIDAD DE TALCA": "UTALCA",
    "UNIVERSIDAD DE TARAPACA": "UTA",
    "UNIVERSIDAD DE VALPARAISO": "UV",
    "UNIVERSIDAD DEL BIO-BIO": "UBIOBIO",
    "UNIVERSIDAD DEL DESARROLLO": "UDD",
    "UNIVERSIDAD DIEGO PORTALES": "UDP",
    "UNIVERSIDAD MAYOR": "UMAYOR",
    "UNIVERSIDAD SAN SEBASTIAN": "USS",
    "UNIVERSIDAD TECNICA FEDERICO SANTA MARIA": "USM",
    "UNIVERSIDAD METROPOLITANA DE CIENCIAS DE LA EDUCACION": "UMCE",
    "UNIVERSIDAD TECNOLOGICA METROPOLITANA": "UTEM",
    "UNIVERSIDAD ACADEMIA DE HUMANISMO CRISTIANO": "UAHC",
    "UNIVERSIDAD ADVENTISTA DE CHILE": "UNACH",
    "UNIVERSIDAD BERNARDO O'HIGGINS": "UBO",
    "UNIVERSIDAD BOLIVARIANA": "UBOLIVARIANA",
    "UNIVERSIDAD CATOLICA CARDENAL RAUL SILVA HENRIQUEZ": "UCSH",
    "UNIVERSIDAD CENTRAL DE CHILE": "UCEN",
    "UNIVERSIDAD DE ACONCAGUA": "UAC",
    "UNIVERSIDAD DE ATACAMA": "UATAMACA",
    "UNIVERSIDAD DE AYSEN": "UAYSEN",
    "UNIVERSIDAD DE LAS AMERICAS": "UDLA",
    "UNIVERSIDAD DE MAGALLANES": "UMAG",
    "UNIVERSIDAD DE O'HIGGINS": "UHO",
    "UNIVERSIDAD DE VIÑA DEL MAR": "UVM",
    "UNIVERSIDAD DEL ALBA": "UDALBA",
    "UNIVERSIDAD DEL PACIFICO": "UPACIFICO",
    "UNIVERSIDAD FINIS TERRAE": "FINIS",
    "UNIVERSIDAD GABRIELA MISTRAL": "UGM",
    "UNIVERSIDAD IBEROAMERICANA DE CIENCIAS Y TECNOLOGIA, UNICIT": "UNICIT",
    "UNIVERSIDAD LA REPUBLICA": "ULAREPUBLICA",
    "UNIVERSIDAD SANTO TOMAS": "UST",
    "UNIVERSIDAD SEK": "USEK",
    "UNIVERSIDAD TECNOLOGICA DE CHILE INACAP": "INACAP",
    "UNIVERSIDAD TECNOLOGICA METROPOLITANA (* CARRERA EN CONVENIO U. PACIFICO)": "UPACIFICO",
    "UNIVERSIDAD DE SANTIAGO DE CHILE (* CARRERA EN CONVENIO U. IBEROAMERICANA)": "UNICIT",
    "UNIVERSIDAD UCINF": "UCINF"
}

tabla_estudio_2['sigla']=tabla_estudio_2['Nombre institución_numero'].map(sigla_instituciones).fillna('OTRA')

tabla_estudio_2['ues_bench']=(
tabla_estudio_2['Código institución_numero'].isin(pd.Series(ues_list)
.unique()
.astype(int))
.astype(int)
)


tabla_estudio_2['Total Mujeres_numero'].dtype

tabla_estudio_agrupada=(tabla_estudio_2[tabla_estudio_2['ues_bench']==1]
                        .groupby(['anho_numero',
                                  'sigla'])
                        .agg({'Total Mujeres_numero': 'mean',
                              'Total Hombres_numero': 'mean',
                              '*Output*': 'mean'})
                        .reset_index()
)

tabla_estudio_agrupada = tabla_estudio_agrupada.sort_values(
    by="*Output*", 
    ascending=True   # pon False si quieres de mayor a menor
)

#import plotly.express as px
import altair as alt

#px.line(tabla_estudio, x='ANHO_ING', y=['ret_1', 
 #                                  'ret_2', 
  #                                 'ret_3']) 

#chart = alt.Chart(tabla_estudio_agrupada).mark_line().encode(
 #   x="ANHO_ING:O",
  #  y=alt.Y("value:Q"),
   # color="variable:N"
#).transform_fold(
 ##  as_=["variable", "value"]
#)


#chart = (
 #   alt.Chart(tabla_estudio_agrupada)
  #  .transform_fold(
   #      ["Total Mujeres_numero", "Total Hombres_numero"],
        #tabla_estudio_agrupada['Nombre institución_numero']
        #.unique()
        #.tolist(),
    #    as_=["variable", "value"]
    #)
    #.mark_line()
    #.encode(
    #    x="anho_numero:O",
     #   y=alt.Y("value:Q"),
      #  color="variable:N"
    #)
#)

metricas = {
    "Output": "*Output*",
    "Total Mujeres": "Total Mujeres_numero",
    "Total Hombres": "Total Hombres_numero"
}

opcion = st.selectbox("slecciona una metrica:", list(metricas.keys()))

metrica_sel = metricas[opcion]

chart = (
    alt.Chart(tabla_estudio_agrupada)
    .mark_circle(size=300)
    .encode(
        x="anho_numero:O",
        #y="*Output*:Q", 
        y=alt.Y(f"{metrica_sel}:Q", title=opcion),
        color="sigla:N",
        order=alt.Order("Output*:Q", sort="descending")
    )
)



st.altair_chart(chart, use_container_width=True)


#tabla_estudio_largo=tabla_estudio_agrupada.melt(id_vars=['ANHO_ING'], 
 #            value_vars=['ret_1', 'ret_2', 'ret_3'])

#tabla_estudio_largo_carr=tabla_estudio_agrupada_carr.melt(id_vars=['ANHO_ING', 
 #                                     'CODIGO_CARRERA_x', 'NIVEL_GLOBAL'], 
  #           value_vars=['ret_1', 'ret_2', 'ret_3'])

#ret_sel = st.radio("Selecciona la retención a visualizar:", 
 #        ('ret_1', 'ret_2', 'ret_3', "todo"), index=0)

#ret_sel_carr = st.selectbox("Selecciona la carrera a visualizar:", 
 #        tabla_estudio['CODIGO_CARRERA_x'].unique())



#st.line_chart(tabla_estudio)



#tabla_estudio_largo_filtrado=tabla_estudio_largo[tabla_estudio_largo['variable']==ret_sel]

#tabla_estudio_largo_filtrado_carr=tabla_estudio_largo_carr[(tabla_estudio_largo_carr['CODIGO_CARRERA_x']==ret_sel_carr)]

#chart_fil = alt.Chart(tabla_estudio_largo_filtrado_carr).mark_line().encode(
  #  x="ANHO_ING:O",
 #   y=alt.Y("value:Q", title = "Retención"),
   # color="variable:N"
#)

#st.altair_chart(chart_fil, use_container_width=True)

# Contador de clics
#if "contador" not in st.session_state:
#    st.session_state.contador = 0

#if st.button("¡Haz clic aquí!"):
#    st.session_state.contador += 1

#st.write(f"Has hecho clic **{st.session_state.contador}** veces.")

# Despedida
#st.markdown("---")
#st.write("Gracias por probar esta demo de Streamlit.")
