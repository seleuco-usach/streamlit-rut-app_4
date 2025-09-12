rut_buscado=int(input("Ingresa rut:"))


###busqueda rut
if rut_buscado in MAT['rut'].values:
    print(MAT.loc[MAT['rut']==rut_buscado, 
                              ['rut', 
                               'ANHO_ING',
                               'ANHO_MAT',
                               'fecha_nac',
                               'CODIGO_CARRERA',
                               'cod_plan',
                               'SIES']])
else: print("no encontrado")

