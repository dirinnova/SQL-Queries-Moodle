/* 
Listado de inscripciones-accesos-porcentaje por años y programas-facultades 
Reporte para facultades o programas (usualmente para acreditación) por años
creación de aulas, estudiantes, inscripciones, accesos y porcentaje de accesos por años
 */
SELECT 
CASE
    WHEN a.anio = "2015" THEN 2015
    WHEN a.anio = "2016" THEN 2016
    WHEN a.anio = "2017" THEN 2017
    WHEN a.anio = "2018" THEN 2018
    WHEN a.anio = "2019" THEN 2019
    WHEN a.anio = "2020" THEN 2020
    WHEN a.anio = "2021" THEN 2021
    WHEN a.anio = "2022" THEN 2022
    WHEN a.anio = "2023" THEN 2023
    ELSE "False"
END "Año", 

(
    SELECT COUNT(DISTINCT c.id) AS "Aulas Activas"
    FROM {course} c
    INNER JOIN {context} ctx ON ctx.instanceid = c.id
    INNER JOIN {role_assignments} ra ON ctx.id = ra.contextid
    INNER JOIN {role} r ON r.id = ra.roleid
    INNER JOIN {user} u ON u.id = ra.userid
    INNER JOIN {course_categories} cc ON c.category = cc.id
    INNER JOIN {enrol} e ON e.courseid =c.id
    INNER JOIN {user_enrolments} ue ON ue.userid = u.id AND ue.enrolid = e.id
    WHERE 
    
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '') = 127 /* Maestría en Gerencia de la Innovación Empresarial MGIE */
        OR
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '') = 1961 /* Maestría en Gerencia de la Innovación Empresarial MGIE - Aulas cerradas*/
    )
    AND r.shortname = "student"
    AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y' ) = a.anio  
    ORDER BY c.id ASC
) AS "Aulas MGIE",

(
    SELECT count(DISTINCT uest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid =cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id and ueest.enrolid = eest.id
    WHERE rest.shortname = "student"
    AND
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", '') = 127 /* Maestría en Gerencia de la Innovación Empresarial MGIE */
        OR
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 5),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 5-1)) + 1),"/", '') = 1961 /* Maestría en Gerencia de la Innovación Empresarial MGIE - Aulas cerradas*/
    )
    AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y' ) = a.anio  
    Order BY cest.id asc
) AS "Estudiantes MGIE",

@totalinscripcionesMGIE := 
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
    AND
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", '') = 127 /* Maestría en Gerencia de la Innovación Empresarial MGIE */
        OR
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 5),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 5-1)) + 1),"/", '') = 1961 /* Maestría en Gerencia de la Innovación Empresarial MGIE - Aulas cerradas*/
    )
    AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y' ) = a.anio  
    Order BY cest.id asc
) AS "Inscripciones MGIE",

@noingresaronMGIE := 
(
    SELECT count(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid = cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id AND ueest.enrolid = eest.id
    WHERE rest.shortname = "student"
    AND IF(FROM_UNIXTIME(uest.lastaccess) < FROM_UNIXTIME(ueest.timestart), "NUNCA", FROM_UNIXTIME(uest.lastaccess)) = "NUNCA"
    AND
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", '') = 127 /* Maestría en Gerencia de la Innovación Empresarial MGIE */
        OR
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 5),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 5-1)) + 1),"/", '') = 1961 /* Maestría en Gerencia de la Innovación Empresarial MGIE - Aulas cerradas*/
    )
    AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y' ) = a.anio  
    Order BY cest.id asc
) AS "No Ingresaron MGIE",

@totalingresosMGIE := 
(@totalinscripcionesMGIE - @noingresaronMGIE) AS "Total de Ingresos MGIE",

CONCAT(ROUND((@totalingresosMGIE * 100) / @totalinscripcionesMGIE, 1),"%") AS "Porcentaje Ingresos MGIE",

(
    SELECT COUNT(DISTINCT c.id) AS "Aulas Activas"
    FROM {course} c
    INNER JOIN {context} ctx ON ctx.instanceid = c.id
    INNER JOIN {role_assignments} ra ON ctx.id = ra.contextid
    INNER JOIN {role} r ON r.id = ra.roleid
    INNER JOIN {user} u ON u.id = ra.userid
    INNER JOIN {course_categories} cc ON c.category = cc.id
    INNER JOIN {enrol} e ON e.courseid =c.id
    INNER JOIN {user_enrolments} ue ON ue.userid = u.id AND ue.enrolid = e.id
    WHERE 
    
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '') = 117 /* Maestría en mercadeo MM */
        OR
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '') = 1966 /* Maestría en mercadeo MM - Aulas cerradas*/
    )
    AND r.shortname = "student"
    AND DATE_FORMAT(FROM_UNIXTIME(ue.timestart), '%Y' ) = a.anio
    ORDER BY c.id ASC
) AS "Aulas MM",

(
    SELECT count(DISTINCT uest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid =cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id and ueest.enrolid = eest.id
    WHERE rest.shortname = "student"
    AND
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", '') = 117 /* Maestría en mercadeo MM */
        OR
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 5),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 5-1)) + 1),"/", '') = 1966 /* Maestría en mercadeo MM - Aulas cerradas*/
    )
    AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y' ) = a.anio  
    Order BY cest.id asc
) AS "Estudiantes MM",

@totalinscripcionesMM := 
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
    AND
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", '') = 117 /* Maestría en mercadeo MM */
        OR
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 5),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 5-1)) + 1),"/", '') = 1966 /* Maestría en mercadeo MM - Aulas cerradas*/
    )
    AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y' ) = a.anio  
    Order BY cest.id asc
) AS "Inscripciones MM",

@noingresaronMM := 
(
    SELECT count(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid = cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id AND ueest.enrolid = eest.id
    WHERE rest.shortname = "student"
    AND IF(FROM_UNIXTIME(uest.lastaccess) < FROM_UNIXTIME(ueest.timestart), "NUNCA", FROM_UNIXTIME(uest.lastaccess)) = "NUNCA"
    AND
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", '') = 117 /* Maestría en mercadeo MM */
        OR
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 5),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 5-1)) + 1),"/", '') = 1966 /* Maestría en mercadeo MM - Aulas cerradas*/
    )
    AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y' ) = a.anio  
    Order BY cest.id asc
) AS "No Ingresaron MM",

@totalingresosMM := 
(@totalinscripcionesMM - @noingresaronMM) AS "Total de Ingresos MM",

CONCAT(ROUND((@totalingresosMM * 100) / @totalinscripcionesMM, 1),"%") AS "Porcentaje Ingresos MM"

FROM
(SELECT "2015" AS anio
 UNION ALL SELECT "2016"
  UNION ALL SELECT "2017"
   UNION ALL SELECT "2018"
    UNION ALL SELECT "2019"
     UNION ALL SELECT "2020"
      UNION ALL SELECT "2021"
       UNION ALL SELECT "2022"
        UNION ALL SELECT "2023") a