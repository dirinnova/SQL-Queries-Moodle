/* Nuevos informes semestre Inscripciones - Estudiantes 2022-2 */
SELECT DISTINCT ccc.name AS "ID", REPLACE(ccc.name,"Facultad de ","") AS "FACULTAD/DEPENDENCIA","2022-II" AS "AÑO/SEMESTRE",

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
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2023-01-30") /* Pregrado Calendario A 2022-2023 */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-06-18" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2023-07-31") /* Pregrado Calendario B 2022-2023 */
        )
        , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
        (
            DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-06-18"
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
) AS "INSCRIPCIONES"
,
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
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2023-01-30") /* Pregrado Calendario A 2022-2023 */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-06-18" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2023-07-31") /* Pregrado Calendario B 2022-2023 */
        )
        , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
        (
            DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-06-18"
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
) AS "ESTUDIANTES"
,

DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"

FROM mdl_course_categories ccc
WHERE (ccc.parent = 2 /* PREGRADO */
OR ccc.parent = 6 /* POSGRADO */
OR ccc.parent = 11) /* EC */
ORDER BY ccc.name ASC