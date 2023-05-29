/* Nuevos informes semestre Totales inscripciones y estudiantes 2023-1 */
SELECT "2023" AS "AÑO","I" AS "PERIODO/SEMESTRE",

(
    SELECT COUNT(DISTINCT c.id) AS "Aulas activas"
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
    ORDER BY c.id ASC
) AS "AULAS ACTIVAS"
,
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
    ORDER BY c.id ASC
) AS "INSCRIPCIONES"
,
(
    SELECT COUNT(distinct u.id) AS "Estudiantes activos"
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
    ORDER BY c.id ASC
) AS "ESTUDIANTES"
,
(
    SELECT COUNT(DISTINCT u.id) AS "Profesores"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc ON c.category = cc.id
    WHERE r.shortname = "editingteacher"
    AND
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        OR 
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
        OR 
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
    )
    AND
    (
        SELECT COUNT(cest.id) estudiantes
        FROM mdl_course cest
        INNER JOIN mdl_context ctxest ON ctxest.instanceid = cest.id
        INNER JOIN mdl_role_assignments raest ON ctxest.id = raest.contextid
        INNER JOIN mdl_role rest ON rest.id = raest.roleid
        INNER JOIN mdl_user uest ON uest.id = raest.userid
        INNER JOIN mdl_course_categories ccest ON cest.category = ccest.id
        INNER JOIN mdl_enrol eest ON eest.courseid = cest.id
        INNER JOIN mdl_user_enrolments ueest ON ueest.userid = uest.id AND ueest.enrolid = eest.id
        WHERE

        IF(
            REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
            AND
            (        
                (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho" /* Si es de la facultad de derecho */
                OR
                (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas" /* o si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
                OR
                (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", ''))) = "Facultad de Derecho" /* o si son Examenes de Clasificación de la Facultad de Derecho */
                OR
                (
                    (
                        (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas" /* o si es del departamento de matematicas */
                        OR
                        (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Centro de Idiomas y Cultura" /* o si es del Centro de Idiomas y Cultura */
                    )
                    AND
                    INSTR(LOWER(cest.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
                )
            )
            ,
            ( /* aplican los filtros de fechas del calendario A y calendario B de Derecho */
                (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= @calAfechainicio AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= @calAfechafin) /* Pregrado Calendario A */
                OR 
                (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= @calBfechainicio AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= @calBfechafin) /* Pregrado Calendario B */
            )
            , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
            DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= @fechainiciosemestral
        )
        AND rest.shortname = "student"
        AND cest.id = c.id
        ORDER BY cest.id ASC
    ) != 0
    ORDER BY c.id ASC
) AS "PROFESORES"
,



DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"
FROM
(SELECT 
/* 
-------------------------------------------------------------------------------------------------------------------------
Estas fechas se deben actualizar cada semestre */

    @calAfechainicio := "2023-01-01", /* (año-mes-día) Fecha inicial del semestre calendario A en derecho pregrado (1 año duración) */
    @calAfechafin := "2024-01-30", /* (año-mes-día) Fecha final del semestre calendario A en derecho pregrado (1 año duración) */
    @calBfechainicio := "2022-06-18", /* (año-mes-día) Fecha inicial del semestre calendario B en derecho pregrado (1 año duración) */
    @calBfechafin := "2023-07-31", /* (año-mes-día) Fecha final del semestre calendario B en derecho pregrado (1 año duración) */
    @fechainiciosemestral := "2023-01-01", /* (año-mes-día) Fecha en la cual inicia el semestre del que se quiere sacar el reporte */
    @fechafotoinformes := DATE_FORMAT(CURDATE(), '%Y-%m-%d') /* (año-mes-día) Fecha en la cual se tomará la foto para las base de datos de los informes y la actualización de nuestra página.  */

/*  
-------------------------------------------------------------------------------------------------------------------------
*/
) AS vars
