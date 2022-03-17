package body Hex is

   use System;

   Nibble_Hex : constant String := "0123456789ABCDEF";

   function Value (Hex : Character) return Interfaces.Unsigned_8 is
   begin
      if Hex in '0' .. '9' then
         return Interfaces.Unsigned_8
             (Character'Pos (Hex) - Character'Pos ('0'));
      end if;
      if Hex in 'a' .. 'f' then
         return Interfaces.Unsigned_8
             (10 + Character'Pos (Hex) - Character'Pos ('a'));
      end if;
      if Hex in 'A' .. 'F' then
         return Interfaces.Unsigned_8
             (10 + Character'Pos (Hex) - Character'Pos ('A'));
      end if;
      raise format_error with "InvalidHex " & Hex ;
   end Value;

   function Value (Hex : Hexstring) return Interfaces.Unsigned_8 is
      use Interfaces;
      Vhigh, Vlow : Interfaces.Unsigned_8;
   begin
      Vhigh := Value (Hex (1));
      Vlow  := Value (Hex (2));
      return Vhigh * 16 + Vlow;
   end Value;
   function Value (Str : String) return Interfaces.Unsigned_16 is
      use Interfaces;
      Result   : Interfaces.Unsigned_16 := 0;
      Numbytes : Integer;
      Nextbyte : Interfaces.Unsigned_8;
   begin
      if Str'Length /= 4 then
         raise format_error with "HexWord";
      end if;
      Numbytes := Str'Length / 2;
      for B in 1 .. Numbytes loop
         Nextbyte := Value (Str ((B - 1) * 2 + 1 .. B * 2));
         Result := Shift_Left (Result, 8) + Interfaces.Unsigned_16 (Nextbyte);
      end loop;
      return Result;
   end Value;

   function Value
     (Hex : Character) return System.Storage_Elements.Storage_Element
   is
      u8 : Interfaces.Unsigned_8;
   begin
      u8 := Value (Hex);
      return System.Storage_Elements.Storage_Element (u8);
   end Value;

   function Value
     (Hex : Hexstring) return System.Storage_Elements.Storage_Element
   is
      u8 : Interfaces.Unsigned_8;
   begin
      u8 := Value (Hex);
      return System.Storage_Elements.Storage_Element (u8);
   end Value;

   function Image (bin : Interfaces.Unsigned_8) return Hexstring is
      use Interfaces;
      img     : Hexstring;
      Lnibble : Interfaces.Unsigned_8 := bin and 16#0f#;
      Hnibble : Interfaces.Unsigned_8 :=
        Interfaces.Shift_Right (bin and 16#f0#, 4);
   begin
      img (1) := Nibble_Hex (Integer (Hnibble) + 1);
      img (2) := Nibble_Hex (Integer (Lnibble) + 1);
      return img;
   end Image;

   function Image (bin : Interfaces.Unsigned_16) return String is
      use Interfaces;
      img : String (1 .. 4);
   begin
      img (1 .. 2) :=
        Image (Interfaces.Unsigned_8 (Shift_Right (bin and 16#ff00#, 8)));
      img (3 .. 4) := Image (Interfaces.Unsigned_8 (bin and 16#00ff#));
      return img;
   end Image;

   function Image (bin : Interfaces.Unsigned_32) return String is
      use Interfaces;
      img : String (1 .. 8);
   begin
      img (1 .. 2) :=
        Image
          (Interfaces.Unsigned_8 (Shift_Right (bin and 16#ff00_0000#, 24)));
      img (3 .. 4) :=
        Image
          (Interfaces.Unsigned_8 (Shift_Right (bin and 16#00ff_0000#, 16)));
      img (5 .. 6) :=
        Image (Interfaces.Unsigned_8 (Shift_Right (bin and 16#0000_ff00#, 8)));
      img (7 .. 8) := Image (Interfaces.Unsigned_8 (bin and 16#0000_00ff#));
      return img;
   end Image;

   function Image (binptr : System.Address; Length : Integer) return String is
      use Interfaces;
      img   : String (1 .. 2 * Length);
      bytes : array (1 .. Length) of Interfaces.Unsigned_8;
      for bytes'Address use binptr;
      hexstr : Hexstring;
   begin
      for binptr in 1 .. Length loop
         hexstr := Image (bytes (binptr));
         img (2 * (binptr - 1) + 1 .. 2 * (binptr - 1) + 2) := hexstr;
      end loop;
      return img;
   end Image;

   function Image
     (bin : System.Storage_Elements.Storage_Element) return Hexstring
   is
   begin
      return Image (Interfaces.Unsigned_8 (bin));
   end Image;

end Hex;
