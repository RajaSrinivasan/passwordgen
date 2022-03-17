
package kdf is
   
   function DeriveKey( pwd : aliased string ;
                       salt : aliased string := "A big bug bit the little beetle but the little beetle bit the big bug back";
                       iterations : integer := 2 )
     return String ;

end kdf ;
