package sf.creator is
   ENCRYPT_FAILURE : exception ;
   procedure Create( file : in out SecureFile_Type ;
                    name : string ;
                    password : aliased string ;
                    algorithm : string := "aes-128-cbc" 
                    ) ;
   procedure Copy( to : in out SecureFile_Type ;
                   from : Ada.Streams.Stream_Io.File_Type );
   procedure Copy( to : in out SecureFile_Type ;
                   from : String ) ;
   procedure Write ( File : SecureFile_Type;
                     Item : Ada.Streams.Stream_Element_Array );
   procedure Close( file : in out SecureFile_Type  ) ;
end sf.creator;
