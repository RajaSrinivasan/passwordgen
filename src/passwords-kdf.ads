with openssl.evp.digest ;
package passwords.kdf is

   subtype KeyType is openssl.evp.digest.DigestValue ;
   
   function DeriveKey( pwd : aliased string ;
                       salt : aliased string := "A big bug bit the little beetle but the little beetle bit the big bug back";
                       hash : string := "sha256" ;
                       iterations : integer := 2 )
     return KeyType ;

end passwords.kdf;
