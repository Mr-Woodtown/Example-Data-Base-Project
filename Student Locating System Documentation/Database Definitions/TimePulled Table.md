This is a table to keep track of when we have pulled students. Crucial for us to query when we last saw a student. Anticipated to be one of the most commonly used functions of the system.
If period pulled was not optional it would be the primary key. This decision was made to make it suitable for the period not to be included and thus multiple students being pulled per period allowed in the system. It is also a foreign key to the taking table. 
The date could sub in for the period in the potential primary key.
## Table Columns
[[SyntheticKey]]    [[Primary Key]] 
[[StudentName]]    [[Foreign Key]]  [[On Delete Cascade]] References Student  [[Candidate Key]]
[[HelpDate]]    [[Candidate Key]]  [[Nonnull Default]] Default (Today's date)
[[Period|PeriodPulled]]    [[Candidate Key]] (If made non-optional)  [[Optional]]  [[Nonnull Default]] Default Period: 0
[[SessionNotes]] [[Optional]]


Click the link to be taken back to the [[Database Glossary|Glossary]].