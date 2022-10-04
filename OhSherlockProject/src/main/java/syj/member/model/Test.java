package syj.member.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;

import util.security.AES256;
import util.security.SecretMyKey;
import util.security.Sha256;

public class Test {

	   public static void main(String[] args) throws UnsupportedEncodingException, NoSuchAlgorithmException, GeneralSecurityException {
	      
	      AES256 aes = new AES256(SecretMyKey.KEY);

	      String pw = Sha256.encrypt("qWer1234$");    // 암호를 SHA256 알고리즘으르 단방향 암호화 시킨다.  
	      
	      String mail = aes.encrypt("jin_92214@naver.com");  // 이메일을 AES256 알고리즘으로 양방향 암호화 시킨다. 
	      // 3o/fiFv5Fh9920BFzqqhfYk8Ktd7DhWgCUWyjFOyDQ0=
	      String mb = aes.encrypt("01011112222");  // 폰번호를 AES256 알고리즘으로 양방향 암호화 시킨다. 
	      
	      System.out.println(pw);
	      System.out.println(mail);
	      System.out.println(mb);
	   
	        

	        
	   }

	}
