SELECT u.id as UserID, u.username as Username, u.firstname as Nombres,
 u.lastname as Apellidos, u.email,r.shortname Rol, c.id Id_curso, c.fullname Curso, c.shortname NombreCorto,c.visible CursoVisible,
 cc.name Categoria, FROM_UNIXTIME(u.lastaccess) ultimo_acceso,
 FROM_UNIXTIME(ue.timestart) f_inicio, FROM_UNIXTIME(ue.timeend) f_finalizacion,
 c.`category`,cc.`parent`,cc.path,
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
FROM mdl_course c
INNER JOIN {context} ctx ON ctx.instanceid = c.id
INNER JOIN {role_assignments} ra ON ctx.id = ra.contextid
INNER JOIN {role} r ON r.id = ra.roleid
INNER JOIN {user} u ON u.id = ra.userid
INNER JOIN {course_categories} cc on c.category = cc.id
inner join {enrol} e on e.courseid =c.id
INNER JOIN {user_enrolments} ue on ue.userid = u.id and ue.enrolid = e.id

WHERE (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11)
  
Order BY c.id asc