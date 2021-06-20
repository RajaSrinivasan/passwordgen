with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_Io;
with GNAT.Command_Line ;

with cli ;
with words ;
with numbers ;
with passwords ;
with hex ;

procedure Pwdgen is
   cw : words.CandidateWords_Type ;
begin
   cli.ProcessCommandLine ;
   cw := words.Initialize(cli.WordListFile.all , cli.MaxWordLength );
   for s in 1..cli.NumSegments
   loop
      if s mod 2 = 0
      then
         Ada.Text_Io.Put( words.Choose(cw, words.Capitalize) );
      else
         Ada.Text_Io.Put( words.Choose(cw) );
      end if ;
      Put(cli.Separator.all);
      Ada.Text_Io.Put( numbers.Generate ) ;
      if s /= cli.NumSegments
      then
         Put(cli.Separator.all);
      end if;
   end loop ;
   New_Line ;
   Put_Line(passwords.Generate( cli.WordListFile.all ,
            cli.NumSegments ,
            cli.Separator.all ) ) ;
   declare
      pwd : aliased string := cli.GetNextArgument ;
      key : aliased passwords.KeyType := passwords.DeriveKey(pwd,iterations=>cli.Iterations);
   begin
      Put("Derived Key for "); Put(pwd); Put_Line(" is ");
      Put(hex.Image(Key'Address,key'length));
      New_Line ;
   end ;

end Pwdgen;
