SELECT distinct ccc.name as "ID DEPA", "2021" as "AÑO","II" as "PERIODO/SEMESTRE" ,REPLACE((select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')),"Facultad de ","") as "FACULTAD/DEPENDENCIA", IF(ccc.depth != 2,ccc.name,"No Aplica") as "DEPARTAMENTO/PROGRAMA",

IF((select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')) = "Facultad de Derecho"
    OR (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')) = "Departamento de Idiomas - FDE"
    OR (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')) = "Departamento de Matemáticas"
    ,
(SELECT COUNT(distinct c.id) as "Aulas activas derecho"
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
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        (
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 5 /* Facultad de Derecho */
            )
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 795 /* Departamento de Idiomas - FDE */
            )
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
            )
        )
        AND
        (
            (
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
                AND
                cc.depth = 2
            ) /* Facultad/dependencia */
            OR
            (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name
            /* Departamento/programa */
        )
    )
    OR
    (
        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
        AND
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
        AND
        INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
        AND
        (
            (
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
                AND
                cc.depth = 2
            ) /* Facultad/dependencia */
            OR
            (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name
            /* Departamento/programa */
        )
    )
)
Order BY c.id asc
),
(SELECT COUNT(distinct c.id) as "Aulas activas"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2) /* PREGRADO */

AND (((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
  OR ((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name)) /* Departamento/programa */
 
Order BY c.id asc
)
) as "PREGRADO",

(SELECT COUNT(distinct c.id) as "Aulas activas posgrado"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6) /* POSGRADO */

AND (((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
  OR ((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name)) /* Departamento/programa */

Order BY c.id asc
) as "POSGRADO",

(SELECT COUNT(distinct c.id) as "Aulas activas ec"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EDUCACIÓN CONTINUADA */

AND (((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
  OR ((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name)) /* Departamento/programa */

Order BY c.id asc
) as "EDUCACIÓN CONTINUADA"


FROM mdl_course_categories ccc
WHERE
(ccc.depth = 2 OR ccc.depth = 3) AND
 (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */

AND
(
IF((select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')) = "Facultad de Derecho"
    OR (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')) = "Departamento de Idiomas - FDE"
    OR (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')) = "Departamento de Matemáticas"
    ,
(SELECT COUNT(distinct c.id) as "Aulas activas derecho"
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
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        (
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 5 /* Facultad de Derecho */
            )
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 795 /* Departamento de Idiomas - FDE */
            )
            OR
            (
                REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
                AND
                INSTR(lower(c.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
            )
        )
        AND
        (
            (
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
                AND
                cc.depth = 2
            ) /* Facultad/dependencia */
            OR
            (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name
            /* Departamento/programa */
        )
    )
    OR
    (
        DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
        AND
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '') = 339 /* Departamento de Matemáticas */
        AND
        INSTR(lower(c.fullname),"derecho") = 0 /* Aula que no es de la Facultad de Derecho */
        AND
        (
            (
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
                AND
                cc.depth = 2
            ) /* Facultad/dependencia */
            OR
            (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name
            /* Departamento/programa */
        )
    )
)
Order BY c.id asc
),
(SELECT COUNT(distinct c.id) as "Aulas activas"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2) /* PREGRADO */

AND (((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
  OR ((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name)) /* Departamento/programa */
 
Order BY c.id asc
)
) != 0 OR
(SELECT COUNT(distinct c.id) as "Aulas activas posgrado"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6) /* POSGRADO */

AND (((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
  OR ((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name)) /* Departamento/programa */

Order BY c.id asc
) != 0 OR
(SELECT COUNT(distinct c.id) as "Aulas activas ec"
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
inner join mdl_enrol e on e.courseid =c.id
INNER JOIN mdl_user_enrolments ue on ue.userid = u.id and ue.enrolid = e.id
WHERE r.shortname = "student" AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2021-06-16"
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EDUCACIÓN CONTINUADA */

AND (((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name AND cc.depth = 2) /* Facultad/dependencia */
  OR ((select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", ''))) = ccc.name)) /* Departamento/programa */

Order BY c.id asc
) != 0
)

ORDER BY (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(ccc.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccc.path, "/", 3-1)) + 1),"/", '')),ccc.name ASC