/* Listado de aulas Semillas */
SELECT c.id AS "Id", c.fullname AS "Aula semilla", c.shortname AS "Nombre corto",

(
  SELECT SUBSTR(CONCAT(MIN(l.id), '|', l.timecreated),LOCATE('|',CONCAT(MIN(l.id), '|', l.timecreated))+1) logcreated
  FROM {logstore_standard_log} l
  WHERE l.courseid = c.id
) AS "Fecha de creación",

(
  SELECT REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') as JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','') AS "Tipo Aula"
  FROM {context} ctxt
  INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
  INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
  WHERE ctxt.instanceid = c.id
) AS "Tipo Aula",

 c.format AS "Formato",

(
  SELECT IF(count(survey.id)>0,"SI","NO") encuestas FROM {feedback} survey
  WHERE 
  LOWER(survey.name) LIKE "%satisfacci%"
  AND survey.course = c.id
) AS "Encuesta Satisfacción",

(
  SELECT count(cest.id) estudiantes FROM {course} cest
  INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
  INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
  INNER JOIN {role} rest ON rest.id = raest.roleid
  INNER JOIN {user} uest ON uest.id = raest.userid
  INNER JOIN {course_categories} ccest ON cest.category = ccest.id
  INNER JOIN {enrol} eest ON eest.courseid =cest.id
  INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id and ueest.enrolid = eest.id
  WHERE
  (
    DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= CURDATE()
    OR DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
  )
  AND (rest.shortname = "student")
  AND cest.id = c.id
  GROUP BY cest.id
  Order BY cest.id asc
) AS "Estudiantes activos hoy",

(
  SELECT count(cest.id) estudiantes FROM {course} cest
  INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
  INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
  INNER JOIN {role} rest ON rest.id = raest.roleid
  WHERE rest.shortname = "student"
  AND cest.id = c.id
  Order BY cest.id asc
) AS "Estudiantes",
  
(
  SELECT GROUP_CONCAT(CONCAT(upro.firstname, " ",upro.lastname) SEPARATOR ' / ') as Profesor
  FROM {course} cpro
  INNER JOIN {context} ctxpro ON ctxpro.instanceid = cpro.id
  INNER JOIN {role_assignments} rapro ON ctxpro.id = rapro.contextid
  INNER JOIN {role} rpro ON rpro.id = rapro.roleid
  INNER JOIN {user} upro ON upro.id = rapro.userid
  INNER JOIN {course_categories} ccpro ON cpro.category = ccpro.id
  INNER JOIN {enrol} epro ON epro.courseid =cpro.id
  INNER JOIN {user_enrolments} uepro ON uepro.userid = upro.id and uepro.enrolid = epro.id
  WHERE (rpro.shortname = "teacher" OR rpro.shortname = "editingteacher")
  AND cpro.id = c.id
  GROUP BY cpro.id
  Order BY cpro.id asc
) AS "Profesor",
   
(
  SELECT GROUP_CONCAT(CONCAT(upro.email) SEPARATOR ' / ') as Profesor
  FROM {course} cpro
  INNER JOIN {context} ctxpro ON ctxpro.instanceid = cpro.id
  INNER JOIN {role_assignments} rapro ON ctxpro.id = rapro.contextid
  INNER JOIN {role} rpro ON rpro.id = rapro.roleid
  INNER JOIN {user} upro ON upro.id = rapro.userid
  INNER JOIN {course_categories} ccpro ON cpro.category = ccpro.id
  INNER JOIN {enrol} epro ON epro.courseid =cpro.id
  INNER JOIN {user_enrolments} uepro ON uepro.userid = upro.id and uepro.enrolid = epro.id
  WHERE (rpro.shortname = "teacher" OR rpro.shortname = "editingteacher")
  AND cpro.id = c.id
  GROUP BY cpro.id
  Order BY cpro.id asc
) AS "Profesor email",
 
 c.visible AS "Visible",
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) CAT1,
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) CAT2,
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '')) CAT3,
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '')) CAT4,
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 6),LENGTH(SUBSTRING_INDEX(cc.path, "/", 6-1)) + 1),"/", '')) CAT5,
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 7),LENGTH(SUBSTRING_INDEX(cc.path, "/", 7-1)) + 1),"/", '')) CAT6,
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 8),LENGTH(SUBSTRING_INDEX(cc.path, "/", 8-1)) + 1),"/", '')) CAT7
FROM {course} c
INNER JOIN {course_categories} cc ON c.category = cc.id

WHERE REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 319 /* SEMILLAS */

GROUP BY c.id
Order BY c.id asc