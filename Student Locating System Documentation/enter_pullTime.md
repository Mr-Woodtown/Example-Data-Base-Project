Description: Allows a user to specify the date a student was pulled. Useful for when the user remembers they met with a student at a later date. 

Input: ('StudentName', 'YYYY-MM-DD') The student's name as it appears in Encore followed by the date they were pulled in the format specified. Does not have a place to specify the period they were pulled. This would have to be done manually with an UPDATE statement, if desired. 

[[Stored Procedures]]

Note: The statement [[Just_Pulled|CALL Just_Pulled();]] automatically enters today's date when the command was run. 