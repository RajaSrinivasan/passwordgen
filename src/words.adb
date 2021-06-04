with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Fixed ;
with GNAT.Random_Numbers ;
with GNAT.Case_Util ;

package body words is
      
   function Initialize( wordlist : String ;
                        maxwordlength : integer := MAXLENGTH) return CandidateWords_Type is
      cw : CandidateWords_Type ;
      wfile : ada.text_Io.File_Type ;
      line : string(1..64) ;
      linelen : natural ;
      wordcount : integer := 0;
      ignoredwordcount : integer := 0;
      newword : Word_Type ;
   begin
      cw.words.Reserve_Capacity(10_000);
      Open(wfile,In_File,wordlist);
      while Not End_Of_File(wfile)
      loop
         get_line(wfile,line,linelen);
         declare
            baseword : string := Ada.Strings.Fixed.Trim(line(1..linelen),
                                                        Ada.Strings.Right);
         begin
            if baseword'Length <= MaxWordLength
            then
               wordcount := wordcount + 1 ;
               Ada.Strings.Fixed.Move(Source => baseword , Target => newword);
               cw.words.Append(newword) ;
               pragma Debug(Put_Line("Added " & newword));
            else
               ignoredwordcount := ignoredwordcount + 1 ;
               pragma Debug(Put_Line("Too long " & baseword )) ;
            end if ;
         end ;
      end loop ;
      Close(wfile) ;
      Put(wordcount); Put(" lines "); Put_Line(" read. "); Put(ignoredwordcount);Put( " ignored. ");
      Put("Storage vector length "); Put(Integer(cw.words.Length)) ; 
      New_Line ;
      return cw ;
   end Initialize ;

   G : gnat.Random_Numbers.Generator ;
   
   function Choose( cw : CandidateWords_Type ;
                    option : StringOptions := None ) return string is
      idx : integer := Choose(cw) ;
   begin
      declare
         result : String := ada.strings.Fixed.Trim( cw.words.Element(idx) ,
                                                    ada.strings.Right );
      begin
         case option is
            when Capitalize => GNAT.Case_Util.To_Mixed(result);
            when UpperCase => GNAT.Case_Util.To_Upper(result);
            when LowerCase => GNAT.Case_Util.To_Lower(result);
            when others => null ;
         end case ;
         return result ;
      end ;
   end Choose ;
   
   function Choose( cw : CandidateWords_Type ) return integer is
      numwords : float := float(cw.words.Length) ;
      idx : Integer ;
      fidx : Float := GNAT.Random_Numbers.Random(G) ;
   begin
      idx := Integer(fidx * numwords) ;
      --Put(idx); new_line ;
      if idx < 1
      then
         idx := 1 ;
      end if ;
      return idx ;
   end Choose ;
    
begin
   GNAT.Random_Numbers.Reset(G);
end words;
