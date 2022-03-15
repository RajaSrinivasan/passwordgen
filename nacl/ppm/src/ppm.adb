with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Command_Line; use Ada.Command_Line ;
with words ;
with words_str ;
with numbers ;
with passwords ;

procedure ppm is
   -- np : Integer := Integer'Value(Argument(1)) ;
   cand : words.CandidateWords_Type ;
begin
   cand := words.Initialize(words_str.words , words_str.SEPARATOR );
   Put_Line(passwords.Generate (wordlist => cand , segs => 3 , sep => "$"));
end ppm ;
