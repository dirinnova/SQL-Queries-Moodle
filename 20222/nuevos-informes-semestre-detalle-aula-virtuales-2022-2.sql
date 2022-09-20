/* Nuevos informes semestre Detalle Aula Virtuales 2022-2 */
SELECT c.id Id_aula,"2022" AS "AÑO", "II" AS "PERIODO/SEMESTRE",
REPLACE((SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')),"Facultad de ","") AS "FACULTAD/DEPENDENCIA", 
(SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) AS "NIVEL", 
c.fullname AS "CURSO",

(
    SELECT GROUP_CONCAT(CONCAT(upro.firstname, " ",upro.lastname) SEPARATOR ' / ') AS Profesor
    FROM {course} cpro
    INNER JOIN {context} ctxpro ON ctxpro.instanceid = cpro.id
    INNER JOIN {role_assignments} rapro ON ctxpro.id = rapro.contextid
    INNER JOIN {role} rpro ON rpro.id = rapro.roleid
    INNER JOIN {user} upro ON upro.id = rapro.userid
    INNER JOIN {course_categories} ccpro ON cpro.category = ccpro.id
    INNER JOIN {enrol} epro ON epro.courseid =cpro.id
    INNER JOIN {user_enrolments} uepro ON uepro.userid = upro.id AND uepro.enrolid = epro.id
    WHERE (rpro.shortname = "teacher" OR rpro.shortname = "editingteacher")
    AND cpro.id = c.id
    GROUP BY cpro.id
    ORDER BY cpro.id ASC
) "DOCENTE",

"1" AS "GRUPOS",

DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"

FROM {course} c
INNER JOIN {course_categories} cc ON c.category = cc.id
WHERE 
(
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    OR 
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
    OR 
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
)
AND

IF(
    (
        SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')
    ) = "Pregrado"
    AND
    (
        (SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) = "Facultad de Derecho"
        OR
        (SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas"
        OR
        (
            (
                (SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) = "Departamento de Matemáticas"
                OR
                (SELECT cat.name FROM {course_categories} cat WHERE cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) = "Centro de Idiomas y Cultura"
            )
            AND
            INSTR(LOWER(c.fullname),"derecho") != 0
        )
    )
    ,
    (
        SELECT COUNT(cest.id) estudiantes FROM {course} cest
        INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
        INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
        INNER JOIN {role} rest ON rest.id = raest.roleid
        INNER JOIN {user} uest ON uest.id = raest.userid
        INNER JOIN {course_categories} ccest ON cest.category = ccest.id
        INNER JOIN {enrol} eest ON eest.courseid =cest.id
        INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id AND ueest.enrolid = eest.id
        WHERE 
        (
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-01-30")
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-06-18" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-07-31")
        )
        AND rest.shortname = "student"
        AND cest.id = c.id
        GROUP BY cest.id
        ORDER BY cest.id ASC
    )
    ,
    (
        SELECT COUNT(cest.id) estudiantes FROM {course} cest
        INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
        INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
        INNER JOIN {role} rest ON rest.id = raest.roleid
        INNER JOIN {user} uest ON uest.id = raest.userid
        INNER JOIN {course_categories} ccest ON cest.category = ccest.id
        INNER JOIN {enrol} eest ON eest.courseid =cest.id
        INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id AND ueest.enrolid = eest.id
        WHERE 
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-06-18"
        AND rest.shortname = "student"
        AND cest.id = c.id
        GROUP BY cest.id
        ORDER BY cest.id ASC
    )
) != 0

GROUP BY c.id
ORDER BY c.id ASC