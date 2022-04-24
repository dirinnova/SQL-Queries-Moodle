SELECT c.id Id_aula, c.fullname Aula, c.shortname NombreCorto, c.format Formato, c.visible AulaVisible,
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
END "Tipo aula",

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
DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) < "2020-07-15"
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes activos hasta 2020-1",


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
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2015-01-01" 
    AND
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2015-12-31"
)
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes activos Entre 2015",

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
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2016-01-01" 
    AND
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2016-12-31"
)
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes activos Entre 2016",


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
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2017-01-01" 
    AND
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2017-12-31"
)
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes activos Entre 2017",

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
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2018-01-01" 
    AND
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2018-12-31"
)
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes activos Entre 2018",

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
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2019-01-01" 
    AND
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2019-12-31"
)
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes activos Entre 2019",


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
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) > "2020-01-01" 
    AND
    DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) < "2020-12-31"
)
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes activos Entre 2020",

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
DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= "2020-07-15"
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes superior 2020-1",

(SELECT count(cest.id) estudiantes FROM {course} cest
INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
INNER JOIN {role} rest ON rest.id = raest.roleid
INNER JOIN {user} uest ON uest.id = raest.userid
INNER JOIN {course_categories} ccest on cest.category = ccest.id
inner join {enrol} eest on eest.courseid =cest.id
INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
WHERE 
IF(
    REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    AND
    (        
            (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho"
            OR
            (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Idiomas - FDE"
            OR
            (
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas"
                AND
                INSTR(lower(cest.fullname),"derecho") != 0 /* Aula de la Facultad de Derecho */
            )                
    )
    ,
    (
        (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2021-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2022-01-30") /* PREGRADO CAL A */
        OR 
        (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* PREGRADO CAL B */
    )
    ,
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2021-06-16"
)
AND rest.shortname = "student"
AND cest.id = c.id
GROUP BY cest.id
Order BY cest.id asc
) AS "Estudiantes 2021-2",

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

WHERE (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */)

GROUP BY c.id
Order BY c.id asc