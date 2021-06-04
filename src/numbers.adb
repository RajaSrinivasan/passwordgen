with Interfaces ;
with Ada.Strings.Fixed ;
with GNAT.Random_Numbers ;

package body numbers is
   G : GNAT.Random_Numbers.Generator ;
   use type Interfaces.Unsigned_32 ;
   function Generate return String is
      result : Interfaces.Unsigned_32 := GNAT.Random_Numbers.Random (G) ;
      results : String := Interfaces.Unsigned_16'Image(Interfaces.Unsigned_16(result mod 16#ffff#));
   begin
      return Ada.Strings.Fixed.Trim(results,
                                    Ada.Strings.Left) ;
   end Generate ;
begin
   GNAT.Random_Numbers.Reset(G);
end numbers;
