
with System.Unsigned_Types ;
with words ;

package passwords is   

   function Generate( wordlist : string ;
                      segs : integer := 2 ;
                      sep : string := "^" ) return string ;
   function Generate( wordlist : words.CandidateWords_Type ;
                      segs : integer := 2 ;
                      sep : string := "^" ) return string ;
                         
end passwords;
