with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_IO ; use Ada.Integer_Text_IO ;
with ada.strings.unbounded ; use ada.strings.unbounded ;

with Interfaces.C ; use Interfaces.c ;

with words ;
with numbers ;

package body passwords is

   function Generate( wordlist : string ;
                      segs : integer := 2 ;
                      sep : string := "^" ) return string is
      cw : words.CandidateWords_Type ;	
   begin
      cw := words.Initialize(wordlist , words.MAXLENGTH );
      return Generate( cw , segs , sep ) ;
   end Generate ;
   
   function Generate( wordlist : words.CandidateWords_Type ;
                      segs : integer := 2 ;
                      sep : string := "^" 
                     ) return string is
      result : unbounded_string := Null_Unbounded_String ;
      --cw : words.CandidateWords_Type ;	
   begin
      -- cw := words.Initialize(wordlist , words.MAXLENGTH );
      
      for seg in 1..segs
      loop

         if seg mod 2 = 0
         then
            Append(result,words.Choose(wordlist, words.Capitalize)) ; 
         else
            Append(result,words.Choose(wordlist)) ;
         end if ;
         Append(result,sep);
         Append(result,numbers.Generate);
         if seg /= segs
         then
            Append(result,sep) ;
         end if ;
      end loop ;
      return to_string(result) ;
   end Generate ;
   
end passwords;
