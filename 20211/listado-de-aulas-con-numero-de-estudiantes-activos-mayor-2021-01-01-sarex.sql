SELECT  c.id Id_curso, (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) "Facultad",
 (select cat.name from {course_categories} cat where cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) "Nivel",
 c.fullname "Aula",
CASE
    WHEN LOCATE ("-v-i-", c.shortname) THEN "100% VIRTUAL"
    WHEN LOCATE ("-v-I-", c.shortname) THEN "100% VIRTUAL"
    WHEN LOCATE ("-V-i-", c.shortname) THEN "100% VIRTUAL"
    WHEN LOCATE ("-V-I-", c.shortname) THEN "100% VIRTUAL"
    WHEN LOCATE ("-m-i-", c.shortname) THEN "BLENDED"
    WHEN LOCATE ("-m-I-", c.shortname) THEN "BLENDED"
    WHEN LOCATE ("-M-i-", c.shortname) THEN "BLENDED"
    WHEN LOCATE ("-M-I-", c.shortname) THEN "BLENDED"
    ELSE "APOYO"
END "Tipo",
  
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
Order BY cpro.id asc) "Docente"
   
FROM {course} c
INNER JOIN {context} ctxest ON ctxest.instanceid = c.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
INNER JOIN {user} uest ON uest.id = raest.userid
INNER JOIN {course_categories} cc on c.category = cc.id
inner join {enrol} eest on eest.courseid =c.id
INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id

WHERE (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11)
AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2021-01-01"
AND (rest.shortname = "student")
GROUP BY c.id
Order BY c.id asc