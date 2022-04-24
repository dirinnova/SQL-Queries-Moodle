SELECT DISTINCT u.id profesores
,u.username, u.firstname nombres, u.lastname apellidos, u.email email, c.fullname curso,
(select cat.name from mdl_course_categories cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) nivel,
 (select cat.name from mdl_course_categories cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) Facultad

FROM mdl_course c
INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
INNER JOIN mdl_role r ON r.id = ra.roleid
INNER JOIN mdl_user u ON u.id = ra.userid
INNER JOIN mdl_course_categories cc on c.category = cc.id
WHERE r.shortname = "editingteacher"

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
AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11) /* EC */
Order BY c.id asc