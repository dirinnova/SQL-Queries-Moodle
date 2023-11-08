/* Listado de aulas con número de estudiantes y docentes CERRADAS 
Esta consulta se utiliza para realizar el backup, filtra estudiantes creados antes del 15 julio 2022
*/
SELECT c.id AS "Id_aula", c.fullname AS "Aula", c.shortname AS "Nombrecorto",

CONCAT(c.id,"-",c.shortname,".mbz") AS "Archivo",

c.format AS "Formato", c.visible AS "Aulavisible",

(
  SELECT REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') as JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','') AS "Tipo Aula"
  FROM {context} ctxt
  INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
  INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
  WHERE ctxt.instanceid = c.id
) AS "Tipo Aula",

(
  SELECT SUBSTR(CONCAT(MIN(l.id), '|', l.timecreated),LOCATE('|',CONCAT(MIN(l.id), '|', l.timecreated))+1) logcreated
  FROM {logstore_standard_log} l
  WHERE l.courseid = c.id
) AS "Fecha de creación",

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
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2022-07-15"
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Aulas antes del 15 julio 2022", /* Esta subconsulta se debe actualizar cada vez que se vuelva a realizar backup de la categoría aulas cerradas */

@a2015 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2015-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2015-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2015",

@a2016 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2016-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2016-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2016",

@a2017 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2017-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2017-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2017",

@a2018 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2018-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2018-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2018",

@a2019 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2019-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2019-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2019",

@a2020 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2020-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2020-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2020",

@a2021 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2021-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2021-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2021",

@a2022 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2022-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2022-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2022",

@a2023 := 
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2023-01-01" 
        AND
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2023-12-31"
    )
    AND ueest.status = 0
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes creados Entre 2023",

(
    SELECT count(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid =cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id and ueest.enrolid = eest.id
    WHERE DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
    AND (rest.shortname = "student")
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Estudiantes sin fecha de cierre",

(
    SELECT count(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid =cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id and ueest.enrolid = eest.id
    WHERE DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "Usuarios sin fecha de cierre",

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
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid =cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id and ueest.enrolid = eest.id
    WHERE rest.shortname = "student"
    AND ueest.status = 0
    AND cest.id = c.id
    Order BY cest.id asc
) AS "Estudiantes",

CASE
    WHEN @a2015 > 0 THEN 2015
    WHEN @a2016 > 0 THEN 2016
    WHEN @a2017 > 0 THEN 2017
    WHEN @a2018 > 0 THEN 2018
    WHEN @a2019 > 0 THEN 2019
    WHEN @a2020 > 0 THEN 2020
    WHEN @a2021 > 0 THEN 2021
    WHEN @a2022 > 0 THEN 2022
    WHEN @a2023 > 0 THEN 2023
    ELSE 0
END "Año", /* Año al que pertenecen las aulas según las inscripciones */
  
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
    SELECT GROUP_CONCAT(CONCAT(upro.email) SEPARATOR '/') as Profesor
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

WHERE (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 828 /* CERRADAS */)

GROUP BY c.id
Order BY c.id asc