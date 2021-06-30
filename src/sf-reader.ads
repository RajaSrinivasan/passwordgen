package sf.reader is

   PASSWORD_MISMATCH : exception ;
   DECRYPT_FAILURE : exception ;
   SIGNATURE_MISMATCH : exception ;
   
   procedure Open( file : in out SecureFile_Type ;
                   name : string ;
                   password : aliased string ;
                   algorithm : string := "aes-128-cbc" 
                  ) ;

   procedure Read
     (File : SecureFile_Type;
      Item : out Ada.Streams.Stream_Element_Array;
      Last : out Ada.Streams.Stream_Element_Offset);
   procedure Copy( from : in out SecureFile_Type ;
                   to : String ) ;
   procedure Copy( from : in out SecureFile_Type ;
                   to : in out Ada.Streams.Stream_Io.File_Type );
   
   procedure Close( file : in out SecureFile_Type  ) ;

end sf.reader;
