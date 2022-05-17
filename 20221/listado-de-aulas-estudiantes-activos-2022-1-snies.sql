/* Esta consulta devuelve el listado de aulas con cantidad de SCORMS, libros, unidades filtradas con el proposito de generar las cifras para SNIES 2022-1*/
SELECT c.id Id_aula,
 (SELECT COUNT(*) as CantidadScorms
    FROM {scorm} sco 
    WHERE c.id=sco.course Group by sco.course ORDER BY sco.id DESC LIMIT 1) "Scorm", /* Cantidad de contenido SCORM por aula */

 (SELECT COUNT(*) as CantidadBooks
    FROM {book} boo 
    WHERE c.id=boo.course Group by boo.course ORDER BY boo.id DESC LIMIT 1) "Libro", /* Cantidad de recursos tipo libros en el aula */

 (SELECT cfo.value as CantidadUnidades
    FROM {course_format_options} cfo 
    WHERE cfo.courseid = c.id and cfo.name="numsections" ORDER BY cfo.id DESC LIMIT 1) "Unidades", /* cantidad de secciones por aula */

 c.fullname Aula, c.shortname NombreCorto, c.format Formato, c.visible AulaVisible,
CASE
    WHEN LOCATE ("-v-i-", c.shortname) THEN "100% Virtual"
    WHEN LOCATE ("-v-I-", c.shortname) THEN "100% Virtual"
    WHEN LOCATE ("-V-i-", c.shortname) THEN "100% Virtual"
    WHEN LOCATE ("-V-I-", c.shortname) THEN "100% Virtual"
    WHEN LOCATE ("-m-i-", c.shortname) THEN "Blended"
    WHEN LOCATE ("-m-I-", c.shortname) THEN "Blended"
    WHEN LOCATE ("-M-i-", c.shortname) THEN "Blended"
    WHEN LOCATE ("-M-I-", c.shortname) THEN "Blended"
    ELSE "Aula apoyo"
END "Tipo aula nombre corto", /* Tipo de aula según el nombre corto del aula */

 (SELECT 
 REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') as JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','')
 AS "Tipo Aula"
 FROM {context} ctxt
 INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
 INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
  WHERE ctxt.instanceid = c.id) "Tipo Aula", /* Tipo de aula según el campo adicional dentro del aula "Other fields" */

(SELECT count(cest.id) estudiantes FROM {course} cest
INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
INNER JOIN {user} uest ON uest.id = raest.userid
INNER JOIN {course_categories} ccest on cest.category = ccest.id
inner join {enrol} eest on eest.courseid =cest.id
INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
WHERE 

IF(  /* Condicional */
    REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    AND
    (        
        (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho" /* Si es de la facultad de derecho */
        OR
        (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas" /* o si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
        OR
        (
            (
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas" /* o si es del departamento de matematicas */
                OR
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Centro de Idiomas y Cultura" /* o si es del Centro de Idiomas y Cultura */
            )
            AND
            INSTR(lower(cest.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
        )                
    )
    ,
    ( /* aplican los filtros de fechas del calendario A y calendario B de Derecho */
        (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-01-30") /* Pregrado Calendario A */
        OR 
        (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-07-31") /* Pregrado Calendario B */
    )
    , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-06-16"
)
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes 2022-1", /* Aulas con estudiantes activos para el periodo 2022-1*/ 

 (SELECT count(cest.id) estudiantes FROM {course} cest
INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
INNER JOIN {user} uest ON uest.id = raest.userid
INNER JOIN {course_categories} ccest on cest.category = ccest.id
inner join {enrol} eest on eest.courseid =cest.id
INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
WHERE DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
AND (rest.shortname = "student")
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc) "Estudiantes sin fecha de cierre",

 (SELECT count(cest.id) estudiantes FROM {course} cest
INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
INNER JOIN {user} uest ON uest.id = raest.userid
INNER JOIN {course_categories} ccest on cest.category = ccest.id
inner join {enrol} eest on eest.courseid =cest.id
INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
WHERE DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc) "Usuarios sin fecha de cierre",

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
DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= CURDATE()
OR DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
)
AND (rest.shortname = "student")
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc) "Estudiantes activos hoy",

 (SELECT count(cest.id) estudiantes FROM {course} cest
INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
WHERE rest.shortname = "student"
AND cest.id = c.id
Order BY cest.id asc) "Estudiantes",
  
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
Order BY cpro.id asc) "Profesor",
   
(SELECT GROUP_CONCAT(CONCAT(upro.email) SEPARATOR '/') as Profesor
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

WHERE (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* Pregrado */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* Posgrado */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* Educación Continuada */)

GROUP BY c.id
Order BY c.id asc