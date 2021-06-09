with sf.creator ;

procedure sftest is
   f : sf.SecureFile_Type ;
   password : aliased string := "raja" ;
begin
   sf.creator.Create( f , "securefile.bin" , password ) ;
   sf.creator.Copy( f , "sftest.exe" ) ;
   sf.creator.Close(f) ;
end sftest;
