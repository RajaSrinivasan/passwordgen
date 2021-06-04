with Ada.Containers.Vectors ;

package words is
   
   debug : boolean := false ;
   
   MAXLENGTH : constant Integer := 32 ;
   subtype Word_Type is string(1..MAXLENGTH) ;
   subtype MaxWordsType is integer range 1..500_000 ; 
   package Words_Pkg is new Ada.Containers.Vectors ( MaxWordsType, Word_Type ) ;
   type CandidateWords_Type is
      record
         words : Words_Pkg.Vector ;
      end record ;
   type StringOptions is
     ( None ,
       Capitalize ,
       UpperCase ,
       LowerCase ) ;
   function Initialize( wordlist : string ) return CandidateWords_Type ;
   function Choose( cw : CandidateWords_Type ; option : StringOptions := None ) return string ;
   function Choose( cw : CandidateWords_Type ) return integer ;
      
end words;
