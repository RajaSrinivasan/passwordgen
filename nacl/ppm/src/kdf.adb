

with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_IO ; use Ada.Integer_Text_IO ;
with ada.strings.unbounded ; use ada.strings.unbounded ;
with Ada.Streams ;

with GNAT.SHA512 ;

with words ;
with numbers ;

package body kdf is

  function DeriveKey( pwd : aliased string ;
                       salt : aliased string := "A big bug bit the little beetle but the little beetle bit the big bug back";
                      iterations : integer := 2 )
                     return String is

      Csha512 : Gnat.SHA512.Context := Gnat.SHA512.Initial_Context ;
      procedure Add(str : String) is
        buffer : ada.Streams.Stream_Element_Array(1..str'Length) ;
        for buffer'Address use Str'Address ;
      begin
        GNAT.SHA512.Update(csha512,buffer);
      end Add ;
   begin
      for iter in 1..iterations
      loop       
         Add(salt) ;
         Add(pwd) ;         
      end loop ;
      return Gnat.SHA512.Digest(Csha512) ;
   end DeriveKey ;

end kdf;

