# SQL Queries Moodle
SQL Queries from moodle 3.9.8+database

## About SQL Queries Moodle

SQL Queries Moodle are queries to the Moodle database, which returns the courses (classrooms) with information on each one, from their basic data such as names and descriptions, numbers of registered students and categories to which they belong.

These queries are optimized for use in:
- Intelliboard's "Build by SQL" module. [+Info](https://support.intelliboard.net/hc/en-us/articles/360019906731-Max-Report-Builder-Build-by-SQL-Moodle-LMS)
- The Moodle Plugin: "Ad-hoc database queries". [+Info](https://moodle.org/plugins/report_customsql)

## Database Tables

The following tables are queried in the database:

- [mdl_course](#information-about-database-tables)
- [mdl_context](#information-about-database-tables)
- [mdl_role_assignments](#information-about-database-tables)
- [mdl_role](#information-about-database-tables)
- [mdl_user](#information-about-database-tables)
- [mdl_course_categories](#information-about-database-tables)
- [mdl_enrol](#information-about-database-tables)
- [mdl_user_enrolments](#information-about-database-tables)

In the queries it's necessary that each one of the names is removed from the name the prefix "mdl_" and then the name is concatenated between square brackets "{}".

## Information About Database Tables

- `course:` Main table that contains the basic information of the courses (classrooms).
[+Info](https://moodleschema.zoola.io/tables/course.html)
- `context:` Intermediate table for the relationship between user role assignments.
[+Info](https://moodleschema.zoola.io/tables/context.html)
- `role_assignments:` Table that stores the assignment of user roles in different contexts.
[+Info](https://moodleschema.zoola.io/tables/role_assignments.html)
- `role:` Table that stores the different roles in Moodle.
[+Info](https://moodleschema.zoola.io/tables/role.html)
- `user:` Table that stores the data of each user.
[+Info](https://moodleschema.zoola.io/tables/user.html)
- `course_categories:` Table that stores the information about each category of the courses.
[+Info](https://moodleschema.zoola.io/tables/course_categories.html)
- `enrol:` Table that stores information about instances of enrollment plugins used in courses, fields marked as custom have a plugin-defined meaning, they are not touched by the kernel. Create a new linked table if you need even more custom fields.
[+Info](https://moodleschema.zoola.io/tables/enrol.html)
- `user_enrolments:` Table that stores information about users who participate in courses (also known as enrolled users): all those who participate or are visible in the course, that is, both teachers and students.
[+Info](https://moodleschema.zoola.io/tables/user_enrolments.html)

