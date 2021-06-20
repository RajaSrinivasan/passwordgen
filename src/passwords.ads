with openssl.evp.digest ;
with System.Unsigned_Types ;

package passwords is   
   subtype KeyType is openssl.evp.digest.DigestValue ;
   
   function DeriveKey( pwd : aliased string ;
                       salt : aliased string := "A big bug bit the little beetle but the little beetle bit the big bug back";
                       hash : string := "sha256" ;
                       iterations : integer := 2 )
     return KeyType ;
   function Generate( wordlist : string ;
                      segs : integer := 2 ;
                      sep : string := "^" ) return string ;
end passwords;
