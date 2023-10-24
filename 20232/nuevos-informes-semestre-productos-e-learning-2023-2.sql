/* Nuevos informes semestre Productos E-learning 2023-2 */
SELECT c.id AS "Id", "2023" AS "AÑO", "II" AS "PERIODO/SEMESTRE",
REPLACE(
    (
        SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
            REPLACE(
                SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''
                )
        )
    ,"Facultad de ",""
) AS "FACULTAD/DEPENDENCIA",

 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '')) AS "DEPARTAMENTO",

(SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) AS "NIVEL",

 (SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
  REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '')) AS "PROGRAMA",

c.fullname AS "PRODUCTOS",

(
    SELECT 
    REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') AS JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','')
    AS "Tipo Aula"
    FROM {context} ctxt
    INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
    INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
    WHERE ctxt.instanceid = c.id
) AS "Tipo Aula", /* Tipo de aula según el campo adicional dentro del aula "Other fields" */
/*
"" AS "CLIENTE", "" AS "ENTIDAD", "" AS "OBJETO CONTRATO",
*/
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
) AS "DOCENTE"
/*
"" AS "DURACIÓN (HORAS)", "" AS "DURACIÓN (SEMANAS)"
*/
FROM {course} c
INNER JOIN {course_categories} cc ON c.category = cc.id
,(SELECT 
/* 
-------------------------------------------------------------------------------------------------------------------------
Estas fechas se deben actualizar cada semestre */

    @calAfechainicio := "2023-01-01", /* (año-mes-día) Fecha inicial del semestre calendario A en derecho pregrado (1 año duración) */
    @calAfechafin := "2024-01-30", /* (año-mes-día) Fecha final del semestre calendario A en derecho pregrado (1 año duración) */
    @calBfechainicio := "2023-06-18", /* (año-mes-día) Fecha inicial del semestre calendario B en derecho pregrado (1 año duración) */
    @calBfechafin := "2024-07-31", /* (año-mes-día) Fecha final del semestre calendario B en derecho pregrado (1 año duración) */
    @fechainiciosemestral := "2023-06-17" /* (año-mes-día) Fecha en la cual inicia el semestre del que se quiere sacar el reporte */

/*  
-------------------------------------------------------------------------------------------------------------------------
*/
) AS vars

WHERE (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* Pregrado */
 OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* Posgrado */
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* Educación Continuada */)

AND
(
    SELECT IFNULL(COUNT(cest.id),0) estudiantes FROM {course} cest
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
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= @calAfechainicio AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= @calAfechafin) /* Pregrado Calendario A */
            OR 
            (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= @calBfechainicio AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= @calBfechafin) /* Pregrado Calendario B */
        )
        , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
            DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= @fechainiciosemestral
    )
    AND rest.shortname = "student"
    AND cest.id = c.id
    GROUP BY cest.id
    ORDER BY cest.id ASC
) != 0

GROUP BY c.id
ORDER BY c.id ASC