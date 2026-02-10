-- Creation script for the Student Locating Database System
USE mystudents;

SHOW TABLES;

-- Drop all foreign key constriants 
/*
ALTER TABLE Teaching DROP CONSTRAINT FK_Teaching;
ALTER TABLE ClassPeriod DROP CONSTRAINT FK_ClassPeriod1;
ALTER TABLE ClassPeriod DROP CONSTRAINT FK_ClassPeriod2;
ALTER TABLE Taking DROP CONSTRAINT FK_Taking;
ALTER TABLE Student DROP CONSTRAINT FK_Student;
ALTER TABLE TimePulled DROP CONSTRAINT FK_TimePulled1;
*/

-- Drop all tables 
DROP TABLE IF EXISTS Teacher;
DROP TABLE IF EXISTS Teaching;
DROP TABLE IF EXISTS ClassPeriod;
DROP TABLE IF EXISTS Taking;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS TimePulled;
DROP TABLE IF EXISTS HelpLevel;

-- Create tables
CREATE TABLE Teacher(
	TeacherName	VARCHAR(15),
    Office 		VARCHAR(6) NOT NULL,
    Lunch		TINYINT UNSIGNED NOT NULL,
    TeacherNotes VARCHAR(160),
    PRIMARY KEY (TeacherName)
);

CREATE TABLE Teaching(
	TeacherName	VARCHAR(15),
    Period		TINYINT UNSIGNED,
    ClassName	VARCHAR(20) NOT NULL,
    Room		VARCHAR(6) NOT NULL,
    EasyToPullFrom	VARCHAR(3), -- CHECK (EasyToPUllFrom IN ('yes', 'no', 'may'))
	CONSTRAINT PK_Teaching PRIMARY KEY (TeacherName, Period)
);
-- Add foreign key referencing Teacher

CREATE TABLE ClassPeriod(
	TeacherName	VARCHAR(15),
    StudentName VARCHAR(30),
    Period		TINYINT UNSIGNED,
    CONSTRAINT PK_ClassPeriod PRIMARY KEY (TeacherName, StudentName, Period)
);
-- Add foreign keys for all. Period comes from Teacher (as well as Student).

CREATE TABLE Taking(
	StudentName	VARCHAR(30),
    Period		TINYINT UNSIGNED,
    StudentPreferenceNotes VARCHAR(80),
    CONSTRAINT PK_Taking PRIMARY KEY (StudentName, Period)
);
-- Add foreign key StudentName

-- Note: Grade_LVl may need to be made a part of primary key if mulitple students wiht the same name are pulled. 
CREATE TABLE Student(
	StudentName	VARCHAR(30),
    Grade_Lvl	TINYINT UNSIGNED NOT NULL,
    WorkEthic	VARCHAR(256),
    Aprox_MathGrade	VARCHAR(3),
    Help_Lvl	CHAR(1) NOT NULL DEFAULT 'C' CHECK (Help_Lvl IN ('A','B','C')),
	PRIMARY KEY (StudentName)
);

CREATE TABLE TimePulled(
	SyntheticKey SMALLINT UNSIGNED NOT NUll AUTO_INCREMENT,
    StudentName	VARCHAR(30) NOT NULL,
    HelpDate	DATE NOT NULL DEFAULT (CURDATE()),
    PeriodPulled	TINYINT UNSIGNED NOT NULL DEFAULT 0,
    SessionNotes VARCHAR(256),
    PRIMARY KEY (SytheticKey)    
);

CREATE TABLE HelpLevel(
	Help_Lvl 	CHAR(1) 	CHECK (Help_Lvl IN ('A','B','C')),
    Help_Lvl_Description	VARCHAR(256),
    PRIMARY KEY (Help_Lvl)
);

-- ALTER TABLE TimePulled CHANGE SytheticKey SyntheticKey SMALLINT UNSIGNED;

-- Add foreign keys
ALTER TABLE Teaching
ADD CONSTRAINT FK_Teaching FOREIGN KEY (TeacherName) REFERENCES Teacher(TeacherName)
ON UPDATE CASCADE;

ALTER TABLE ClassPeriod
ADD CONSTRAINT FK_ClassPeriod1 FOREIGN KEY (TeacherName, Period) 
REFERENCES Teaching(TeacherName, Period);

ALTER TABLE ClassPeriod
ADD CONSTRAINT FK_ClassPeriod2 FOREIGN KEY (StudentName, Period) 
REFERENCES Taking(StudentName, Period)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Taking
ADD CONSTRAINT FK_Taking FOREIGN KEY (StudentName) REFERENCES Student(StudentName) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Student
ADD CONSTRAINT FK_Student FOREIGN KEY (Help_Lvl) REFERENCES HelpLevel(Help_Lvl);

ALTER TABLE TimePulled
ADD CONSTRAINT FK_TimePulled1 FOREIGN KEY (StudentName) REFERENCES Student(StudentName) ON DELETE CASCADE ON UPDATE CASCADE;


-- Commented code is for live tweeks when building the Database 
-- ALTER TABLE HelpLevel MODIFY COLUMN Help_Lvl_Description VARCHAR(265);
-- ALTER TABLE TimePulled RENAME COLUMN Hlp_Date TO HelpDate;
-- ALTER TABLE TimePulled MODIFY COLUMN SyntheticKey SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT;

-- HelpLevel Table setup
INSERT INTO HelpLevel (Help_Lvl, Help_Lvl_Description) VALUES ('A', 'This level needs consitaint help. Generally because of needing a mentor figure or extra encouragement to do their assignments on their own.');
INSERT INTO HelpLevel (Help_Lvl, Help_Lvl_Description) VALUES ('B', 'Really close to passing and might need extra help. Usually capable of doing things on their own. Check in on these students every two weeks or so to make sure they are doing well.');
INSERT INTO HelpLevel (Help_Lvl, Help_Lvl_Description) VALUES ('C', 'Best case scenario they only needed help a handful of times due to a particularly difficult concept for them. Worst case they do absolutely nothing. Essentially taken off our help list and shelved. They will likely not need help within the school term.');

-- UPDATE HelpLevel SET Help_Lvl_Description = 'Best case scenario they only needed help a handful of times due to a particularly difficult concept for them. Worst case they do absolutely nothing. Essentially taken off our help list and shelved. They will likely not need help within the school term.' WHERE Help_Lvl = 'C';


-- Stored Procedures
/* Legacy Version
DELIMITER //
CREATE DEFINER = root
PROCEDURE advance_grd_lvl ()
BEGIN
	DELETE FROM STUDENTS
    WHERE Grade_Lvl = 9;
    
    UPDATE STUDENTS
    SET Grade_Lvl = 8
    WHERE Grade_Lvl = 7;
    
    UPDATE STUDENTS
    SET Grade_Lvl = 9
    WHERE GRADE_Lvl = 8;
END //
DELIMITER ;
*/

DROP PROCEDURE IF EXISTS advance_grd_lvl;
DROP PROCEDURE IF EXISTS enter_pulltime;
DROP PROCEDURE IF EXISTS just_pulled;
DROP PROCEDURE IF EXISTS studentSessions;
DROP PROCEDURE IF EXISTS teacherLunch;
DROP PROCEDURE IF EXISTS stdPerLun;
DROP PROCEDURE IF EXISTS stdPerNotLun;
DROP PROCEDURE IF EXISTS studentPeriod;
DROP PROCEDURE IF EXISTS update_grade;
DROP PROCEDURE IF EXISTS CurPeriodNotLun;
DROP PROCEDURE IF EXISTS CurPeriodLun;
DROP PROCEDURE IF EXISTS easy_pull;
DROP PROCEDURE IF EXISTS recent_pull;
DROP PROCEDURE IF EXISTS s_Schedule;
DROP PROCEDURE IF EXISTS update_workEth;

DELIMITER //
CREATE PROCEDURE advance_grd_lvl ()
BEGIN
	UPDATE STUDENT
    SET Grade_Lvl = Grade_Lvl + 1
    WHERE Grade_Lvl IN (7, 8, 9);
    
    DELETE FROM STUDENT
    WHERE Grade_Lvl = 10;
    
    SELECT * 
    FROM STUDENT
    WHERE Grade_Lvl NOT IN (7, 8, 9);
END //
DELIMITER ;

CREATE PROCEDURE enter_pulltime (IN S_Name CHAR(30), IN Entered_Date DATE)
	INSERT INTO TimePulled (StudentName, HelpDate) VALUES (S_Name, Entered_Date);

DELIMITER //
CREATE PROCEDURE just_pulled (IN S_Name CHAR(30), IN Cur_Period TINYINT UNSIGNED)
BEGIN
	INSERT INTO TimePulled (StudentName, PeriodPulled) VALUES (S_Name, Cur_Period);
    SELECT StudentName, HelpDate 
    FROM TimePulled 
    WHERE StudentName = S_Name
    ORDER BY HelpDate DESC
    LIMIT 4;    
END //
DELIMITER ;

CREATE PROCEDURE studentSessions (IN S_Name CHAR(30))
	Select HelpDate, StudentName
	From TimePulled
	Where StudentName = S_Name
    Order By HelpDate desc;

CREATE PROCEDURE teacherLunch (IN T_Name VARCHAR(20))
	SELECT TeacherName, Lunch
    FROM Teacher
    WHERE TeacherName = T_Name;

CREATE PROCEDURE stdPerLun (IN S_name VARCHAR(30), IN Cur_Period TINYINT)
Select T.StudentName AS StudentName, StudentPreferenceNotes AS Prefer, 
teach.TeacherName AS TeacherName, ClassName, Lunch, Room, EasyToPullFrom
From Taking AS T
INNER JOIN ClassPeriod AS P
ON T.StudentName = P.StudentName
AND T.Period = P.Period
INNER JOIN Teaching AS teach
ON P.TeacherName = teach.TeacherName
AND P.period = teach.period
INNER JOIN Teacher AS tch
ON tch.TeacherName = teach.TeacherName
WHERE T.StudentName = S_Name
AND P.Period = Cur_Period;

CREATE PROCEDURE stdPerNotLun (IN S_name VARCHAR(30), IN Cur_Period TINYINT)
Select T.StudentName AS StudentName, StudentPreferenceNotes AS Prefer, 
teach.TeacherName AS TeacherName, ClassName, Room, EasyToPullFrom
From Taking AS T
INNER JOIN ClassPeriod AS P
ON T.StudentName = P.StudentName
AND T.Period = P.Period
INNER JOIN Teaching AS teach
ON P.TeacherName = teach.TeacherName
AND P.period = teach.period
WHERE T.StudentName = S_Name
AND P.Period = Cur_Period;

DELIMITER //
CREATE Procedure studentPeriod (IN S_Name VARCHAR(30), IN Cur_Period tinyint)
BEGIN
	-- Declares a control flow variable
	DECLARE is_not_lunch BOOLEAN DEFAULT FALSE;
    
	IF Cur_Period != 7 AND Cur_Period != 3 THEN
		SET is_not_lunch = TRUE;
	END IF;
    
    IF is_not_lunch THEN
		CALL stdPerNotLun(S_Name, Cur_period);
	ELSE 
		CALL stdPerLun(S_Name, Cur_period);
    END IF;
END //
DELIMITER ;

CREATE PROCEDURE update_grade (IN S_Name Varchar(30), IN Grade Varchar(3))
UPDATE Student SET Aprox_MathGrade = Grade 
WHERE StudentName = S_Name;

CREATE procedure CurPeriodNotLun (IN Cur_Period TINYINT)
Select T.StudentName AS StudentName, StudentPreferenceNotes AS Prefer,  ClassName AS Class,
teach.TeacherName AS TeacherName, Room, EasyToPullFrom
From Taking AS T
INNER JOIN Student AS s
ON s.StudentName = T.StudentName
INNER JOIN ClassPeriod AS P
ON T.StudentName = P.StudentName
AND T.Period = P.Period
INNER JOIN Teaching AS teach
ON P.TeacherName = teach.TeacherName
AND P.period = teach.period
WHERE P.Period = Cur_Period
AND EasyToPullFrom IN ('yes', 'may')
AND Help_Lvl IN ('A','B');

CREATE PROCEDURE CurPeriodLun (IN Cur_Period TINYINT)
Select T.StudentName AS StudentName, StudentPreferenceNotes AS Prefer, ClassName AS Class,
teach.TeacherName AS TeacherName, Room, Lunch, EasyToPullFrom
From Taking AS T
INNER JOIN Student AS s
ON s.StudentName = T.StudentName
INNER JOIN ClassPeriod AS P
ON T.StudentName = P.StudentName
AND T.Period = P.Period
INNER JOIN Teaching AS teach
ON P.TeacherName = teach.TeacherName
AND P.period = teach.period
INNER JOIN Teacher AS tch
ON teach.TeacherName = tch.TeacherName
WHERE P.Period = Cur_Period
AND EasyToPullFrom IN ('yes', 'may')
AND Help_Lvl IN ('A','B');

-- Gives a list of students who are easy to pull out of class in the current period. EP stands for easy pull. 
DELIMITER //
CREATE Procedure easy_pull (IN Cur_Period TINYINT)
BEGIN
	-- Declares a control flow variable
	DECLARE is_not_lunch BOOLEAN DEFAULT FALSE;
    
	IF Cur_Period != 7 AND Cur_Period != 3 THEN
		SET is_not_lunch = TRUE;
	END IF;
    
    IF is_not_lunch THEN
		CALL CurPeriodNotLun(Cur_period);
	ELSE 
		CALL CurPeriodLun(Cur_Period);
    END IF;
END //
DELIMITER ;

-- Recently pulled
CREATE PROCEDURE recent_pull()
SELECT * FROM timepulled
ORDER by HelpDate DESC
Limit 10;

CREATE PROCEDURE s_schedule(IN S_Name Varchar(30))
SELECT c.StudentName AS StudentName, StudentPreferenceNotes, c.Period, ClassName
FROM ClassPeriod AS C
INNER JOIN Taking AS t
ON C.StudentName = t.studentName
AND C.period = t.period
INNER JOIN Teaching as tch
ON tch.TeacherName = c.TeacherName
AND tch.Period = c.Period
WHERE c.StudentName = S_Name;

CREATE PROCEDURE update_workEth(IN S_Name Varchar(30), IN Notes Varchar(255))
UPDATE Student SET WorkEthic = Notes
WHERE StudentName = S_Name;

-- Procedure Permissions
-- GRANT EXECUTE ON PROCEDURE <Procedure_Name> TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE just_pulled TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE enter_pulltime TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE studentSessions TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE teacherLunch TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE studentPeriod TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE update_grade TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE easy_pull TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE recent_pull TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE s_schedule TO 'DataUser'@'localhost';
GRANT EXECUTE ON PROCEDURE update_workEth TO 'DataUser'@'localhost';


-- INDEXES
CREATE INDEX ON TimePulled (StudentName DESC);

