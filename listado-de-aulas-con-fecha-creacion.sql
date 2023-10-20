/* listado de aulas con fecha creación 
Esta notificación sirve para reemplazar un archivo en OneDrive de la cuenta de backupinternoCEV@uexternado.edu.co 
que tiene una automatización para que sea copiado a powerBI
*/

SELECT c.id AS "Id", c.fullname AS "Aula", c.shortname AS "Nombre corto", 
(
    SELECT FROM_UNIXTIME(l.Timecreated) as "fecha"
    FROM {logstore_standard_log} l
    WHERE l.courseid = c.id
    HAVING min(l.id) > 1
    ORDER BY l.id asc   
) as "fecha creación",

(SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '')) CAT1,
(SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", '')) CAT2,
(SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 4),LENGTH(SUBSTRING_INDEX(cc.path, "/", 4-1)) + 1),"/", '')) CAT3,
(SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 5),LENGTH(SUBSTRING_INDEX(cc.path, "/", 5-1)) + 1),"/", '')) CAT4,
(SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 6),LENGTH(SUBSTRING_INDEX(cc.path, "/", 6-1)) + 1),"/", '')) CAT5,
(SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 7),LENGTH(SUBSTRING_INDEX(cc.path, "/", 7-1)) + 1),"/", '')) CAT6,
(SELECT cat.name FROM {course_categories} cat WHERE cat.id = 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 8),LENGTH(SUBSTRING_INDEX(cc.path, "/", 8-1)) + 1),"/", '')) CAT7

FROM {course} c
INNER JOIN {course_categories} cc ON c.category = cc.id

WHERE 
(
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
OR 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
OR 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EDUCACIÓN CONTINUADA */
OR 
REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 828 /* AULAS CERRADAS */
)
/* AND c.id >= 7314 */

Order BY c.id asc