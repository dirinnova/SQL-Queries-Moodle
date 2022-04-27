# SQL Queries Moodle
SQL Queries from moodle 3.9.8+database

## About SQL Queries Moodle

SQL Queries Moodle son consultas a la base de datos de Moodle, que nos devuelve los cursos (aulas) con información de cada uno, desde su datos básicos como nombres y descripciones, números de estudiantes inscritos y categorías a las que pertenece.

Estas consultas estan optimizadas para su uso en:
- El módulo de "Build by SQL" de Intelliboard. [+Info](https://support.intelliboard.net/hc/en-us/articles/360019906731-Max-Report-Builder-Build-by-SQL-Moodle-LMS)
- El Plugin de Moodle: "Ad-hoc database queries". [+Info](https://moodle.org/plugins/report_customsql)

## Database Tables

Las siguientes tablas son las consultadas en la base de datos:

- [mdl_course](#information-about-database-tables)
- [mdl_context](#information-about-database-tables)
- [mdl_role_assignments](#information-about-database-tables)
- [mdl_role](#information-about-database-tables)
- [mdl_user](#information-about-database-tables)
- [mdl_course_categories](#information-about-database-tables)
- [mdl_enrol](#information-about-database-tables)
- [mdl_user_enrolments](#information-about-database-tables)

En las consultas es necesario que cada uno de los nombres se les elimine del nombre el prefijo "mdl_" y luego el nombre se concatena entre corchetes "{}".

## Information About Database Tables

- `course:` Tabla principal que contiene la información básica de los cursos (aulas).
[Más detalles](https://moodleschema.zoola.io/tables/course.html)
- `context:` Tabla intermedia para la relación entre asignaciones de roles de usuarios.
[Más detalles](https://moodleschema.zoola.io/tables/context.html)
- `role_assignments:` Tabla que guarda la asignación de roles de usuarios en diferentes contextos.
[Más detalles](https://moodleschema.zoola.io/tables/role_assignments.html)
- `role:` Tabla que guarda los diferentes roles en Moodle.
[Más detalles](https://moodleschema.zoola.io/tables/role.html)
- `user:` Tabla que guarda los datos de cada usuario.
[Más detalles](https://moodleschema.zoola.io/tables/user.html)
- `course_categories:` Tabla que guarda la información sobre cada categoría de los cursos.
[Más detalles](https://moodleschema.zoola.io/tables/course_categories.html)
- `enrol:` Tabla que guarda la información sobre las instancias de complementos de inscripción utilizados en cursos, los campos marcados como personalizados tienen un significado definido por complemento, el núcleo no los toca. Cree una nueva tabla vinculada si necesita aún más campos personalizados.
[Más detalles](https://moodleschema.zoola.io/tables/enrol.html)
- `user_enrolments:` Tabla que guarda la información sobre los usuarios que participan en cursos (también conocidos como usuarios inscritos): todos los que participan o son visibles en el curso, es decir, tanto profesores como estudiantes.
[Más detalles](https://moodleschema.zoola.io/tables/user_enrolments.html)

