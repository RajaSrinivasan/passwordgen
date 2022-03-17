with Sparknacl.Hashing ;
package kdf is
   
   function DeriveKey( pwd : aliased string ;
                       salt : aliased string := "pangram: the five boxing wizards jump quickly" ;
                       iterations : integer := 2 )
     return String ;

    function DeriveKey( pwd : aliased string ;
                       salt : aliased string := "pangram: the five boxing wizards jump quickly" ;
                       iterations : integer := 2 )
     return SparkNacl.Hashing.Digest ;

end kdf ;
