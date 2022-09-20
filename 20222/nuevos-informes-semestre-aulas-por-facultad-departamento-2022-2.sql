/* Nuevos informes semestre Aulas por Facultad - Departamento 2022-2 */
SELECT DISTINCT ccc.name AS "ID DEPA", "2022" AS "AÑO","II" AS "PERIODO/SEMESTRE",
REPLACE((SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')),"Facultad de ","") AS "FACULTAD/DEPENDENCIA",
IF(ccc.depth != 2,ccc.name,"No Aplica") AS "DEPARTAMENTO/PROGRAMA",

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
        (
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 5 /* Facultad de Derecho */
            OR
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 1511 /* Si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
            OR
            (
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
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
        )
    )   

    AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2) /* PREGRADO */
    AND 
    (
        ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
        OR 
        ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name) /* Departamento/programa */
    )
    AND r.shortname = "student"
    ORDER BY c.id ASC
) AS "PREGRADO",

(
    SELECT COUNT(DISTINCT c.id) AS "Aulas activas posgrado"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc ON c.category = cc.id
    INNER JOIN mdl_enrol e ON e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id AND ue.enrolid = e.id
    WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-06-18"
    AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6) /* POSGRADO */
    AND 
    (
        ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
        OR 
        ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name) /* Departamento/programa */
    )
    ORDER BY c.id ASC
) AS "POSGRADO",

(
    SELECT COUNT(DISTINCT c.id) AS "Aulas activas ec"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc ON c.category = cc.id
    INNER JOIN mdl_enrol e ON e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id AND ue.enrolid = e.id
    WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-06-18"
    AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EDUCACIÓN CONTINUADA */
    AND 
    (
        ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
        OR 
        ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name) /* Departamento/programa */
    )
    ORDER BY c.id ASC
) AS "EDUCACIÓN CONTINUADA",

DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"

FROM mdl_course_categories ccc
WHERE
(ccc.depth = 2 OR ccc.depth = 3)
AND
(
    REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    OR 
    REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
    OR 
    REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 11 /* EDUCACIÓN CONTINUADA */
)
AND /* Se evita que se enlisten Departamentos o programas con cero "0" aulas activas en todos los niveles */
(
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
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 5 /* Facultad de Derecho */
                OR
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 1511 /* Si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
                OR
                (
                    (
                        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
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
            )
        )   

        AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2) /* PREGRADO */
        AND 
        (
            ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
            OR 
            ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name) /* Departamento/programa */
        )
        AND r.shortname = "student"
        ORDER BY c.id ASC
    ) != 0
    OR
    (
        SELECT COUNT(DISTINCT c.id) AS "Aulas activas posgrado"
        FROM mdl_course c
        INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
        INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
        INNER JOIN mdl_role r ON r.id = ra.roleid
        INNER JOIN mdl_user u ON u.id = ra.userid
        INNER JOIN mdl_course_categories cc ON c.category = cc.id
        INNER JOIN mdl_enrol e ON e.courseid =c.id
        INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id AND ue.enrolid = e.id
        WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-06-18"
        AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6) /* POSGRADO */
        AND 
        (
            ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
            OR 
            ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name) /* Departamento/programa */
        )
        ORDER BY c.id ASC
    ) != 0
    OR
    (
        SELECT COUNT(DISTINCT c.id) AS "Aulas activas ec"
        FROM mdl_course c
        INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
        INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
        INNER JOIN mdl_role r ON r.id = ra.roleid
        INNER JOIN mdl_user u ON u.id = ra.userid
        INNER JOIN mdl_course_categories cc ON c.category = cc.id
        INNER JOIN mdl_enrol e ON e.courseid =c.id
        INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id AND ue.enrolid = e.id
        WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2022-06-18"
        AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EDUCACIÓN CONTINUADA */
        AND 
        (
            ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
            OR 
            ((SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name) /* Departamento/programa */
        )
        ORDER BY c.id ASC
    ) != 0
)

ORDER BY (SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')),ccc.name ASC