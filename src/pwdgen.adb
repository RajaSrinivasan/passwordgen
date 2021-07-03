with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_Io;
with GNAT.Command_Line ;

with cli ;
with words ;
with numbers ;
with passwords ;
with hex ;
with words_str ;

procedure Pwdgen is
   cw : words.CandidateWords_Type ;
begin
   cli.ProcessCommandLine ;
   if cli.builtinOption
   then
      cw := words.Initialize( words_str.words , ',' , cli.MaxWordLength );
   else
      cw := words.Initialize(cli.WordListFile.all , cli.MaxWordLength );
   end if ;

   if cli.dumpOption
   then
      words.CodeGen(cw) ;
      return ;
   end if ;

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
   if not cli.builtinOption
   then
      Put_Line(passwords.Generate( cli.WordListFile.all ,
               cli.NumSegments ,
               cli.Separator.all ) ) ;
   end if ;

   declare
      pwd : aliased string := cli.GetNextArgument ;
      key : aliased passwords.KeyType := passwords.DeriveKey(pwd,iterations=>cli.Iterations);
   begin
      if pwd'length > 0
      then
         Put("Derived Key for "); Put(pwd); Put_Line(" is ");
         Put(hex.Image(Key'Address,key'length));
         New_Line ;
      end if ;

   end ;

end Pwdgen;
