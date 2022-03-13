with Ada.Text_Io; use Ada.Text_Io ;
with words ;
with words_str ;
with numbers ;
procedure pwdbasic is
   cand : words.CandidateWords_Type ;
begin
   cand := words.Initialize(words_str.words , words_str.SEPARATOR );
   Put( words.Choose(cand) ); Put(":") ;
   Put(numbers.Generate) ;
   Put(":");
   Put( words.Choose(cand) );
   New_Line ;
end pwdbasic ;