/* Esta consulta devuelve el listado de aulas solo 100% virtual y blended con la fecha fin de los estudiantes
-- Listado de campos que devuelve la consulta:
### Id_curso:
Es el número consecutivo de la tabla {course}

### Curso
Nombre del curso (aula)

### Nombre corto
Nombre corto del curso (aula)

### Formato
Es el formato que tiene configurada el aula actualmente.

### Visible
Visibilidad del curso (aula)

### Tipo Aula
Es la configuración que tiene el aula en las opciones general del aula
*/
SELECT Id_curso AS "Id", Curso AS "Aula", NombreCorto AS "Nombre corto", Formato, CursoVisible AS "Visible",
Tipoaula AS "Tipo Aula",Tipoaulanombrecorto AS "Tipo aula nombre corto",encuesta AS "Encuesta Satisfacción",
Estudiantesactivoshoy AS "Estudiantes activos a hoy",Estudiantes, fechainicio, fechafin,
Profesor,Profesoremail AS "Profesor email",CAT1,CAT2,CAT3,CAT4,CAT5,CAT6,CAT7, MAX(fin)
FROM 
(
  SELECT ueest.id idenrol,c.id Id_curso, c.fullname Curso, c.shortname NombreCorto, c.format Formato, c.visible CursoVisible,
  ueest.timestart fechainicio, DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%d/%m/%Y' ) fechafin,
  count(DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%d/%m/%Y' )) fin,
  CASE
    WHEN LOCATE ("-v-i-", LOWER(c.shortname)) THEN "100% Virtual"
    WHEN LOCATE ("-m-i-", LOWER(c.shortname)) THEN "Blended"
    ELSE "Aula apoyo"
  END Tipoaulanombrecorto,

  (
    SELECT REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') as JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','') AS "Tipo Aula"
    FROM {context} ctxt
    INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
    INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
    WHERE ctxt.instanceid = c.id
  ) TipoAula,

  (
    SELECT IF(count(survey.id)>0,"SI","NO") encuestas FROM {feedback} survey
    WHERE 
    LOWER(survey.name) LIKE "%satisfacci%"
    AND survey.course = c.id
  ) AS encuesta,

  (
    SELECT count(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest on cest.category = ccest.id
    inner join {enrol} eest on eest.courseid =cest.id
    INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
    WHERE
    (
      DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= CURDATE()
      OR DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
    )
    AND (rest.shortname = "student")
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
  ) Estudiantesactivoshoy,

  (
    SELECT count(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    WHERE rest.shortname = "student"
    AND cest.id = c.id
    Order BY cest.id asc
  ) Estudiantes,
    
  (
    SELECT GROUP_CONCAT(CONCAT(upro.firstname, " ",upro.lastname) SEPARATOR ' / ') as Profesor
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
    Order BY cpro.id asc
  ) Profesor,
    
  (
    SELECT GROUP_CONCAT(CONCAT(upro.email) SEPARATOR ' / ') as Profesor
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
    Order BY cpro.id asc
  ) Profesoremail,

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

  AND (LOWER(c.shortname) LIKE "%-v-i-%" OR LOWER(c.shortname) LIKE "%-m-i-%" OR LOWER(c.shortname) LIKE "%-v-e-%") /* aulas solo 100% virtual y blended */
  AND rest.shortname = "student"

  GROUP BY c.id, DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%d/%m/%Y' )
  ORDER BY c.id, fin DESC
) aulas 
GROUP BY Id_curso