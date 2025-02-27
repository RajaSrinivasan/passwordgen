with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Command_Line; use Ada.Command_Line ;

with TOML ;
with Clic.tty ;
with clic.config ;
with clic.config.load ;

with SparkNacl.Hashing ;
with hex ;
with cli ;
with words ;
with words_str ;
with numbers ;
with passwords ;
with kdf ;

procedure ppm is
   np : Integer := 2 ;
   cand : words.CandidateWords_Type ;
   instance : clic.config.Instance ;
   cfg : toml.TOML_Value ;
begin
   cfg := clic.Config.Load.Load_TOML_File (Argument(1));
   clic.config.Import (This => instance , Table => cfg , Origin => "ppm.toml");
   cand := words.Initialize(words_str.words , words_str.SEPARATOR );
   clic.tty.Enable_Color ;
   Put_Line(Clic.tty.Emph(passwords.Generate (wordlist => cand , 
       segs => Integer(clic.config.Get(instance,"segments",2)) , 
       sep => clic.config.Get_As_String(instance,"separator"))));
   declare
      pwd : aliased String := cli.GetNoEcho ("Password");
      naclKey : Sparknacl.Hashing.Digest ;
   begin
      Put_Line(pwd) ;
      Put_Line(kdf.DeriveKey(pwd));
      naclKey := kdf.DeriveKey(pwd);
      Put_Line(Hex.Image(naclKey'Address,naclKey'Size/8));
   end ;

end ppm ;
