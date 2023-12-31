/* Listado respuestas de encuestas de satisfacción aulas 100% virtual y blended
Esta consulta devuelve el listado respuestas de las encuestas de satisfacción de aulas solo 100% virtual y blended */  

/* 
AÑO	"PERIODO/SEMESTRE"	MEDIO	ESTRATEGIA DE CAPACITACIÓN	Fecha	PARTICIPANTE	CORREO ELECTRÓNICO	PREGUNTA	RESPUESTA
 */

SELECT t.idrta AS "ID respuesta", t.Id_curso, t.fechainicio, t.fechafin, t.anio AS "AÑO", t.periodosemestre AS "PERIODO/SEMESTRE", t.curso AS "Aula", t.NombreCorto AS "Aula Nombre corto", t.tipoaula AS "Tipo aula", t.nombreencuesta AS "Nombre de la Encuesta", t.pregunta AS "Pregunta", t.respuesta AS "Respuesta", t.CAT1, t.CAT2, t.CAT3, t.CAT4, t.CAT5, t.CAT6, t.CAT7,DATE_FORMAT(CURDATE(), '%d/%m/%Y') AS "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"
FROM
(
  SELECT fv.id idrta,c.id Id_curso, c.fullname Curso, c.shortname NombreCorto, c.format Formato, c.visible CursoVisible,
  ueest.timestart fechainicio, DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%d/%m/%Y' ) fechafin, DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y' ) anio, 
  
  (
    CASE 
      WHEN (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%m' ) >= 01 AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%m' ) <= 06) THEN "I"
      WHEN (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%m' ) >= 07 AND DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%m' ) <= 12) THEN "II"
    END
  ) periodosemestre,  

  fe.name nombreencuesta, 

  fi.name pregunta,

  (
    CASE
        WHEN (LOCATE('c>>>>>',fi.presentation) > 0 AND fi.typ != "textarea")  THEN 
        (
            SELECT REPLACE(REPLACE(GROUP_CONCAT(TRIM(JSON_EXTRACT(CAST(CONCAT('["', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(fi.presentation,'r>>>>>',''),'c>>>>>',''),'\n',''),'\r',''),'|⃝','|'), '|', '","'), '"]') AS JSON),CONCAT('$[',CAST(JSON_EXTRACT(CAST(CONCAT('["', REPLACE(fv.value, '|', '","'), '"]') AS JSON), CONCAT('$[', num.Number-1, ']')) AS SIGNED)-1, ']'))) SEPARATOR ', ' ), '"', ''),'<<<<<1','') as valorPrueba      
            
            FROM
            (
                SELECT 1 AS Number 
                UNION ALL SELECT 2
                UNION ALL SELECT 3
                UNION ALL SELECT 4
                UNION ALL SELECT 5
                UNION ALL SELECT 6
                UNION ALL SELECT 7
                UNION ALL SELECT 8
                UNION ALL SELECT 9
                UNION ALL SELECT 10
            ) AS num
            CROSS JOIN
            (
                SELECT 'some data' AS Result
            ) AS MainQuery
            WHERE num.Number <= FORMAT((length(fv.value)/2)+0.5,0)  
        )
        WHEN fi.typ = "textarea" THEN fv.value
        ELSE TRIM(REPLACE(REPLACE(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(REPLACE(fi.presentation,'|⃝','|'),'r>>>>>',''),'|',fv.value),'|',-1), '\r', ''), '\n', ''),'<<<<<1',''))
    END
  ) respuesta,

  (
    SELECT REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') as JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','') AS "Tipo Aula"
    FROM {context} ctxt
    INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
    INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
    WHERE ctxt.instanceid = c.id
  ) TipoAula,

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

  INNER JOIN {context} ctxest ON ctxest.instanceid = c.id
  INNER JOIN {role_assignments} raest ON ctxest.id = raest.contextid
  INNER JOIN {role} rest ON rest.id = raest.roleid
  INNER JOIN {user} uest ON uest.id = raest.userid
  INNER JOIN {course_categories} cc on c.category = cc.id
  INNER JOIN {enrol} eest on eest.courseid = c.id
  INNER JOIN {user_enrolments} ueest on ueest.userid = uest.id and ueest.enrolid = eest.id

  INNER JOIN {feedback} fe ON fe.course = c.id
  INNER JOIN {feedback_item} fi ON fi.feedback = fe.id
  INNER JOIN {feedback_value} fv ON fv.item = fi.id

  INNER JOIN {feedback_completed} fc ON fc.feedback = fe.id AND fc.userid = uest.id

  WHERE
  (
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EDUCACIÓN CONTINUADA */
  )

  AND 
  (
    (
      SELECT REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') as JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','') AS "Tipo Aula"
      FROM {context} ctxt
      INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
      INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
      WHERE ctxt.instanceid = c.id
    ) = "100% Virtual"
    OR
    (
      SELECT REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') as JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','') AS "Tipo Aula"
      FROM {context} ctxt
      INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
      INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
      WHERE ctxt.instanceid = c.id
    ) = "Blended"
    OR
    (
      SELECT REPLACE(JSON_EXTRACT(CAST(CONCAT('["',REPLACE(REPLACE(JSON_EXTRACT(cff.configdata, '$.options'),'"',''),'\\r\\n','","'),'"]') as JSON), CONCAT('$[',cfd.intvalue-1,']')),'"','') AS "Tipo Aula"
      FROM {context} ctxt
      INNER JOIN {customfield_data} cfd ON cfd.contextid = ctxt.id
      INNER JOIN {customfield_field} cff ON cff.id = cfd.fieldid
      WHERE ctxt.instanceid = c.id
    ) = "Mooc"
  ) /* aulas solo 100% virtual y blended */
  AND LOWER(fe.name) LIKE "%satisfacci%" /* Solo aulas con encuestas que tengan en el nombre "satisfacci" */
  AND fv.value != "" AND fv.value != " " AND fv.value != "\n" AND fv.value != "\r" /* solo se muestran respuestas validas, no vacias, sin espacios o saltos de página */

  ORDER BY c.id DESC
) t
