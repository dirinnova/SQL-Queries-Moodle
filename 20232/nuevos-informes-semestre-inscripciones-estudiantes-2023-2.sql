/* Nuevos informes semestre Inscripciones - Estudiantes 2023-2 */
SELECT (@cnt := @cnt + 1) AS "ID", t.facultaddependencia AS "FACULTAD/DEPENDENCIA", t.aniosemestre AS "AÑO/SEMESTRE", t.inscripciones AS "INSCRIPCIONES", t.estudiantes AS "ESTUDIANTES",t.fechacortedatos AS "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"
FROM 
(
    SELECT DISTINCT ccc.name AS idfacultades, REPLACE(ccc.name,"Facultad de ","") AS facultaddependencia,"2023-II" AS aniosemestre,

    (
        SELECT COUNT(u.id) AS "Inscripciones Estudiantes"
        FROM mdl_course c
        INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
        INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
        INNER JOIN mdl_role r ON r.id = ra.roleid
        INNER JOIN mdl_user u ON u.id = ra.userid
        INNER JOIN mdl_course_categories cc ON c.category = cc.id
        INNER JOIN mdl_enrol e ON e.courseid =c.id
        INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id AND ue.enrolid = e.id
        WHERE

        IF(  /* Condicional */
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
            AND
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 5 /* Si es de la Facultad de Derecho */
                OR
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 1511 /* Si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
                OR
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '') = 968 /* o si son Examenes de Clasificación de la Facultad de Derecho */
                OR
                (
                    (
                        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Si es del Departamento de Matemáticas */
                        OR
                        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 374 /* Si es del Centro de Idiomas y Cultura */
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
                AND 
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
                    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
                )
            )
        )
        AND r.shortname = "student"
        AND 
        (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id
        = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')))
        = ccc.name
        ORDER BY c.id ASC
    ) AS inscripciones,
    
    (
        SELECT COUNT(DISTINCT u.id) AS "Estudiantes Activos"
        FROM mdl_course c
        INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
        INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
        INNER JOIN mdl_role r ON r.id = ra.roleid
        INNER JOIN mdl_user u ON u.id = ra.userid
        INNER JOIN mdl_course_categories cc ON c.category = cc.id
        INNER JOIN mdl_enrol e ON e.courseid =c.id
        INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id AND ue.enrolid = e.id
        WHERE

        IF(  /* Condicional */
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
            AND
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 5 /* Si es de la Facultad de Derecho */
                OR
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 1511 /* Si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
                OR
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '') = 968 /* o si son Examenes de Clasificación de la Facultad de Derecho */
                OR
                (
                    (
                        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Si es del Departamento de Matemáticas */
                        OR
                        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 374 /* Si es del Centro de Idiomas y Cultura */
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
                AND 
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
                    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
                )
            )
        )
        AND r.shortname = "student"
        AND 
        (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id
        = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')))
        = ccc.name
        ORDER BY c.id ASC
    ) AS estudiantes,

    DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS fechacortedatos

    FROM mdl_course_categories ccc
    ,(SELECT 
    /* 
    -------------------------------------------------------------------------------------------------------------------------
    Estas fechas se deben actualizar cada semestre */

    @calAfechainicio := "2023-01-01", /* (año-mes-día) Fecha inicial del semestre calendario A en derecho pregrado (1 año duración) */
    @calAfechafin := "2024-01-30", /* (año-mes-día) Fecha final del semestre calendario A en derecho pregrado (1 año duración) */
    @calBfechainicio := "2023-06-18", /* (año-mes-día) Fecha inicial del semestre calendario B en derecho pregrado (1 año duración) */
    @calBfechafin := "2024-07-31", /* (año-mes-día) Fecha final del semestre calendario B en derecho pregrado (1 año duración) */
    @fechainiciosemestral := "2023-06-17" /* (año-mes-día) Fecha en la cual inicia el semestre del que se quiere sacar el reporte */

    /*  
    -------------------------------------------------------------------------------------------------------------------------
    */
    ) AS vars
    
    WHERE (ccc.parent = 2 /* PREGRADO */
    OR ccc.parent = 6 /* POSGRADO */
    OR ccc.parent = 11) /* EC */
    ORDER BY ccc.name ASC
) t
CROSS JOIN (SELECT @cnt := 0) AS dummy
ORDER BY (SELECT @cnt := 0) ASC