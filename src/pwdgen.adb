with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_Io;
with GNAT.Command_Line ;

with cli ;
with words ;
with numbers ;
with passwords ;
with passwords.kdf ;

with hex ;
with words_str ;

procedure Pwdgen is
   cw : words.CandidateWords_Type ;
begin
   cli.ProcessCommandLine ;

   if cli.deriveOption
   then
      declare
         pwd : aliased string := cli.GetNextArgument ;
         key : aliased passwords.kdf.KeyType := passwords.kdf.DeriveKey(pwd,iterations=>cli.Iterations);
      begin
         if pwd'length > 0
         then
            Put("Derived Key for "); Put(pwd); Put_Line(" is ");
            Put(hex.Image(Key'Address,key'length));
            New_Line ;
         end if ;
      end ;
      return ;
   end if ;

   if cli.dumpOption
   then
      if cli.builtinOption
      then
         cw := words.Initialize( words_str.words , words_str.SEPARATOR , cli.MaxWordLength );
      else
         cw := words.Initialize(cli.WordListFile.all , cli.MaxWordLength );
      end if ;
      words.CodeGen(cw) ;
      return ;
   end if ;

   if cli.builtinOption
   then
      Put_Line(passwords.Generate( words_str.words ,
               cli.NumSegments ,
               cli.Separator.all ) ) ;
   else
      Put_Line(passwords.Generate( cli.WordListFile.all ,
               cli.NumSegments ,
               cli.Separator.all ) ) ;
   end if ;


end Pwdgen;
