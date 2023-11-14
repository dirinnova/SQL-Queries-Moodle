/* Totales estudiantes, inscripciones y profesores activos en Moodle
Esta consulta devuelve los totales de:
Estudiantes Activos (sin Repetir)
Incripciones Estudiantes Activos
Profesores Activos (sin Repetir)
Usuarios Activos (licencias Usadas Según Edulabs - últimos 30 Días)
 */  
SELECT 
    (   
        SELECT DATE_FORMAT(CURDATE(), '%m/%d/%Y' ) AS "Fecha"
    ) AS "Fecha",
    (
        SELECT COUNT(distinct u.id) AS "estudiantes_activos" FROM {course} c
        INNER JOIN {context} ctx ON ctx.instanceid = c.id
        INNER JOIN {role_assignments} ra ON ctx.id = ra.contextid
        INNER JOIN {role} r ON r.id = ra.roleid
        INNER JOIN {user} u ON u.id = ra.userid
        INNER JOIN {course_categories} cc on c.category = cc.id
        inner join {enrol} e on e.courseid =c.id
        INNER JOIN {user_enrolments} ue on ue.userid = u.id and ue.enrolid = e.id
        WHERE
        (
        DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= CURDATE()
        OR DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) = "1969-12-31"
        )
        AND (r.shortname = "student")
        AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2
        OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6
        OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11)
        Order BY c.id asc
    ) AS "Estudiantes activos (sin repetir)",
    (
        SELECT COUNT(u.id) AS "estudiantes_activos" FROM {course} c
        INNER JOIN {context} ctx ON ctx.instanceid = c.id
        INNER JOIN {role_assignments} ra ON ctx.id = ra.contextid
        INNER JOIN {role} r ON r.id = ra.roleid
        INNER JOIN {user} u ON u.id = ra.userid
        INNER JOIN {course_categories} cc on c.category = cc.id
        inner join {enrol} e on e.courseid =c.id
        INNER JOIN {user_enrolments} ue on ue.userid = u.id and ue.enrolid = e.id
        WHERE 
        (
        DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) >= CURDATE()
        OR DATE_FORMAT(FROM_UNIXTIME(ue.timeend), '%Y-%m-%d' ) = "1969-12-31"
        )
        AND (r.shortname = "student")
        AND (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2
        OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6
        OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11)
        Order BY c.id asc
    ) AS "Incripciones estudiantes activos",
    (
        SELECT COUNT(DISTINCT u.id) profesoresmm
        FROM {course} c
        INNER JOIN {context} ctx ON ctx.instanceid = c.id
        INNER JOIN {role_assignments} ra ON ctx.id = ra.contextid
        INNER JOIN {role} r ON r.id = ra.roleid
        INNER JOIN {user} u ON u.id = ra.userid
        INNER JOIN {course_categories} cc on c.category = cc.id
        WHERE r.shortname = "editingteacher"
        AND
        (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2
        OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6
        OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11)
        AND
        (SELECT count(cest.id) estudiantes
        FROM {course} cest
        INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
        INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
        INNER JOIN {role} rest ON rest.id = raest.roleid
        INNER JOIN {user} uest ON uest.id = raest.userid
        INNER JOIN {course_categories} ccest on cest.category = ccest.id
        inner join {enrol} eest on eest.courseid = cest.id
        INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
        WHERE 
        (
        DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= CURDATE()
        OR DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
        )
        AND (rest.shortname = "student")
        AND cest.id = c.id
        Order BY cest.id asc) != 0
        Order BY c.id asc
    ) AS "Profesores activos (sin repetir)",
    (
        SELECT
            COUNT(*) as "Usuarios activos (licencias usadas según Edulabs - últimos 30 días)"
        FROM
            (select l.userid , l.courseid,l.contextid,ue.contextid as cid,ue.userid as cuserid, u.username , u.firstname , u.lastname, u.email, l.timecreated
        from {logstore_standard_log} as l, {user} as u,{role_assignments} as ue
        where l.userid = u.id and l.contextid = ue.contextid and l.userid = ue.userid and l.action = 'viewed'
        and l.component = 'core' and l.target = 'course'
        and DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d' ) >= CURDATE() - INTERVAL 30 DAY
        and DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d' ) <= CURDATE()
        and l.courseid != '1'
        group by l.userid order by l.timecreated) AS usuariosactivos
    ) AS "Usuarios activos (licencias usadas según Edulabs - últimos 30 días)"