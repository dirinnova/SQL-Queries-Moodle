SELECT (@cnt := @cnt + 1) AS Id, (SELECT cat.name FROM mdl_course_categories cat where cat.id = ccc.parent) Nivel

,(
SELECT COUNT(distinct u.id) as "Estudiantes activos"
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
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
  
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name

Order BY c.id asc
) as "Estudiantes activos (sin repetir)",

(
SELECT COUNT(u.id) as "Inscripciones Estudiantes"
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
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
  
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name

Order BY c.id asc
) as "Incripciones estudiantes activos",

(
SELECT COUNT(DISTINCT u.id) profesores
FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
WHERE r.shortname = "editingteacher"
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
AND
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
AND
(SELECT count(cest.id) estudiantes
FROM mdl_course cest
INNER JOIN mdl_context ctxest ON ctxest.instanceid = cest.id
INNER JOIN mdl_role_assignments raest ON ctxest.id = raest.contextid
INNER JOIN mdl_role rest ON rest.id = raest.roleid
INNER JOIN mdl_user uest ON uest.id = raest.userid
INNER JOIN mdl_course_categories ccest on cest.category = ccest.id
inner join mdl_enrol eest on eest.courseid = cest.id
INNER JOIN mdl_user_enrolments ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
WHERE
(
DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND (rest.shortname = "student")
AND cest.id = c.id
Order BY cest.id asc) != 0
Order BY c.id asc
) as "Profesores activos (sin repetir)",




(SELECT COUNT(u.id) as "No Ingresaron"
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
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
Order BY c.id asc
) as "No Ingresaron",

(
(SELECT COUNT(u.id) as "Total Inscripciones Estudiantes"
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
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
Order BY c.id asc) -
(SELECT COUNT(u.id) as "No Ingresaron"
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
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
Order BY c.id asc)
) as "Total ingresos",

ROUND(
(((SELECT COUNT(u.id) as "Total Inscripciones Estudiantes"
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
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
Order BY c.id asc) -
(SELECT COUNT(u.id) as "No Ingresaron"
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
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
AND IF(FROM_UNIXTIME(u.lastaccess) < FROM_UNIXTIME(ue.timestart), "NUNCA", FROM_UNIXTIME(u.lastaccess)) = "NUNCA"
Order BY c.id asc)) * 100) /
(SELECT COUNT(u.id) as "Total Inscripciones Estudiantes"
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
DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y-%m-%d' ) >= "2020-12-16"
OR
(DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= "2021-01-01" AND
DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) <= "2021-06-30")
)
AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
Order BY c.id asc)
) as "%"



FROM mdl_course_categories ccc
CROSS JOIN (SELECT @cnt := 0) AS dummy
WHERE (ccc.parent = 2 /* PREGRADO */
OR ccc.parent = 6 /* POSGRADO */
OR ccc.parent = 11) /* EC */
ORDER BY (SELECT @cnt := 0),ccc.name ASC