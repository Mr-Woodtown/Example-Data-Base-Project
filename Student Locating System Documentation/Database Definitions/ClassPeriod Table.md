Only exists for telling which students are in which classes at which times.  
## Table Columns
[[TeacherName]]    [[Primary Key]]  [[Foreign Key]]  References Teaching
[[StudentName]]    [[Primary Key]]  [[Foreign Key]] [[On Delete Cascade]] References Taking
[[Period]]    [[Primary Key]]  [[Foreign Key]]  References Teaching and Taking


Click the link to be taken back to the [[Database Glossary|Glossary]]. 