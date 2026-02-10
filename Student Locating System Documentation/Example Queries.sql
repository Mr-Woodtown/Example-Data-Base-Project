-- Use this to login on MySQL shell and get to the normal mode. 
/*
\connect DataUser@localhost
\use mystudents
\sql
*/



-- These queries do not have the name of a real student
-- No FERPA Laws were broken in the making of this database. (We would not want that.)
Select HelpDate, s.StudentName, Grade_Lvl
From TimePulled AS t
INNER JOIN Student AS s
ON s.StudentName = t.StudentName
Where s.StudentName = 'Jarelyn Benoit'
Order By HelpDate;

UPDATE Student SET Help_Lvl = 'C'
WHERE StudentName IN ('SomeName', 'List');


Select T.StudentName AS StudentName, StudentPreferenceNotes AS Prefer, 
teach.TeacherName AS TeacherName, Room, EasyToPullFrom
From Taking AS T
INNER JOIN ClassPeriod AS P
ON T.StudentName = P.StudentName
AND T.Period = P.Period
INNER JOIN Teaching AS teach
ON P.TeacherName = teach.TeacherName
AND P.period = teach.period
WHERE T.StudentName = 'Phil Smith'
AND P.Period = 5;



Select StudentName, Help_Lvl FROM Student WHERE Help_Lvl IN ('A', 'B');

SELECT * FROM Student;


SELECT C.StudentName AS StudentName 
FROM Taking AS t 
INNER JOIN ClassPeriod AS C 
ON C.StudentName = t.StudentName 
AND C.Period = t.Period 
INNER JOIN Teaching AS Tch 
ON Tch.TeacherName = C.TeacherName 
AND Tch.Period = C.Period 
WHERE C.TeacherName = 'Webster' 
AND C.Period = 3;


UPDATE Teaching SET EasyToPullFrom = 'yes' 
WHERE Period = 11;

UPDATE Teaching SET EasyToPullFrom = 'yes'
WHERE (TeacherName, Period) IN
	(SELECT TeacherName, Period
	WHERE ClassName LIKE '%Math%'
	AND ClassName NOT LIKE 'H %'
	AND ClassName NOT LIKE 'App %'
	AND ClassName NOT LIKE 'Acc %');

SELECT * 
FROM Teaching
WHERE (TeacherName, Period) IN
	(SELECT TeacherName, Period FROM Teaching
	WHERE ClassName LIKE '%Math%'
	AND ClassName NOT LIKE 'H %'
	AND ClassName NOT LIKE 'App %'
	AND ClassName NOT LIKE 'Acc %');

-- Add other classes, for example gym, Applied Reading 
-- Add CCA, Band and others as a maybe. 
UPDATE Teaching SET EasyToPullFrom = 'yes'
WHERE (TeacherName, Period) IN
	(SELECT TeacherName, Period
	WHERE ClassName = 'Art'
    OR ClassName = 'Spanish'
    OR ClassName = 'Choir'
    OR ClassName = 'Spanish');
    
UPDATE Student SET StudentName = "Changed Name"
Where StudentName = "Unchanged Name";

SELECT TeacherName, Period FROM Teaching
WHERE ClassName = 'Art'
OR ClassName = 'Spanish'
OR ClassName = 'Choir'
OR ClassName = 'Spanish';


SELECT TeacherName, Period, ClassName FROM Teaching
WHERE ClassName LIKE 'Art';


Select T.StudentName AS StudentName, StudentPreferenceNotes AS Prefer, 
teach.TeacherName AS TeacherName, Room, EasyToPullFrom
From Taking AS T
INNER JOIN ClassPeriod AS P
ON T.StudentName = P.StudentName
AND T.Period = P.Period
INNER JOIN Teaching AS teach
ON P.TeacherName = teach.TeacherName
AND P.period = teach.period
WHERE P.Period = 7
AND EasyToPullFrom = 'yes';

Select T.StudentName AS StudentName, StudentPreferenceNotes AS Prefer, 
teach.TeacherName AS TeacherName, ClassName, Lunch, Room, EasyToPullFrom
From Taking AS T
INNER JOIN ClassPeriod AS P
ON T.StudentName = P.StudentName
AND T.Period = P.Period
INNER JOIN Teaching AS teach
ON P.TeacherName = teach.TeacherName
AND P.period = teach.period
WHERE T.StudentName = 'Illiad Esenbarth'
AND P.Period = 7;

-- Recently pulled
SELECT * FROM timepulled
ORDER by HelpDate DESC
Limit 10;
