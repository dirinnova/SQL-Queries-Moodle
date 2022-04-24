SELECT (
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
) AS "Usuarios activos (licencias usadas según Edulabs - últimos 30 días)",
(
SELECT
    COUNT(*) as "Usuarios activos (licencias usadas según Edulabs - últimos 15 días)"
FROM
    (select l.userid , l.courseid,l.contextid,ue.contextid as cid,ue.userid as cuserid, u.username , u.firstname , u.lastname, u.email, l.timecreated
  from {logstore_standard_log} as l, {user} as u,{role_assignments} as ue
  where l.userid = u.id and l.contextid = ue.contextid and l.userid = ue.userid and l.action = 'viewed'
  and l.component = 'core' and l.target = 'course'
  and DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d' ) >= CURDATE() - INTERVAL 15 DAY
  and DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d' ) <= CURDATE()
  and l.courseid != '1'
  group by l.userid order by l.timecreated) AS usuariosactivos
) AS "Usuarios activos (licencias usadas según Edulabs - últimos 15 días)",
(
SELECT
    COUNT(*) as "Usuarios activos (licencias usadas según Edulabs - últimos 7 días)"
FROM
    (select l.userid , l.courseid,l.contextid,ue.contextid as cid,ue.userid as cuserid, u.username , u.firstname , u.lastname, u.email, l.timecreated
  from {logstore_standard_log} as l, {user} as u,{role_assignments} as ue
  where l.userid = u.id and l.contextid = ue.contextid and l.userid = ue.userid and l.action = 'viewed'
  and l.component = 'core' and l.target = 'course'
  and DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d' ) >= CURDATE() - INTERVAL 7 DAY
  and DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d' ) <= CURDATE()
  and l.courseid != '1'
  group by l.userid order by l.timecreated) AS usuariosactivos
) AS "Usuarios activos (licencias usadas según Edulabs - últimos 7 días)",
(
SELECT
    COUNT(*) as "Usuarios activos (licencias usadas según Edulabs - últimos 1 día)"
FROM
    (select l.userid , l.courseid,l.contextid,ue.contextid as cid,ue.userid as cuserid, u.username , u.firstname , u.lastname, u.email, l.timecreated
  from {logstore_standard_log} as l, {user} as u,{role_assignments} as ue
  where l.userid = u.id and l.contextid = ue.contextid and l.userid = ue.userid and l.action = 'viewed'
  and l.component = 'core' and l.target = 'course'
  and DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d' ) >= CURDATE() - INTERVAL 1 DAY
  and DATE_FORMAT(FROM_UNIXTIME(l.timecreated), '%Y-%m-%d' ) <= CURDATE()
  and l.courseid != '1'
  group by l.userid order by l.timecreated) AS usuariosactivos
) AS "Usuarios activos (licencias usadas según Edulabs - últimos 1 día)"