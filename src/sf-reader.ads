package sf.reader is

   PASSWORD_MISMATCH : exception ;
   DECRYPT_FAILURE : exception ;
   SIGNATURE_MISMATCH : exception ;
   
   procedure Open( file : in out SecureFile_Type ;
                   name : string ;
                   password : string ;
                   algorithm : string := "aes-128-cbc" 
                  ) ;
   function Size( file : SecureFile_Type ) return Stream_Element_Count ;
   procedure Read
     (File : SecureFile_Type;
      Item : out Ada.Streams.Stream_Element_Array;
      Last : out Ada.Streams.Stream_Element_Offset);
   
   procedure Close( file : in out SecureFile_Type  ) ;

end sf.reader;
