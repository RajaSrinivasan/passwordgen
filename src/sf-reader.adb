with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO ;
with Interfaces.C ; use Interfaces.C ;
with Ada.Streams.Stream_IO ;

with hex ;
with passwords ;

package body sf.reader is
   use openssl ;
   use openssl.evp.cipher ;
   use openssl.evp.digest ;
   
   libctx      : openssl.Context;
   procedure Open( file : in out SecureFile_Type ;
                   name : string ;
                   password : aliased string ;
                   algorithm : string := "aes-128-cbc" 
                  ) is
      status : int ;
      cip    : openssl.evp.cipher.CIPHER_ALGORITHM;
      dig    : openssl.evp.digest.MessageDigest ;
      iv : openssl.evp.cipher.InitVector_Type ;
   begin

      
      libctx := openssl.LibraryContext;
      if libctx = openssl.NullContext then
         raise Program_Error with "LibraryContext";
      end if;

      cip := openssl.evp.cipher.CipherByName (Interfaces.C.To_C (algorithm));
      if cip = openssl.evp.cipher.NullCipher then
         raise Program_Error with "CipherLookup " & algorithm;
      end if;

      file.ctx := NewContext;
      
      dig := openssl.evp.digest.DigestByName( Interfaces.C.To_C("sha256") ) ;
      if dig = NullMessageDigest
      then
         raise Program_Error with "MessageDigest" ;
      end if ;            
      Ada.Streams.Stream_IO.Open( file.file ,
                                    Ada.Streams.Stream_IO.In_File ,
                                    name ) ;
      headerType'Read( Ada.Streams.Stream_IO.Stream(file.file) , file.hdr ) ;
      declare
         hashed : openssl.evp.digest.DigestValue := passwords.DeriveKey(password);
      begin
         if file.hdr.pwd(1..Integer(openssl.evp.digest.Size(dig) )) /= hashed 
         then
            Put_Line("Supplied password signature");
            hex.dump(hashed'Address,hashed'Length);
            Put_Line("Expected signature");
            hex.dump( file.hdr.pwd'Address , file.hdr.pwd'Length );
            raise PASSWORD_MISMATCH ;
         end if ;
      end ;
      iv := new openssl.evp.cipher.InitializationVector( 1..Integer(openssl.evp.cipher.IV_Length(cip)) ) ;
      iv.all := file.hdr.iv(1..Integer(openssl.evp.cipher.Iv_length(cip)));
      status  := openssl.evp.cipher.DecryptInit( ctx => file.ctx , 
                                                 cipher => cip ,
                                                 key => password ,
                                                 iv => iv ); -- openssl.evp.cipher.InitVector_Type(file.hdr.iv'Access) ) ; 
      if status /= 1
      then
         raise Program_Error ;
      end if ;
      

      
      file.digctx := NewContext ;
      status := openssl.evp.digest.Initialize(file.digctx,dig) ;
      if status /= 1
      then
         raise Program_Error with "InitializeMDContext" ;
      end if;
      
   end Open ;
   
   procedure Copy( from : in out SecureFile_Type ;
                   to : String ) is
      f : Ada.Streams.Stream_Io.File_Type ;
   begin
      Ada.Streams.Stream_Io.Create( f , Ada.Streams.Stream_Io.Out_File , to ) ;
      Copy( from , f ) ;
      Ada.Streams.Stream_Io.Close(f) ;
   end Copy ;
   bytes_read : integer := 0;
   procedure Read
     (File : SecureFile_Type;
      Item : out Ada.Streams.Stream_Element_Array;
      Last : out Ada.Streams.Stream_Element_Offset) is
      use Ada.Streams.Stream_Io ;
      use Ada.Streams ;
      status : int ;
      outbuf : aliased Ada.Streams.Stream_Element_Array(1..Item'Length) ;
      outbuflen : Ada.Streams.Stream_Element_Offset ;
      result : aliased Ada.Streams.Stream_Element_Array(1..Item'Length) := (others => 0) ;
      resultlen : aliased int ;
   begin
      if End_Of_File(file.file)
      then
         status := DecryptFinal_ex ( file.ctx , result'address, resultlen'access);
         Put ("(Final) Wrote ");
         Put (Integer (resultlen)); New_Line ;
         Item := result ;
         last := Stream_Element_Offset(resultlen) ;
               
         status := openssl.evp.digest.Update(file.digctx, result'Address,
                                          Interfaces.C.size_t(int(resultlen))) ;
         return ;
      end if ;
      Read(file.file, outbuf , outbuflen);
      bytes_read := bytes_read + Integer(outbuflen) ;
      status := openssl.evp.cipher.DecryptUpdate(file.ctx ,
                                                 result'address , 
                                                 resultlen'access , 
                                                 outbuf'address,
                                                 int (outbuflen));
      --Put("Decrypt "); Put(integer(outbuflen)); Put( " bytes into "); 
      --Put(integer(resultlen)); Put(" bytes. Status "); Put(Integer(status)); New_Line ;
      item := result ;
      last := ada.streams.Stream_Element_Offset(resultlen) ;
      
      status := openssl.evp.digest.Update(file.digctx, result'Address,
                                          Interfaces.C.size_t(int(resultlen))) ;
      
   end Read ;
      
   procedure Copy( from : in out SecureFile_Type ;
                   to : Ada.Streams.Stream_Io.File_Type ) is
      use Ada.Streams ;
      buffer : Stream_Element_Array (1..1024) ;
      bufbytes : Stream_Element_Count ;
      bufbytesint : aliased int ;
      status : int ;
      
   begin
      while not Ada.Streams.Stream_IO.End_Of_File (from.file) 
      loop
         Read (from , buffer, bufbytes);
         Put("Decrypted "); Put(Integer(bufbytes)); Put(" bytes "); New_Line;
         Ada.Streams.Stream_IO.Write(to , buffer (1 .. Stream_Element_Count (bufbytes)));
      end loop;
      status := DecryptFinal_ex ( from.ctx , buffer'address, bufbytesint'access);
      Put ("(Final) Wrote ");
      Put (Integer (bufbytes)); New_Line ;

      Ada.Streams.Stream_IO.Write(to , buffer (1 .. Stream_Element_Count (bufbytesint)));
  
      
      status := openssl.evp.digest.Update(from.digctx, buffer'Address,
                                          Interfaces.C.size_t(int(bufbytesint))) ;
       
   end Copy ;
   
   procedure Close( file : in out SecureFile_Type  ) is
      status : int ;
      diglen : aliased unsigned ;
      digest : openssl.evp.digest.DigestValue (1..openssl.evp.digest.EVP_MAX_MD_SIZE) 
      := (others => 0) ;
   begin
      status := openssl.evp.digest.Finalize(file.digctx,
                                            digest'Address,
                                            diglen'Access);
      if status /= 1
      then
         raise Program_Error ;
      end if ;
      Put_Line("File Data signature");
      hex.dump( file.hdr.sig'address , file.hdr.sig'Length ) ;
      Put_Line("Computed signature");
      hex.dump( digest'address , digest'Length ) ;
      
      if file.hdr.sig /= digest
      then 
         --raise SIGNATURE_MISMATCH ;
         New_Line;
      end if ;
      
      openssl.evp.digest.Free(file.digctx) ;
      Ada.Streams.Stream_Io.Close(file.file);
   end Close ;
  
end sf.reader;
