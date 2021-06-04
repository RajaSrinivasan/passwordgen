with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_Io;
with GNAT.Command_Line ;

with cli ;
with words ;
with numbers ;

procedure Pwdgen is
   cw : words.CandidateWords_Type ;
begin
   cli.ProcessCommandLine ;
   cw := words.Initialize(cli.WordListFile.all );
   Ada.Text_Io.Put( words.Choose(cw) );
   Put("-");
   Ada.Text_Io.Put( numbers.Generate ) ;
   Put("-");
   Ada.Text_Io.Put( words.Choose(cw,words.Capitalize) );
   Put("-");
   Ada.Text_Io.Put( numbers.Generate ) ;
   New_Line ;
end Pwdgen;
