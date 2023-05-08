/* Listado de aulas por año filtrado por programa */
SELECT c.id AS "Id", c.fullname AS "Aula", c.shortname AS "Nombre corto",


  (
    SELECT COUNT(DISTINCT fvpreg.completed) Respuestas
    FROM {feedback} fepreg
    INNER JOIN {feedback_item} fipreg ON fipreg.feedback = fepreg.id
    INNER JOIN {feedback_value} fvpreg ON fvpreg.item = fipreg.id
    WHERE fepreg.course = c.id
  ) TotalRespuestas,

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
  AND rest.shortname = "student"
  AND cest.id = c.id
  GROUP BY cest.id
  Order BY cest.id asc
) AS "Estudiantes activos a hoy",

(
  SELECT count(cest.id) estudiantes FROM {course} cest
  INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
  INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
  INNER JOIN {role} rest ON rest.id = raest.roleid
  WHERE rest.shortname = "student"
  AND cest.id = c.id
  Order BY cest.id asc
) AS "Estudiantes",

@totalinscripciones := 
(
  SELECT count(cest.id) estudiantes FROM {course} cest
  INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
  INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
  INNER JOIN {role} rest ON rest.id = raest.roleid
  WHERE rest.shortname = "student"
  AND cest.id = c.id
  Order BY cest.id asc
) AS totalinscripciones,

@noingresaron := 
(
  SELECT count(cest.id) estudiantes FROM {course} cest
  INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
  INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
  INNER JOIN {role} rest ON rest.id = raest.roleid
  INNER JOIN {user} uest ON uest.id = raest.userid
  INNER JOIN {enrol} eest ON eest.courseid = cest.id
  INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id AND ueest.enrolid = eest.id
  WHERE rest.shortname = "student"
  AND cest.id = c.id 
  AND IF(FROM_UNIXTIME(uest.lastaccess) < FROM_UNIXTIME(ueest.timestart), "NUNCA", FROM_UNIXTIME(uest.lastaccess)) = "NUNCA"
  Order BY cest.id asc
) AS noingresaron,

(@totalinscripciones - @noingresaron) AS totalingresos,
  
ROUND( 
    ((@totalinscripciones - @noingresaron) * 100) / @totalinscripciones 
) AS porcentaje,

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
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "E 2017",
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
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "E 2018",
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
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "E 2019",
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
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "E 2020",
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
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "E 2021",
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
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "E 2022",
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
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    Order BY cest.id asc
) AS "E 2023",

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

WHERE 
(
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '') = 127 /* Maestría en Gerencia de la Innovación Empresarial MGIE */
    OR
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '') = 1961 /* Maestría en Gerencia de la Innovación Empresarial MGIE - Aulas cerradas*/
    OR
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '') = 117 /* Maestría en mercadeo MM */
    OR
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '') = 1966 /* Maestría en mercadeo MM - Aulas cerradas*/
)

GROUP BY c.id
Order BY c.id asc