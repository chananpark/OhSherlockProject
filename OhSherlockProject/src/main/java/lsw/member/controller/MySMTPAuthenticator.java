package lsw.member.controller;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class MySMTPAuthenticator extends Authenticator {

	// 이메일을 보낼 때 내가 누구인지 신분을 밝히기 위해서 여기 클래스를 사용한다.
	@Override
	public PasswordAuthentication getPasswordAuthentication() {
		
		// Gmail 의 경우 @gmail.com 을 제외한 아이디만 입력한다.
		return new PasswordAuthentication("ssherlock.oh","znoiflzzvwtehkxf");
		// kcmpponxyjpdqutv 은 구글에 로그인 하기 위한 앱비밀번호 이다.
		
	}
	
}
