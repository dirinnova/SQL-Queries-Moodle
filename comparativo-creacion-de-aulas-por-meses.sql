/* Comparativo creación de aulas por meses */
SELECT 
CASE
    WHEN m.mes = "january" THEN "Enero"
    WHEN m.mes = "february" THEN "Febrero"
    WHEN m.mes = "march" THEN "Marzo"
    WHEN m.mes = "april" THEN "Abril"
    WHEN m.mes = "may" THEN "Mayo"
    WHEN m.mes = "june" THEN "Junio"
    WHEN m.mes = "july" THEN "Julio"
    WHEN m.mes = "august" THEN "Agosto"
    WHEN m.mes = "september" THEN "Septiembre"
    WHEN m.mes = "october" THEN "Octubre"
    WHEN m.mes = "november" THEN "Noviembre"
    WHEN m.mes = "december" THEN "Diciembre"
    ELSE "False"
END "Meses", 

(
    SELECT COUNT(*) AS "MESES"

    FROM {course} c
    INNER JOIN {course_categories} cc ON c.category = cc.id

    WHERE 
    (
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    OR 
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
    OR 
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EDUCACIÓN CONTINUADA */
    )
    AND c.id >= 7314
    AND
    (
        SELECT DATE_FORMAT(FROM_UNIXTIME(l.Timecreated), '%Y' ) as "fecha"
        FROM {logstore_standard_log} l
        WHERE l.courseid = c.id
        HAVING min(l.id) > 1
        ORDER BY l.id asc   
    ) = 2021
    AND
    (
        SELECT DATE_FORMAT(FROM_UNIXTIME(l.Timecreated), '%M' ) as "fecha"
        FROM {logstore_standard_log} l
        WHERE l.courseid = c.id
        HAVING min(l.id) > 1
        ORDER BY l.id asc   
    ) = m.mes

    GROUP BY 
    (
        SELECT DATE_FORMAT(FROM_UNIXTIME(l.Timecreated), '%M %Y' ) as "fecha"
        FROM {logstore_standard_log} l
        WHERE l.courseid = c.id
        HAVING min(l.id) > 1
        ORDER BY l.id asc   
    )
    Order BY c.id asc
) AS "Año 2021",

(
    SELECT COUNT(*) AS "MESES"

    FROM {course} c
    INNER JOIN {course_categories} cc ON c.category = cc.id

    WHERE 
    (
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
    OR 
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
    OR 
    REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EDUCACIÓN CONTINUADA */
    )
    AND c.id >= 7314
    AND
    (
        SELECT DATE_FORMAT(FROM_UNIXTIME(l.Timecreated), '%Y' ) as "fecha"
        FROM {logstore_standard_log} l
        WHERE l.courseid = c.id
        HAVING min(l.id) > 1
        ORDER BY l.id asc   
    ) = 2022
    AND
    (
        SELECT DATE_FORMAT(FROM_UNIXTIME(l.Timecreated), '%M' ) as "fecha"
        FROM {logstore_standard_log} l
        WHERE l.courseid = c.id
        HAVING min(l.id) > 1
        ORDER BY l.id asc   
    ) = m.mes

    GROUP BY 
    (
        SELECT DATE_FORMAT(FROM_UNIXTIME(l.Timecreated), '%M %Y' ) as "fecha"
        FROM {logstore_standard_log} l
        WHERE l.courseid = c.id
        HAVING min(l.id) > 1
        ORDER BY l.id asc   
    )
    Order BY c.id asc
) AS "Año 2022"

FROM
(SELECT "january" AS mes
 UNION ALL SELECT "february"
  UNION ALL SELECT "march"
   UNION ALL SELECT "april"
    UNION ALL SELECT "may"
     UNION ALL SELECT "june"
      UNION ALL SELECT "july"
       UNION ALL SELECT "august"
        UNION ALL SELECT "september"
         UNION ALL SELECT "october"
          UNION ALL SELECT "november"
           UNION ALL SELECT "december") m