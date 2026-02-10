---
aliases:
  - Glossary
  - database glossary
---
This is a database glossary. It is used to help define what parts of the database mean in the real world and how they are defined in the program. 
There are tags to the right of the values to help identify their significance and role in the table. A description of the layout of the [[Value Pages Structure|value pages]] will be linked. A description of the layout of the [[Table Description Page Structure|table pages]] will also be linked. 

These column names often do not have spaces due to [[SQL Naming Conventions and Restrictions|MySQL conventions]].

# Tables and Their Columns
## [[Teacher Table]]
[[TeacherName]] [[Primary Key|PK]]
[[Office]]
[[Lunch]]
[[TeacherNotes]]  [[Optional|O]]
## [[Teaching Table]]
[[TeacherName]] [[Primary Key|PK]] [[Foreign Key|FK]]
[[Period]] [[Primary Key|PK]]
[[ClassName]]
[[Room]]
[[EasyToPullFrom]] [[Optional|O]]
## [[ClassPeriod Table]]
[[TeacherName]] [[Primary Key|PK]] [[Foreign Key|FK]]
[[StudentName]] [[Primary Key|PK]] [[Foreign Key|FK]][[On Delete Cascade|(ODC)]]
[[Period]] [[Primary Key|PK]] [[Foreign Key|FK]]
## [[Taking Table]]
[[StudentName]] [[Primary Key|PK]] [[Foreign Key|FK]][[On Delete Cascade|(ODC)]]
[[Period]] [[Primary Key|PK]]
[[StudentPreferenceNotes]] [[Optional|O]]
## [[Student Table]]
[[StudentName]] [[Primary Key|PK]]
[[Grade_Lvl]]
[[WorkEthic]] [[Optional|O]]
[[Aprox_MathGrade]] [[Optional|O]]
[[Help_Lvl]] [[Foreign Key|FK]] [[Nonnull Default|ND]] 
## [[TimePulled Table]]
[[SyntheticKey]] [[Primary Key|PK]] 
[[StudentName]] [[Foreign Key|FK]][[On Delete Cascade|(ODC)]] [[Candidate Key|CK]]
[[HelpDate]] [[Candidate Key|CK]] [[Nonnull Default|ND]] 
[[Period|PeriodPulled]] [[Candidate Key|CK]] [[Optional|O]] [[Nonnull Default|ND]] 
[[SessionNotes]] [[Optional|O]]
## [[HelpLevel Table]]
[[Help_Lvl]] [[Primary Key|PK]]
[[Help_Lvl_Description]] 

Click the link to be taken back to the [[Starting Page|Main Starting Page]].