SHOW TABLES;
-- Do not run the whole file!!
-- Do not use if you don't know what you're doing!
-- Turn off auto commit above.

START TRANSACTION;

SELECT StudentName, Grade_Lvl
FROM Student
ORDER BY StudentName;

CALL advance_grd_lvl ();

SELECT StudentName, Grade_Lvl
FROM Student
ORDER BY StudentName;