with Interfaces.C ; use Interfaces.C ;
with Ada.Text_Io; use Ada.Text_Io;

with hex ;
with openssl.evp.cipher ;

with passwords ;
package body sf.creator is
   use openssl ;
   use openssl.evp.cipher ;
   use openssl.evp.digest ;
   
   libctx      : openssl.Context;

   
  procedure Create( file : in out SecureFile_Type ;
                    name : string ;
                    password : aliased string ;
                    algorithm : string := "aes-128-cbc" 
                   ) is
      status : int ;
      cip         : openssl.evp.cipher.CIPHER_ALGORITHM;
      dig : openssl.evp.digest.MessageDigest ;
   begin
      declare
         hashed : openssl.evp.digest.DigestValue := passwords.DeriveKey(password);
      begin
         file.hdr.pwd(1..hashed'length) := hashed ;
      end ;
      
      libctx := openssl.LibraryContext;
      if libctx = openssl.NullContext then
         raise Program_Error with "LibraryContext";
      end if;

      cip := openssl.evp.cipher.CipherByName (Interfaces.C.To_C (algorithm));
      if cip = openssl.evp.cipher.NullCipher then
         raise Program_Error with "CipherLookup " & algorithm;
      end if;

      file.ctx := NewContext;
      declare
         iv : openssl.evp.cipher.InitVector_Type
           := openssl.evp.cipher.Generate(Integer(openssl.evp.cipher.Iv_length(cip))) ;
      begin
         file.hdr.iv(1..iv'length) := iv.all ;

      
         status  := openssl.evp.cipher.EncryptInit( ctx => file.ctx , 
                                                    cipher => cip ,
                                                    key => password ,
                                                    iv => iv ) ; 
         if status /= 1
         then
            raise Program_Error ;
         end if ;
      end ;
      
      Ada.Streams.Stream_IO.Create( file.file ,
                                    Ada.Streams.Stream_IO.Out_File ,
                                    name ) ;
      headerType'Write( Ada.Streams.Stream_IO.Stream(file.file) , file.hdr ) ;
      
      dig := openssl.evp.digest.DigestByName( Interfaces.C.To_C("sha256") ) ;
      if dig = NullMessageDigest
      then
         raise Program_Error with "MessageDigest" ;
      end if ;
      
      file.digctx := NewContext ;
      status := openssl.evp.digest.Initialize(file.digctx,dig) ;
      if status /= 1
      then
         raise Program_Error with "InitializeMDContext" ;
      end if;
      
   end Create ;
   procedure Copy( to : in out SecureFile_Type ;
                   from : Ada.Streams.Stream_Io.File_Type ) is
      use Ada.Streams;
      buffer : Stream_Element_Array (1..1024) ;
      bufbytes : Stream_Element_Count ;
   begin
      while not Ada.Streams.Stream_IO.End_Of_File (from) 
      loop
            Stream_IO.Read (from, buffer, bufbytes);
            Write(to , buffer (1 .. Stream_Element_Count (bufbytes)));
      end loop;
   end Copy ;
   
   procedure Copy( to : in out SecureFile_Type ;
                   from : String ) is
      f : Ada.Streams.Stream_Io.File_Type ;
   begin
      Ada.Streams.Stream_Io.Open( f , Ada.Streams.Stream_Io.In_File , from ) ;
      Copy( to , f) ;
      Ada.Streams.Stream_Io.Close(f) ;
   end Copy ;
   
   
   procedure Write ( File : SecureFile_Type;
                     Item : Ada.Streams.Stream_Element_Array ) is
      status : int ;
   begin
      Ada.Streams.Stream_IO.Write(file.file,Item);
      status := openssl.evp.digest.Update(file.digctx, Item'Address,
                                         Interfaces.C.size_t(Item'length)) ;
      if status /= 1
      then
          raise Program_Error with "DigestUpdate" ;
      end if ;
   end Write ;
   
   procedure Close( file : in out SecureFile_Type  ) is
      status : int ;
      diglen : aliased unsigned ;
   begin
      status := openssl.evp.digest.Finalize(file.digctx,
                                            file.hdr.sig'Address,
                                            diglen'Access);
      if status /= 1
      then
         raise Program_Error ;
      end if ;
         
      openssl.evp.digest.Free(file.digctx) ;
      
      Ada.Streams.Stream_IO.Set_Index(file.file,1);
      headerType'Write( Ada.Streams.Stream_IO.Stream(file.file) , file.hdr ) ;
      Ada.Streams.Stream_IO.Close(file.file) ;
      if verbose
      then
         Put_Line( hex.Image( file.hdr.sig'address , file.hdr.sig'length ));
      end if ;
   end Close ;
   
end sf.creator;
