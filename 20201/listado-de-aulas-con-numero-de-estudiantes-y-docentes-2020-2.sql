SELECT c.id Id_curso, c.fullname Curso, c.shortname NombreCorto,

 (SELECT count(cest.id) estudiantes FROM {course} cest
INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
INNER JOIN {user} uest ON uest.id = raest.userid
INNER JOIN {course_categories} ccest on cest.category = ccest.id
inner join {enrol} eest on eest.courseid =cest.id
INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
WHERE 
(
DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2020-07-02"
OR
(
DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2019-06-01" AND
DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= "2020-07-02"
)
)

AND (rest.shortname = "student")
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc) "Estudiantes inscritos desde 01 Julio 2020",

 (SELECT count(cest.id) estudiantes FROM {course} cest
INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
INNER JOIN {user} uest ON uest.id = raest.userid
INNER JOIN {course_categories} ccest on cest.category = ccest.id
inner join {enrol} eest on eest.courseid =cest.id
INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
WHERE DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= CURDATE() 
AND (rest.shortname = "student")
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc) Estudiantes_activos,

 (SELECT count(cest.id) estudiantes FROM {course} cest
INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
WHERE rest.shortname = "student"
AND cest.id = c.id
Order BY cest.id asc) Estudiantes,
  
(SELECT GROUP_CONCAT(CONCAT(upro.firstname, " ",upro.lastname) SEPARATOR ' / ') as Profesor
 FROM {course} cpro
INNER JOIN {context} ctxpro ON ctxpro.instanceid = cpro.id
INNER JOIN {role_assignments} rapro ON ctxpro.id = rapro.contextid
INNER JOIN {role} rpro ON rpro.id = rapro.roleid
INNER JOIN {user} upro ON upro.id = rapro.userid
INNER JOIN {course_categories} ccpro on cpro.category = ccpro.id
inner join {enrol} epro on epro.courseid =cpro.id
INNER JOIN {user_enrolments} uepro on uepro.userid = upro.id and uepro.enrolid = epro.id
WHERE (rpro.shortname = "teacher" OR rpro.shortname = "editingteacher")
AND cpro.id = c.id
GROUP BY cpro.id
Order BY cpro.id asc) Profesor,
   
(SELECT GROUP_CONCAT(CONCAT(upro.email) SEPARATOR ' / ') as Profesor
 FROM {course} cpro
INNER JOIN {context} ctxpro ON ctxpro.instanceid = cpro.id
INNER JOIN {role_assignments} rapro ON ctxpro.id = rapro.contextid
INNER JOIN {role} rpro ON rpro.id = rapro.roleid
INNER JOIN {user} upro ON upro.id = rapro.userid
INNER JOIN {course_categories} ccpro on cpro.category = ccpro.id
inner join {enrol} epro on epro.courseid =cpro.id
INNER JOIN {user_enrolments} uepro on uepro.userid = upro.id and uepro.enrolid = epro.id
WHERE (rpro.shortname = "teacher" OR rpro.shortname = "editingteacher")
AND cpro.id = c.id
GROUP BY cpro.id
Order BY cpro.id asc) "Profesor email",
 
 c.visible CursoVisible,
 (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) CAT1,
 (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) CAT2,
 (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '')) CAT3,
 (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '')) CAT4,
 (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 6),LENGTH(SUBSTRING_INDEX(cc.path, "/", 6-1)) + 1),"/", '')) CAT5,
 (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 7),LENGTH(SUBSTRING_INDEX(cc.path, "/", 7-1)) + 1),"/", '')) CAT6,
 (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 8),LENGTH(SUBSTRING_INDEX(cc.path, "/", 8-1)) + 1),"/", '')) CAT7
FROM {course} c
INNER JOIN {course_categories} cc on c.category = cc.id

WHERE (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11)

GROUP BY c.id
Order BY c.id asc