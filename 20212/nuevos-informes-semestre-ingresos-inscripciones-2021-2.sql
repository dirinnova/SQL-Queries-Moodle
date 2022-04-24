SELECT distinct ccc.name AS "ID","2021" AS "AÑO","II" AS "PERIODO/SEMESTRE",REPLACE(ccc.name,"Facultad de ","") as "FACULTAD/DEPENDENCIA",

IF(ccc.name = "Facultad de Derecho"
    OR ccc.name = "Departamento de Idiomas - FDE"
    OR ccc.name = "Departamento de Matemáticas",
(SELECT COUNT(u.id) as "Inscripciones Estudiantes"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student"
AND
(
    (
        (
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-01-30") /* PREGRADO CAL A */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* PREGRADO CAL B */
        )
        AND
        (
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') != 339 /* Diferente Departamento de Matemáticas */
            )
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
            )
        )
    )
    OR
    (
        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
        AND
        (
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
            OR
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
            )
        )
    )
)
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
Order BY c.id asc
),
(SELECT COUNT(u.id) as "Inscripciones Estudiantes"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student"
AND
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
Order BY c.id asc
)
) as "TOTAL INSCRIPCIONES",


IF(ccc.name = "Facultad de Derecho"
    OR ccc.name = "Departamento de Idiomas - FDE"
    OR ccc.name = "Departamento de Matemáticas",
(SELECT COUNT(u.id) as "No ingresaron"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student"
AND
(
    (
        (
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-01-30") /* PREGRADO CAL A */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* PREGRADO CAL B */
        )
        AND
        (
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') != 339 /* Diferente Departamento de Matemáticas */
            )
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
            )
        )
    )
    OR
    (
        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
        AND
        (
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
            OR
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
            )
        )
    )
)
AND
(select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
Order BY c.id asc
),
(SELECT COUNT(u.id) as "No ingresaron"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student"
AND
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
Order BY c.id asc
)
) as "NO INGRESARON",

(
IF(ccc.name = "Facultad de Derecho"
    OR ccc.name = "Departamento de Idiomas - FDE"
    OR ccc.name = "Departamento de Matemáticas",
(SELECT COUNT(u.id) as "Inscripciones Estudiantes"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student"
AND
(
    (
        (
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-01-30") /* PREGRADO CAL A */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* PREGRADO CAL B */
        )
        AND
        (
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') != 339 /* Diferente Departamento de Matemáticas */
            )
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
            )
        )
    )
    OR
    (
        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
        AND
        (
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
            OR
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
            )
        )
    )
)
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
Order BY c.id asc
),
(SELECT COUNT(u.id) as "Inscripciones Estudiantes"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student"
AND
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
Order BY c.id asc
)
) - 
IF(ccc.name = "Facultad de Derecho"
    OR ccc.name = "Departamento de Idiomas - FDE"
    OR ccc.name = "Departamento de Matemáticas",
(SELECT COUNT(u.id) as "No ingresaron"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student"
AND
(
    (
        (
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-01-30") /* PREGRADO CAL A */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* PREGRADO CAL B */
        )
        AND
        (
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') != 339 /* Diferente Departamento de Matemáticas */
            )
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
            )
        )
    )
    OR
    (
        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
        AND
        (
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
            OR
            REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                AND
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
            )
        )
    )
)
AND
(select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
Order BY c.id asc
),
(SELECT COUNT(u.id) as "No ingresaron"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student"
AND
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
Order BY c.id asc
)
)
) as "TOTAL INGRESOS",

ROUND
(
    (
    (
    IF(ccc.name = "Facultad de Derecho"
        OR ccc.name = "Departamento de Idiomas - FDE"
        OR ccc.name = "Departamento de Matemáticas",
    (SELECT COUNT(u.id) as "Inscripciones Estudiantes"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc on c.category = cc.id
    inner join mdl_enrol e on e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
    WHERE r.shortname = "student"
    AND
    (
        (
            (
                (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-01-30") /* PREGRADO CAL A */
                OR 
                (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* PREGRADO CAL B */
            )
            AND
            (
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') != 339 /* Diferente Departamento de Matemáticas */
                )
                OR
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
                )
            )
        )
        OR
        (
            DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
            AND
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
                OR
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
                OR
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                    AND
                    INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
                )
            )
        )
    )
    AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    Order BY c.id asc
    ),
    (SELECT COUNT(u.id) as "Inscripciones Estudiantes"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc on c.category = cc.id
    inner join mdl_enrol e on e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
    WHERE r.shortname = "student"
    AND
    DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
    AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */
    AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    Order BY c.id asc
    )
    ) - 
    IF(ccc.name = "Facultad de Derecho"
        OR ccc.name = "Departamento de Idiomas - FDE"
        OR ccc.name = "Departamento de Matemáticas",
    (SELECT COUNT(u.id) as "No ingresaron"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc on c.category = cc.id
    inner join mdl_enrol e on e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
    WHERE r.shortname = "student"
    AND
    (
        (
            (
                (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-01-30") /* PREGRADO CAL A */
                OR 
                (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* PREGRADO CAL B */
            )
            AND
            (
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') != 339 /* Diferente Departamento de Matemáticas */
                )
                OR
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
                )
            )
        )
        OR
        (
            DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
            AND
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
                OR
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
                OR
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                    AND
                    INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
                )
            )
        )
    )
    AND
    (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
    Order BY c.id asc
    ),
    (SELECT COUNT(u.id) as "No ingresaron"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc on c.category = cc.id
    inner join mdl_enrol e on e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
    WHERE r.shortname = "student"
    AND
    DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
    AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */
    AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
    Order BY c.id asc
    )
    )
    )
     * 100 ) / 
    IF(ccc.name = "Facultad de Derecho"
        OR ccc.name = "Departamento de Idiomas - FDE"
        OR ccc.name = "Departamento de Matemáticas",
    (SELECT COUNT(u.id) as "Inscripciones Estudiantes"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc on c.category = cc.id
    inner join mdl_enrol e on e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
    WHERE r.shortname = "student"
    AND
    (
        (
            (
                (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-01-30") /* PREGRADO CAL A */
                OR 
                (DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* PREGRADO CAL B */
            )
            AND
            (
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') != 339 /* Diferente Departamento de Matemáticas */
                )
                OR
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
                )
            )
        )
        OR
        (
            DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
            AND
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
                OR
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
                OR
                (
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
                    AND
                    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                    AND
                    INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
                )
            )
        )
    )
    AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    Order BY c.id asc
    ),
    (SELECT COUNT(u.id) as "Inscripciones Estudiantes"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc on c.category = cc.id
    inner join mdl_enrol e on e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
    WHERE r.shortname = "student"
    AND
    DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
    AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */
    AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    Order BY c.id asc
    )
    )
) as "%"


FROM mdl_course_categories ccc
WHERE (ccc.parent = 2 /* PREGRADO */
OR ccc.parent = 6 /* POSGRADO */
OR ccc.parent = 11) /* EC */
ORDER BY ccc.name ASC