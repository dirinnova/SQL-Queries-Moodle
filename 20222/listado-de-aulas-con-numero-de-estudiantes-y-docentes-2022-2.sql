/* Listado de aulas con número de estudiantes y docentes 2022-2
Esta consulta devuelve el listado de aulas con total de estudiantes y docentes por cada aula 2022-2 (Derecho Calendario A 2022-2023) y (Pregrado Calendario B 2022-2023) */
SELECT c.id AS "Id", c.fullname AS "Aula", c.shortname AS "Nombre corto", c.format AS "Formato", c.visible AS "Visible",

(
    SELECT 
    REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') AS JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','')
    AS "Tipo Aula"
    FROM {context} ctxt
    INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
    INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
    WHERE ctxt.instanceid = c.id
) AS "Tipo Aula", /* Tipo de aula según el campo adicional dentro del aula "Other fields" */

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
    IF(  /* Condicional */
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        (        
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho" /* Si es de la facultad de derecho */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas" /* o si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", ''))) = "Facultad de Derecho" /* o si son Examenes de Clasificación de la Facultad de Derecho */
            OR
            (
                (
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas" /* o si es del departamento de matematicas */
                    OR
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Centro de Idiomas y Cultura" /* o si es del Centro de Idiomas y Cultura */
                )
                AND
                INSTR(LOWER(cest.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
            )
        )
        ,
        ( /* aplican los filtros de fechas del calendario A y calendario B de Derecho */
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-01-30") /* Pregrado Calendario A 2022-2023 */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-06-18" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-07-31") /* Pregrado Calendario B 2022-2023 */
        )
        , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
            DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-06-18"
    )
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) AS "Estudiantes 2022-2", /* Aulas con estudiantes activos para el periodo 2022-2*/ 

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
    IF(  /* Condicional */
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        (        
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho" /* Si es de la facultad de derecho */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas" /* o si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", ''))) = "Facultad de Derecho" /* o si son Examenes de Clasificación de la Facultad de Derecho */
            OR
            (
                (
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas" /* o si es del departamento de matematicas */
                    OR
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Centro de Idiomas y Cultura" /* o si es del Centro de Idiomas y Cultura */
                )
                AND
                INSTR(LOWER(cest.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
            )
        )
        ,
        ( /* aplican los filtros de fechas del calendario A y calendario B de Derecho */
            ""
        )
        , /* Solo se muestran aulas con estudiantes con fecha finalización 15/12/2022 se valida 2022-12-16-00:59*/ 
            DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d-%H:%i' ) >= "2022-12-16-01:00" AND REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    )
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) AS "Estudiantes pregrado fecha cierre mayor 15dic2022", /* Aulas con estudiantes activos fecha de cierre mayor 15 diciembre 2022 */ 

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
    IF(  /* Condicional */
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        (        
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho" /* Si es de la facultad de derecho */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas" /* o si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", ''))) = "Facultad de Derecho" /* o si son Examenes de Clasificación de la Facultad de Derecho */
            OR
            (
                (
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas" /* o si es del departamento de matematicas */
                    OR
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Centro de Idiomas y Cultura" /* o si es del Centro de Idiomas y Cultura */
                )
                AND
                INSTR(LOWER(cest.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
            )
        )
        ,
        ( /* aplican los filtros de fechas del calendario A de Derecho */
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-01-30") /* Pregrado Calendario A 2022-2023 */
        )
        ,
            ""
    )
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) AS "Est CAL A derecho 2022-2023", /* Aulas con estudiantes activos Pregrado Calendario A 2022-2023 */ 

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
    IF(  /* Condicional */
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        (        
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho" /* Si es de la facultad de derecho */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas" /* o si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", ''))) = "Facultad de Derecho" /* o si son Examenes de Clasificación de la Facultad de Derecho */
            OR
            (
                (
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas" /* o si es del departamento de matematicas */
                    OR
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Centro de Idiomas y Cultura" /* o si es del Centro de Idiomas y Cultura */
                )
                AND
                INSTR(LOWER(cest.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
            )
        )
        ,
        ( /* aplican los filtros de fechas del calendario B de Derecho */
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-06-18" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-07-31") /* Pregrado Calendario B 2022-2023 */
        )
        , 
            ""
    )
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) AS "Est CAL B derecho 2022-2023", /* Aulas con estudiantes activos Pregrado Calendario B 2022-2023 */ 

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
    IF(  /* Condicional que solo muestran solo los estudiantes de las aulas de derecho pregrado 2022-2 */
        REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        AND
        (        
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho" /* Si es de la facultad de derecho */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas" /* o si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
            OR
            (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 4),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 4-1)) + 1),"/", ''))) = "Facultad de Derecho" /* o si son Examenes de Clasificación de la Facultad de Derecho */
            OR
            (
                (
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas" /* o si es del departamento de matematicas */
                    OR
                    (SELECT cccc.name FROM mdl_course_categories cccc WHERE cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Centro de Idiomas y Cultura" /* o si es del Centro de Idiomas y Cultura */
                )
                AND
                INSTR(LOWER(cest.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
            )
        )
        ,
        ( /* aplican los filtros de fechas del calendario A y calendario B de Derecho */
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-01-30") /* Pregrado Calendario A 2022-2023 */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-06-18" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-07-31") /* Pregrado Calendario B 2022-2023 */
        )
        , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
            ""
    )
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) AS "Est CAL AB derecho 2022-2", /* Aulas con estudiantes activos Pregrado Calendario A & B 2022-2 */ 

(
    SELECT COUNT(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid =cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id AND ueest.enrolid = eest.id
    WHERE DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
    AND (rest.shortname = "student")
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) AS "Estudiantes sin fecha de cierre",

(
    SELECT COUNT(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    INNER JOIN {user} uest ON uest.id = raest.userid
    INNER JOIN {course_categories} ccest ON cest.category = ccest.id
    INNER JOIN {enrol} eest ON eest.courseid =cest.id
    INNER JOIN {user_enrolments} ueest ON ueest.userid = uest.id AND ueest.enrolid = eest.id
    WHERE DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) AS "Usuarios sin fecha de cierre",

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
    DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) >= CURDATE()
    OR DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) = "1969-12-31"
    )
    AND (rest.shortname = "student")
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) AS "Estudiantes activos hoy",

(
    SELECT COUNT(cest.id) estudiantes FROM {course} cest
    INNER JOIN {context} ctxest ON ctxest.instanceid = cest.id
    INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
    INNER JOIN {role} rest ON rest.id = raest.roleid
    WHERE rest.shortname = "student"
    AND cest.id = c.id
    ORDER BY cest.id ASC
) AS "Estudiantes",
  
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
) AS "Profesor",
   
(
    SELECT GROUP_CONCAT(CONCAT(upro.email) SEPARATOR '/') AS Profesor
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
) AS "Profesor email",
 
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) CAT1, /* Nivel */
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) CAT2, /* Facultad */
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '')) CAT3, /* Departamento */
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '')) CAT4, /* Programa/Departamento */
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 6),LENGTH(SUBSTRING_INDEX(cc.path, "/", 6-1)) + 1),"/", '')) CAT5,
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 7),LENGTH(SUBSTRING_INDEX(cc.path, "/", 7-1)) + 1),"/", '')) CAT6,
 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 8),LENGTH(SUBSTRING_INDEX(cc.path, "/", 8-1)) + 1),"/", '')) CAT7
FROM {course} c
INNER JOIN {course_categories} cc ON c.category = cc.id

WHERE (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* Pregrado */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* Posgrado */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* Educación Continuada */)

GROUP BY c.id
ORDER BY c.id ASC