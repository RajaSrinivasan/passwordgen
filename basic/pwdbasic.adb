with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Command_Line; use Ada.Command_Line ;
with words ;
with words_str ;
with numbers ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
procedure pwdbasic is
   np : Integer := 2 ; -- 
   ns : Integer := 2 ;
   minlen : Integer := 12 ;
   separator : Unbounded_String := To_Unbounded_String(":") ;
   cand : words.CandidateWords_Type ;
   pwd : Unbounded_String ;
begin
   if Argument_Count >= 1
   then
      np := Integer'Value(Argument(1)) ;
   end if ;
   if Argument_Count >= 2
   then
      separator := To_Unbounded_String(Argument(2));
   end if ;
   if Argument_Count >= 3
   then
      ns := Integer'Value(Argument(3)) ;
   end if ;
   if Argument_Count >= 4
   then
      minlen := Integer'Value(Argument(4)) ;
   end if ;

   cand := words.Initialize(words_str.words , words_str.SEPARATOR );
   for p in 1..np
   loop
      pwd := Null_Unbounded_String ;
      for seg in 1..ns
      loop
         Append(pwd,words.Choose(cand)) ;
         Append(pwd,separator) ;
         Append(pwd,numbers.Generate) ;
         Append(pwd,separator) ;
         Append(pwd,words.Choose(cand,words.Capitalize));
         if Length(pwd) >= minlen
         then
            exit ;
         end if ;
         Append(pwd,separator);
       end loop ;
       Put_Line(To_String(pwd)); 
   end loop ;
end pwdbasic ;