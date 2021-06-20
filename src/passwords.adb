with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_IO ; use Ada.Integer_Text_IO ;
with ada.strings.unbounded ; use ada.strings.unbounded ;

with Interfaces.C ; use Interfaces.c ;

with words ;
with numbers ;

package body passwords is
  use openssl.evp.digest ;
  function DeriveKey( pwd : aliased string ;
                       salt : aliased string := "A big bug bit the little beetle but the little beetle bit the big bug back";
                      hash : string := "sha256" ;
                      iterations : integer := 2 )
                     return KeyType is
      result : aliased KeyType(1..EVP_MAX_MD_SIZE) ;
      diglen : aliased unsigned := 0 ;
      cr : aliased character := ascii.LF ;
      ctx : Context := NewContext ;
      dig : MessageDigest ;
      status : int ;
   begin
      --Put("Pwd  : ");Put_Line(pwd);
      --Put("Salt : ");Put_Line(salt);
      if ctx = openssl.evp.digest.NullContext
      then
         raise Program_Error with "DeriveKey NewContext" ;
      end if ;
      dig := DigestByName( Interfaces.C.To_C(hash) ) ;
      if dig = NullMessageDigest
      then
         raise Program_Error with "DeriveKey MessageDigest" ;
      end if ;
      status := Initialize(ctx,dig) ;
      for iter in 1..iterations
      loop       
         status := Update(ctx,salt'Address,
                          Interfaces.C.size_t(salt'length)) ;
         if status /= 1
         then
            raise Program_Error with "DigestUpdate" ;
         end if ;

         status := Update(ctx,pwd'Address,
                          Interfaces.C.size_t(pwd'length)) ;
         if status /= 1
         then
            raise Program_Error with "DigestUpdate" ;
         end if ;
         
         status := Update(ctx,cr'Address,
                          Interfaces.C.size_t(1)) ;
         if status /= 1
         then
            raise Program_Error with "DigestUpdate" ;
         end if ;
         
      end loop ;
      --Put("Digested "); Put(Integer(salt'length + pwd'length)+1) ;Put(" bytes"); New_Line;
      status := Finalize(ctx,result'Address,diglen'access);
      if status /= 1
      then
         raise Program_Error with "DigestFinalize" ;
      end if ;
      return result (1..Integer(Size(dig))) ;
   end DeriveKey ;
   
   function Generate( wordlist : string ;
                      segs : integer := 2 ;
                      sep : string := "^" 
                     ) return string is
      result : unbounded_string := Null_Unbounded_String ;
      cw : words.CandidateWords_Type ;	
   begin
      cw := words.Initialize(wordlist , words.MAXLENGTH );
      
      for seg in 1..segs
      loop

         if seg mod 2 = 0
         then
            Append(result,words.Choose(cw, words.Capitalize)) ; 
         else
            Append(result,words.Choose(cw)) ;
         end if ;
         Append(result,sep);
         Append(result,numbers.Generate);
         if seg /= segs
         then
            Append(result,sep) ;
         end if ;
      end loop ;
      return to_string(result) ;
   end Generate ;
   
end passwords;
