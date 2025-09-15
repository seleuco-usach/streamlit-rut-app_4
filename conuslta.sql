
        SELECT 
                m.rut, 
                m.nombres,
                m.ap_paterno,
                m.sexo,
                m.nacionalidad,
                m.cod_plan,
                m.carrera_programa,
                LEFT(periodo_matricula, 4) AS ANHO_MAT,
                CODIGO_CARRERA=cod_carr_prog,
                LEFT(ingreso_plan, 4) AS ANHO_ING,
                CONCAT(m.rut, '-',LEFT(m.ingreso_plan, 4)) AS ID,
                CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan) AS RUT_ANHO_PLAN,
                CONCAT(LEFT(ingreso_plan, 4), '-',cod_plan) AS ANHO_PLAN,
                CONCAT(c.SIES, '-', m.rut) AS SIES_RUT,
                CONCAT(LEFT(m.ingreso_plan, 4),'-' ,c.SIES, '-', m.rut) AS ANHO_SIES_RUT,
                m.via_ingreso,
                m.cod_via,
                m.region,
                m.fecha_nac,
                d.GRUPO_DEPENDENCIA,
                d.INGRESO_PERCAPITA_GRUPO_FA,
                d.PUNTAJE_PONDERADO,
                d.MATEMATICA,
                d.COMP_LECT,
                c.SIES,
                o.Tipo_Carrera,
                o.Jornada,
                o.[Cine-F_13_Área],
                o.Duración_Total,
                o.Nivel_Carrera,
                g.GRATUIDAD,
                f.TIPO AS CAE,
                h.TIPO AS FSCU,
                cc.COD_FAC,
                cc.FACULTAD,
                cc.COD_DEPTO,
                cc.Columna2 AS depto,
                mu.NAC,
                COUNT(m.rut) AS Total
            FROM MATRICULA_V2_082025_PARA_TODO m
            LEFT JOIN DEMRE_E_2014_2025 d 
            ON CONCAT(m.rut, '-',LEFT(m.ingreso_plan, 4))=d.ID_ANHO
            LEFT JOIN CPP_DR c
            ON CONCAT(LEFT(periodo_matricula,4), '-',m.cod_plan)=c.ANHO_PLAN
            LEFT JOIN OA_SIES_2010_2025_USACH o
            ON CONCAT(c.ANHO, '_', c.SIES)=o.llave
            LEFT JOIN tb_gratuidad g
            ON CONCAT(m.rut, '-',LEFT(m.ingreso_plan, 4))=CONCAT(g.Rut,'-',g.AÑO)
            LEFT JOIN cae f
            ON CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan)=CONCAT(f.RUN, '-',f.AÑO_ING,'-', f.CODIGO_PLAN)
            LEFT JOIN fscu h
            ON CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan)=CONCAT(h.RUN, '-',h.AÑO_ING,'-', h.CODIGO_PLAN)
            LEFT JOIN centro_costo cc
            ON cod_carr_prog = [COD CARRERA]
            LEFT JOIN TABLA_MU mu
            ON CONCAT(LEFT(m.ingreso_plan, 4),'-' ,c.SIES, '-', m.rut) = CONCAT(mu.ANHO_MU, '-', mu.COD_SIES,'-', mu.N_DOC)
            GROUP BY
                m.rut,
                m.nombres,
                m.ap_paterno,
                m.sexo,
                m.nacionalidad,
                m.cod_plan,
                m.carrera_programa,
                LEFT(periodo_matricula, 4),
                CONCAT(m.rut, LEFT(m.ingreso_plan, 4)),
                CONCAT(m.rut, '-', LEFT(m.ingreso_plan, 4), '-', m.cod_plan),
                m.cod_carr_prog,
                CONCAT(LEFT(ingreso_plan, 4), '-',cod_plan),
                CONCAT(ANHO, '_', SIES),
                CONCAT(c.SIES, '-', m.rut),
                CONCAT(LEFT(m.ingreso_plan, 4),'-',c.SIES, '-', m.rut),
                m.ingreso_plan,
                m.via_ingreso,
                m.region,
                m.fecha_nac,
                d.GRUPO_DEPENDENCIA,
                d.INGRESO_PERCAPITA_GRUPO_FA,
                d.PUNTAJE_PONDERADO,
                d.MATEMATICA,
                d.COMP_LECT,
                c.SIES,
                o.Tipo_Carrera,
                o.Jornada,
                o.[Cine-F_13_Área],
                o.Duración_Total,
                o.Nivel_Carrera,
                g.GRATUIDAD,
                f.TIPO,
                h.TIPO,
                cc.COD_FAC,
                cc.FACULTAD,
                cc.COD_DEPTO,
                cc.Columna2,
                m.cod_via,
                mu.NAC


SELECT * FROM CPP_DR