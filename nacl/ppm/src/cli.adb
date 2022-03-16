with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Clic.Command_Line;
with GNAT.Source_Info; use GNAT.Source_Info;

package body cli is

   package boolean_text_io is new Enumeration_IO (Boolean);
   use boolean_text_io;

   procedure SwitchHandler
     (Switch : String; Parameter : String; Section : String)
   is
   begin
      Put ("SwitchHandler " & Switch);
      Put (" Parameter " & Parameter);
      Put (" Section " & Section);
      New_Line;
   end SwitchHandler;

   procedure ProcessCommandLine is
      Config : Clic.Command_Line.Command_Line_Configuration;
   begin

      Clic.Command_Line.Set_Usage
        (Config,
         Help =>
           NAME & " " & VERSION & " " & Compilation_ISO_Date & " " &
           Compilation_Time,
         Usage => "[switches] [password to derive key for]");

      Clic.Command_Line.Define_Switch
        (Config, Verbosity'access, Switch => "-v", Long_Switch => "--verbose",
         Help                           => "Output extra verbose information");

      Clic.Command_Line.Define_Switch
        (Config, NumSegments'access, Switch => "-s=", Long_Switch => "--segments=",
         Initial => 2 , Default => 2 ,
         Help                           => "Number of Segments");

      Clic.Command_Line.Define_Switch
        (Config, MaxWordLength'access, Switch => "-m=", Long_Switch => "--max-word-length=",
         Initial => 8 , Default => 6 ,
         Help                           => "Maximum length of words");

      Clic.Command_Line.Define_Switch
        (Config, WordListFile'access, Switch => "-f=",
         Long_Switch => "--word-list-file-name=", Help => "Word list file name");

      Clic.Command_Line.Define_Switch
        (Config, Separator'access, Switch => "-p=",
         Long_Switch => "--separator=", Help => "Separator");

      Clic.Command_Line.Define_Switch
        (Config, Iterations'access, Switch => "-i=",
         Long_Switch => "--iterations=",
         Initial => 2 , Default => 2 ,
         Help => "Iterations for key derivation");

      Clic.Command_Line.Define_Switch
        (Config, dumpOption'access, Switch => "-d", Long_Switch => "--dump-spec",
         Help                           => "Dump ada spec");

      Clic.Command_Line.Define_Switch
        (Config, builtinOption'access,
                 Switch => "-b", Long_Switch => "--builtin-wordlist",
         Help                           => "use builtin wordlist");

      Clic.Command_Line.Define_Switch
        (Config, deriveOption'access,
                 Switch => "-k", Long_Switch => "--derive-key",
         Help                           => "derive key");

      Clic.Command_Line.Getopt (Config, SwitchHandler'access);
      if WordListFile.all'Length < 1
      then
         WordListFile := DefaultWordListFile'Access ;
      end if ;

      if Separator.all'Length < 1
      then
         Separator := DefaultSeparator'access ;
      end if ;

      if Verbosity > 0
      then
         ShowCommandLineArguments ;
      end if ;

   end ProcessCommandLine;

   function GetNextArgument return String is
   begin
      return Clic.Command_Line.Get_Argument (Do_Expansion => True);
   end GetNextArgument;

   procedure ShowCommandLineArguments is
   begin
      Put ("Verbosity ");
      Put (Verbosity);
      New_Line;

      Put("Maximum Word legnth ");
      Put(MaxWordLength);
      New_line ;

      Put("Number of segments ");
      put(NumSegments);
      New_Line ;

      Put("Word list Filename ");
      Put(WordListFile.all);
      New_Line ;

      Put("Separator ");
      Put(Separator.all);
      New_Line ;

   end ShowCommandLineArguments;

   function Get(Prompt : string) return string is
      result : String(1..80);
      len : natural ;
   begin
      Ada.Text_Io.Put(Prompt) ; Ada.Text_Io.Put(" > "); Ada.Text_Io.Flush ;
      Ada.Text_Io.Get_Line(result,len);
      return result(1..len);
   end Get ;

   function GetNoEcho(prompt : string) return String is
      result : String(1..80);
      len : natural := 0 ;
      c : Character := ASCII.NUL;
   begin
      Ada.Text_Io.Put(Prompt) ; Ada.Text_Io.Put(" : "); Ada.Text_Io.Flush ;
      while c /= ASCII.LF
      loop
         Ada.Text_Io.Get_Immediate (c) ;
         if c /= ASCII.LF
         then
            len := len + 1 ;
            result(len) := c ;
        end if ;
      end loop ;
      Ada.Text_Io.Put(ASCII.LF) ;
      return result(1..len);
   end GetNoEcho ;

end cli;

