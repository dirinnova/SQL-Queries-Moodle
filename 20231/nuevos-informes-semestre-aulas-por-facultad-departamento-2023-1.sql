/* Nuevos informes semestre Aulas por Facultad - Departamento 2023-1 */
SELECT (@cnt := @cnt + 1) AS Id,t.anio AS "AÑO",t.periodosemestre AS "PERIODO/SEMESTRE",t.facultaddependencia AS "FACULTAD/DEPENDENCIA",t.departamentoprograma AS "DEPARTAMENTO/PROGRAMA",t.pregrado AS "PREGRADO",t.posgrado AS "POSGRADO",t.educacioncontinuada AS "EDUCACIÓN CONTINUADA",t.fechacortedatos AS "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"

FROM 
(
    SELECT CONCAT(REPLACE((SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')),"Facultad de ",""),"-",ccc.name) AS idepa, "2023" AS anio,"I" AS periodosemestre,
    REPLACE((SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')),"Facultad de ","") AS facultaddependencia,
    IF(ccc.depth != 2,ccc.name,"No Aplica") AS departamentoprograma,

    COUNT(
        DISTINCT(
            CASE WHEN 
            (
                IF(  /* Condicional */
                    (
                        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '') = 5 /* Facultad de Derecho */
                        OR
                        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '') = 1511 /* Si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
                        OR
                        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 4-1)) + 1),"/", '') = 968 /* o si son Examenes de Clasificación de la Facultad de Derecho */
                        OR
                        (
                            (
                                REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                                OR
                                REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '') = 374 /* Si es del Centro de Idiomas y Cultura */
                            )
                            AND
                            INSTR(LOWER(c.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
                        )
                    )
                    ,
                    ( /* aplican los filtros de fechas del calendario A y calendario B de Derecho */
                        (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @calAfechainicio AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= @calAfechafin) /* Pregrado Calendario A */
                        OR 
                        (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @calBfechainicio AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= @calBfechafin) /* Pregrado Calendario B */
                    )
                    , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
                    (
                        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @fechainiciosemestral
                    )
                )   
                AND
                (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 2) /* PREGRADO */
            )
            THEN c.id END
        )
    ) AS pregrado,

    COUNT(
        DISTINCT(
            CASE WHEN 
            (
                DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @fechainiciosemestral
                AND
                (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 6) /* POSGRADO */
            )
            THEN c.id END
        )
    ) AS posgrado,

    COUNT(
        DISTINCT(
            CASE WHEN 
            (
                DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @fechainiciosemestral
                AND
                (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 11) /* EDUCACIÓN CONTINUADA */
            )
            THEN c.id END
        )
    ) AS educacioncontinuada,

    DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS fechacortedatos

    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories ccc ON c.category = ccc.id
    INNER JOIN mdl_enrol e ON e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id AND ue.enrolid = e.id
    ,(SELECT 
    /* 
    -------------------------------------------------------------------------------------------------------------------------
    Estas fechas se deben actualizar cada semestre */

        @calAfechainicio := "2023-01-01", /* (año-mes-día) Fecha inicial del semestre calendario A en derecho pregrado (1 año duración) */
        @calAfechafin := "2024-01-30", /* (año-mes-día) Fecha final del semestre calendario A en derecho pregrado (1 año duración) */
        @calBfechainicio := "2022-06-18", /* (año-mes-día) Fecha inicial del semestre calendario B en derecho pregrado (1 año duración) */
        @calBfechafin := "2023-07-31", /* (año-mes-día) Fecha final del semestre calendario B en derecho pregrado (1 año duración) */
        @fechainiciosemestral := "2023-01-01" /* (año-mes-día) Fecha en la cual inicia el semestre del que se quiere sacar el reporte */

    /*  
    -------------------------------------------------------------------------------------------------------------------------
    */
    ) AS vars

    WHERE
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        OR 
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
        OR 
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 11 /* EDUCACIÓN CONTINUADA */
    )
    AND r.shortname = "student"

    GROUP BY CONCAT(REPLACE((SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')),"Facultad de ",""),"-",ccc.name)

    HAVING 
    (
        (
            COUNT(
                DISTINCT(
                    CASE WHEN 
                    (
                        IF(  /* Condicional */
                            (
                                REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '') = 5 /* Facultad de Derecho */
                                OR
                                REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '') = 1511 /* Si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
                                OR
                                REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 4-1)) + 1),"/", '') = 968 /* o si son Examenes de Clasificación de la Facultad de Derecho */
                                OR
                                (
                                    (
                                        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                                        OR
                                        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '') = 374 /* Si es del Centro de Idiomas y Cultura */
                                    )
                                    AND
                                    INSTR(LOWER(c.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
                                )
                            )
                            ,
                            ( /* aplican los filtros de fechas del calendario A y calendario B de Derecho */
                                (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @calAfechainicio AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= @calAfechafin) /* Pregrado Calendario A */
                                OR 
                                (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @calBfechainicio AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= @calBfechafin) /* Pregrado Calendario B */
                            )
                            , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
                            (
                                DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @fechainiciosemestral
                            )
                        )   
                        AND
                        (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 2) /* PREGRADO */
                    )
                    THEN c.id END
                )
            )
        ) != 0 /* PREGRADO */
        OR
        (
            COUNT(
                DISTINCT(
                    CASE WHEN 
                    (
                        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @fechainiciosemestral
                        AND
                        (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 6) /* POSGRADO */
                    )
                    THEN c.id END
                )
            )
        ) != 0 /* POSGRADO */
        OR
        (
            COUNT(
                DISTINCT(
                    CASE WHEN 
                    (
                        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= @fechainiciosemestral
                        AND
                        (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 11) /* EDUCACIÓN CONTINUADA */
                    )
                    THEN c.id END
                )
            )
        ) != 0 /* EDUCACIÓN CONTINUADA */
    ) /* Se evita que se enlisten Departamentos o programas con cero "0" aulas activas en todos los niveles */

    ORDER BY (SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')),ccc.name ASC
) t
CROSS JOIN (SELECT @cnt := 0) AS dummy
ORDER BY (SELECT @cnt := 0) ASC