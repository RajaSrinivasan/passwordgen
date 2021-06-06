with openssl.evp.digest ;
with System.Unsigned_Types ;

package passwords is   
   subtype KeyType is System.Unsigned_Types.Packed_Bytes1 ;
   
   function DeriveKey( pwd : aliased string ;
                       salt : aliased string := "A big bug bit the little beetle but the little beetle bit the big bug back";
                       hash : string := "sha256" ;
                       iterations : integer := 2 )
     return KeyType ;
                       
end passwords;
