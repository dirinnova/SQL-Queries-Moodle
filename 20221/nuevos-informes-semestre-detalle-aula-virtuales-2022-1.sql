/* Nuevos informes semestre Detalle Aula Virtuales 2022-1 */
SELECT c.id Id_aula,"2022" AS "AÑO", "I" AS "PERIODO/SEMESTRE",
REPLACE((select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')),"Facultad de ","") AS "FACULTAD/DEPENDENCIA", 
(select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) AS "NIVEL", 
c.fullname AS "CURSO",

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
) "DOCENTE",

"1" AS "GRUPOS",

DATE_FORMAT(CURDATE(), '%/d%/m%Y') as "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"

FROM {course} c
INNER JOIN {course_categories} cc on c.category = cc.id
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
        select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')
    ) = "Pregrado"
    AND
    (
        (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) = "Facultad de Derecho"
        OR
        (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas"
        OR
        (
            (
                (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) = "Departamento de Matemáticas"
                OR
                (select cat.name from {course_categories} cat where cat.id = REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) = "Centro de Idiomas y Cultura"
            )
            AND
            INSTR(lower(c.fullname),"derecho") != 0
        )
    )
    ,
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
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-01-30")
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2022-07-31")
        )
        AND rest.shortname = "student"
        AND cest.id = c.id
        GROUP BY cest.id
        Order BY cest.id asc
    )
    ,
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
        DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01"
        AND rest.shortname = "student"
        AND cest.id = c.id
        GROUP BY cest.id
        Order BY cest.id asc
    )
) != 0

GROUP BY c.id
Order BY c.id asc