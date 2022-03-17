
with System;
with System.Storage_Elements;

with Interfaces;

package Hex is
   format_error : exception;
   subtype Hexstring is String (1 .. 2);

   function Value (Hex : Character) return Interfaces.Unsigned_8;
   function Value (Hex : Hexstring) return Interfaces.Unsigned_8;
   function Value (Str : String) return Interfaces.Unsigned_16;
   function Value
     (Hex : Character) return System.Storage_Elements.Storage_Element;
   function Value
     (Hex : Hexstring) return System.Storage_Elements.Storage_Element;

   function Image (bin : Interfaces.Unsigned_8) return Hexstring;
   function Image (bin : Interfaces.Unsigned_16) return String;
   function Image (bin : Interfaces.Unsigned_32) return String;
   function Image (binptr : System.Address; Length : Integer) return String;
   function Image
     (bin : System.Storage_Elements.Storage_Element) return Hexstring;

end Hex;
