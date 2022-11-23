  /* Listado respuestas de encuestas de satisfacción aulas 100% virtual y blended
  
  Esta consulta devuelve el listado respuestas de las encuestas de satisfacción de aulas solo 100% virtual y blended */  
  SELECT fv.id id,c.id Id_curso, c.fullname Curso, c.shortname NombreCorto, c.format Formato, c.visible CursoVisible,

  fe.name nombreencuesta, 
    
  fi.name pregunta,

  (
    CASE
        WHEN (LOCATE('c>>>>>',fi.presentation) > 0 AND fi.typ != "textarea")  THEN 
        (
            SELECT REPLACE(GROUP_CONCAT(TRIM(JSON_EXTRACT(CAST(CONCAT('["', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(fi.presentation,'r>>>>>',''),'c>>>>>',''),'\n',''),'\r',''),'|⃝','|'), '|', '","'), '"]') AS JSON),CONCAT('$[',CAST(JSON_EXTRACT(CAST(CONCAT('["', REPLACE(fv.value, '|', '","'), '"]') AS JSON), CONCAT('$[', num.Number-1, ']')) AS SIGNED)-1, ']'))) SEPARATOR ', ' ), '"', '') as valorPrueba      
            
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
        ELSE TRIM(REPLACE(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(REPLACE(fi.presentation,'|⃝','|'),'r>>>>>',''),'|',fv.value),'|',-1), '\r', ''), '\n', ''))
    END
  ) as Respuesta,

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

  WHERE 
  (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2
  OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6
    OR REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11)

  AND 
  (
    LOWER(c.shortname) LIKE "%-v-i-%"
    OR 
    LOWER(c.shortname) LIKE "%-m-i-%" 
    OR 
    LOWER(c.shortname) LIKE "%-v-e-%"
    OR
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
  AND LOWER(fe.name) LIKE "%satisfacci%"
  AND fv.value != "" AND fv.value != " " AND fv.value != "\n"

  ORDER BY c.id DESC