/* Totales estudiantes y profesores activos por Facultad y Nivel */
SELECT (@cnt := @cnt + 1) AS "Id", ccc.name AS "Facultad",
(SELECT cat.name FROM mdl_course_categories cat WHERE cat.id = ccc.parent) AS "Nivel",

(
    SELECT COUNT(distinct u.id) AS "Estudiantes activos"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc ON c.category = cc.id
    INNER JOIN mdl_enrol e ON e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id and ue.enrolid = e.id
    WHERE 
    (
        DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= CURDATE()
        OR DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) = "1969-12-31"
    )
    AND r.shortname = "student"
    AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
    AND (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    ORDER BY c.id asc
) AS "Estudiantes activos (sin repetir)",

(
    SELECT COUNT(u.id) AS "Inscripciones Estudiantes"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc ON c.category = cc.id
    INNER JOIN mdl_enrol e ON e.courseid =c.id
    INNER JOIN mdl_user_enrolments ue ON ue.userid = u.id and ue.enrolid = e.id
    WHERE 
    (
        DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= CURDATE()
        OR DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) = "1969-12-31"
    )
    AND r.shortname = "student"
    AND REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
    AND (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    ORDER BY c.id asc
) AS "Incripciones estudiantes activos",

(
    SELECT COUNT(DISTINCT u.id) profesores
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc ON c.category = cc.id
    WHERE r.shortname = "editingteacher"
    AND (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    AND
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = ccc.parent
    AND
    (
        SELECT count(cest.id) estudiantes
        FROM mdl_course cest
        INNER JOIN mdl_context ctxest ON ctxest.instanceid = cest.id
        INNER JOIN mdl_role_assignments raest ON ctxest.id = raest.contextid
        INNER JOIN mdl_role rest ON rest.id = raest.roleid
        INNER JOIN mdl_user uest ON uest.id = raest.userid
        INNER JOIN mdl_course_categories ccest ON cest.category = ccest.id
        INNER JOIN mdl_enrol eest ON eest.courseid = cest.id
        INNER JOIN mdl_user_enrolments ueest ON ueest.userid = uest.id and ueest.enrolid = eest.id
        WHERE 
        (
            DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= CURDATE()
            OR DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
        )
        AND (rest.shortname = "student")
        AND cest.id = c.id
        ORDER BY cest.id asc
    ) != 0
    ORDER BY c.id asc
) AS "Profesores activos (sin repetir)"

FROM mdl_course_categories ccc
CROSS JOIN (SELECT @cnt := 0) AS dummy
WHERE (ccc.parent = 2 /* PREGRADO */
OR ccc.parent = 6 /* POSGRADO */
OR ccc.parent = 11) /* EDUCACIÓN CONTINUADA */
ORDER BY (SELECT @cnt := 0),ccc.name ASC