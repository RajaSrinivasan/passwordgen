with sf.reader ;
procedure sfrtest is
   f : sf.SecureFile_Type ;
   password : aliased string := "raja" ;
begin
   sf.reader.Open( f , "securefile.bin" , password ) ;
   sf.reader.Copy( f , "sftest.exe.out" ) ;
   sf.reader.Close(f) ;
end sfrtest;
