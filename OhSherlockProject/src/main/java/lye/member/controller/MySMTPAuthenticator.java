package lye.member.controller;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class MySMTPAuthenticator extends Authenticator {

	@Override
	public PasswordAuthentication getPasswordAuthentication() {
		
		// Gmail 의 경우 @gmail.com 을 제외한 아이디만 입력한다.
		return new PasswordAuthentication("eunee005", "bkvyjjxghvqmloni");
		// "bkvyjjxghvqmloni" 은 Google에 로그인하기 위한 앱비밀번호 이다.
		
	}
	
	
}
