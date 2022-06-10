/* Nuevos informes semestre Docentes x Facultad 2022-1 */
SELECT distinct ccc.name AS "ID", REPLACE(ccc.name,"Facultad de ","") as "FACULTAD/DEPENDENCIA","2022-I" AS "AÑO/SEMESTRE",

(
    SELECT COUNT(DISTINCT u.id) AS "Profesores"
    FROM mdl_course c
    INNER JOIN mdl_context ctx ON ctx.instanceid = c.id
    INNER JOIN mdl_role_assignments ra ON ctx.id = ra.contextid
    INNER JOIN mdl_role r ON r.id = ra.roleid
    INNER JOIN mdl_user u ON u.id = ra.userid
    INNER JOIN mdl_course_categories cc on c.category = cc.id
    WHERE r.shortname = "editingteacher"
    AND (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 3),LENGTH(SUBSTRING_INDEX(cc.path, "/", 3-1)) + 1),"/", ''))) = ccc.name
    AND
    (
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
        OR 
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 6 /* POSGRADO */
        OR 
        REPLACE(SUBSTRING(SUBSTRING_INDEX(cc.path, "/", 2),LENGTH(SUBSTRING_INDEX(cc.path, "/", 2-1)) + 1),"/", '') = 11 /* EC */
    )
    AND
    (
        SELECT count(cest.id) estudiantes
        FROM mdl_course cest
        INNER JOIN mdl_context ctxest ON ctxest.instanceid = cest.id
        INNER JOIN mdl_role_assignments raest ON ctxest.id = raest.contextid
        INNER JOIN mdl_role rest ON rest.id = raest.roleid
        INNER JOIN mdl_user uest ON uest.id = raest.userid
        INNER JOIN mdl_course_categories ccest on cest.category = ccest.id
        inner join mdl_enrol eest on eest.courseid = cest.id
        INNER JOIN mdl_user_enrolments ueest on ueest.userid = uest.id and ueest.enrolid = eest.id
        WHERE

        IF(
            REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 2),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 2-1)) + 1),"/", '') = 2 /* PREGRADO */
            AND
            (        
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Facultad de Derecho" /* Si es de la facultad de derecho */
                OR
                (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas" /* o si es del Instituto de Estudios Interdisciplinarios Richard Tovar Cárdenas */
                OR
                (
                    (
                        (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Departamento de Matemáticas" /* o si es del departamento de matematicas */
                        OR
                        (select cccc.name from mdl_course_categories cccc where cccc.id = (REPLACE(SUBSTRING(SUBSTRING_INDEX(ccest.path, "/", 3),LENGTH(SUBSTRING_INDEX(ccest.path, "/", 3-1)) + 1),"/", ''))) = "Centro de Idiomas y Cultura" /* o si es del Centro de Idiomas y Cultura */
                    )
                    AND
                    INSTR(lower(cest.fullname),"derecho") != 0 /* y que dentro del nombre largo tengan la palabra "derecho" */
                )
            )
            ,
            ( /* aplican los filtros de fechas del calendario A y calendario B de Derecho */
                (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2023-01-30") /* Pregrado Calendario A 2022-2023 */
                OR 
                (DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2021-06-16" AND DATE_FORMAT(FROM_UNIXTIME(ueest.timeend), '%Y-%m-%d' ) <= "2022-07-31") /* Pregrado Calendario B 2021-2022 */
            )
            , /* Sino, se aplica el filtro según la fecha normal semestral  */ 
            DATE_FORMAT(FROM_UNIXTIME(ueest.timestart), '%Y-%m-%d' ) >= "2022-01-01"
        )
        AND rest.shortname = "student"
        AND cest.id = c.id
        Order BY cest.id asc
    ) != 0
    Order BY c.id asc
) as "DOCENTES CON AULAS"
,

DATE_FORMAT(CURDATE(), '%d/%m/%Y') as "FECHA DE CORTE DE DATOS (dd/mm/aaaa)"

FROM mdl_course_categories ccc
WHERE (ccc.parent = 2 /* PREGRADO */
OR ccc.parent = 6 /* POSGRADO */
OR ccc.parent = 11) /* EC */
ORDER BY ccc.name ASC