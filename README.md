# SQL's Moodle
SQL's reports from moodle 3.9.8+database

## About SQL's Moodle

SQL's reports son listados de cursos (aulas), con información de cada uno, desde su datos básicos como nombres y descripciones, números de estudiantes inscritos y categorías a las que pertenece.

## Database Tables

Las siguientes tablas son las consultadas en la base de datos:

- mdl_course
- mdl_context
- mdl_role_assignments
- mdl_role
- mdl_user
- mdl_course_categories
- mdl_enrol
- mdl_user_enrolments

En las consultas es necesario que cada uno de los nombres se les elimine del nombre el prefijo "mdl_" y luego el nombre se concatena entre corchetes "{}".

## Descripcion Database Tables

### **Table course:**
Tabla principal que contiene la información básica de los cursos (aulas).
[Más detalles](https://moodleschema.zoola.io/tables/course.html)

### **Table context:**
Tabla intermedia para la relación entre asignaciones de roles de usuarios.
[Más detalles](https://moodleschema.zoola.io/tables/context.html)

### **Table role_assignments:**
Tabla que guarda la asignación de roles de usuarios en diferentes contextos.
[Más detalles](https://moodleschema.zoola.io/tables/role_assignments.html)

### **Table role:**
Tabla que guarda los diferentes roles en Moodle.
[Más detalles](https://moodleschema.zoola.io/tables/role.html)

### **Table user:**
Tabla que guarda los datos de cada usuario.
[Más detalles](https://moodleschema.zoola.io/tables/user.html)

### **Table course_categories:**
Tabla que guarda la información sobre cada categoría de los cursos.
[Más detalles](https://moodleschema.zoola.io/tables/course_categories.html)

### **Table enrol:**
Tabla que guarda la información sobre las instancias de complementos de inscripción utilizados en cursos, los campos marcados como personalizados tienen un significado definido por complemento, el núcleo no los toca. Cree una nueva tabla vinculada si necesita aún más campos personalizados.
[Más detalles](https://moodleschema.zoola.io/tables/enrol.html)

### **Table user_enrolments:**
Tabla que guarda la información sobre los usuarios que participan en cursos (también conocidos como usuarios inscritos): todos los que participan o son visibles en el curso, es decir, tanto profesores como estudiantes.
[Más detalles](https://moodleschema.zoola.io/tables/user_enrolments.html)