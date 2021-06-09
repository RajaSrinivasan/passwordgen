with Ada.Streams.Stream_IO ;

with openssl.evp.cipher ;
with openssl.evp.digest ;

package sf is
   verbose : boolean := true ;
   type headerType is
      record
         pwd : openssl.evp.digest.DigestValue(1..openssl.evp.digest.EVP_MAX_MD_SIZE)
           := (others => 0) ;
         iv : aliased openssl.evp.cipher.InitializationVector(1..openssl.evp.cipher.EVP_MAX_IV_LENGTH)
           := (others => 0) ;
         sig : openssl.evp.digest.DigestValue(1..openssl.evp.digest.EVP_MAX_MD_SIZE)
           := (others => 0) ;
      end record ;
   
   type SecureFile_Type is limited private ;

private
   type SecureFile_Type is 
   record
      file : Ada.Streams.Stream_IO.File_Type ;
      iv : access openssl.evp.cipher.InitVector_Type ;
      ctx : openssl.evp.cipher.Context ; 
      digctx : openssl.evp.digest.Context ;
      hdr : headerType ;   
   end record;
end sf;
