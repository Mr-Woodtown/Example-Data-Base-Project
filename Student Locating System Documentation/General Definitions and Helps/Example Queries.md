---
aliases:
  - example queries
---

Click the link to be taken back to the [[Starting Page|Main Starting Page]].

Note: The commands given to mySQL and table names are not case sensitive. Importantly, data within the database is. For example, typing "StUdenT" for the student table **will not** confuse mySQL for that table's name. "George jefferson" however, **will** confuse mySQL (and thus, even more so the user) as there isn't an exact match in the data.
Even though the commands do not need to be a specific case it is common to write the commands in all caps to help distinguish from the Tables and data. 

##### Selects the all the times we have tutored a student. 
Select HelpDate, s.StudentName, Grade_Lvl
From TimePulled AS t
INNER JOIN Student AS s
ON s.StudentName = t.StudentName
Where s.StudentName = 'Jarelyn Benoit'
Order By HelpDate;

##### Selects all students that are help level "B" or higher.
Select StudentName FROM Students WHERE Help_Lvl IN ('A', 'B');

##### Selects a student named Phil Smith and information about their Advisory Period. 
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
AND P.Period = 11;


INSERT INTO Student