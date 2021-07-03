with gnat.strings ;

package cli is

   VERSION : string := "V01" ;
   NAME : String := "pwdgen" ;
   Verbose : aliased boolean ;

   HelpOption : aliased boolean ;
   dumpOption : aliased boolean ;
   builtinOption : aliased boolean ;
   NumSegments : aliased Integer := 2 ;
   MaxWordLength : aliased Integer := 6 ;
   Iterations : aliased Integer := 3 ;

   Separator : aliased GNAT.Strings.String_Access ;

   WordListFile : aliased GNAT.Strings.String_Access ;
   DefaultWordListFile : aliased String := "wordlist.txt" ;
   DefaultSeparator : aliased String := "-" ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;
   procedure ShowCommandLineArguments ;

   function Get(prompt : string) return String ;
end cli ;
