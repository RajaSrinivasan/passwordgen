with gnat.strings ;

package cli is

   VERSION : string := "V01" ;
   NAME : String := "pwdgen" ;
   Verbose : aliased boolean ;

   HelpOption : aliased boolean ;

   WordListFile : aliased GNAT.Strings.String_Access ;
   DefaultWordListFile : aliased String := "wordlist.txt" ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;
   procedure ShowCommandLineArguments ;

   function Get(prompt : string) return String ;
end cli ;
