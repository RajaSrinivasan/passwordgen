with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with GNAT.Command_Line;
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
      Config : GNAT.Command_Line.Command_Line_Configuration;
   begin

      GNAT.Command_Line.Set_Usage
        (Config,
         Help =>
           NAME & " " & VERSION & " " & Compilation_ISO_Date & " " &
           Compilation_Time,
         Usage => "guess");

      GNAT.Command_Line.Define_Switch
        (Config, Verbose'access, Switch => "-v", Long_Switch => "--verbose",
         Help                           => "Output extra verbose information");

      GNAT.Command_Line.Define_Switch
        (Config, NumSegments'access, Switch => "-s", Long_Switch => "--segments",
         Help                           => "Number of Segments");

      GNAT.Command_Line.Define_Switch
        (Config, MaxWordLength'access, Switch => "-m", Long_Switch => "--max-word-length",
         Help                           => "Maximum length of words");


      GNAT.Command_Line.Define_Switch
        (Config, WordListFile'access, Switch => "-f=",
         Long_Switch => "--word-list-file-name=", Help => "Word list file name");

      GNAT.Command_Line.Define_Switch
        (Config, Separator'access, Switch => "-s=",
         Long_Switch => "--separator=", Help => "Separator");


      GNAT.Command_Line.Getopt (Config, SwitchHandler'access);
      if WordListFile.all'Length < 1
      then
         WordListFile := DefaultWordListFile'Access ;
      end if ;

      if Separator.all'Length < 1
      then
         Separator := DefaultSeparator'access ;
      end if ;

      if Verbose
      then
         ShowCommandLineArguments ;
      end if ;

   end ProcessCommandLine;

   function GetNextArgument return String is
   begin
      return GNAT.Command_Line.Get_Argument (Do_Expansion => True);
   end GetNextArgument;

   procedure ShowCommandLineArguments is
   begin
      Put ("Verbose ");
      Put (Verbose);
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

end cli;
