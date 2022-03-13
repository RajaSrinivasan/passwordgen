with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Command_Line; use Ada.Command_Line ;
with words ;
with words_str ;
with numbers ;
procedure pwdbasic is
   np : Integer := Integer'Value(Argument(1)) ;
   cand : words.CandidateWords_Type ;
begin
   cand := words.Initialize(words_str.words , words_str.SEPARATOR );
   for p in 1..np
   loop
    Put( words.Choose(cand) ); Put(":") ;
    Put(numbers.Generate) ;
    Put(":");
    Put( words.Choose(cand, words.Capitalize)  );
    New_Line ;
   end loop ;
end pwdbasic ;