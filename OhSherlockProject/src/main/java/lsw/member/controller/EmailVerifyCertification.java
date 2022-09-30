package lsw.member.controller;

import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;

public class EmailVerifyCertification extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod(); // "GET" 또는 "POST"
		
		if("POST".equalsIgnoreCase(method)) {
		
			String email = request.getParameter("email");
			
			boolean sendMailSuccess = false; // 메일 정상 전송 여부
			
			// 인증키를 랜덤하게 생성하도록 한다. 
			Random rnd = new Random();
			
			// 인증키는 영문소문자 5글자 + 숫자 7글자 로 만들겠다. 
			// 예 : certificationCode ==> dngrn4745003
			String certificationCode = "";
			
			char randchar = ' ';
			for(int i=0; i<5; i++) { 
				// 공식 : min 부터 max 사이의 값으로 랜덤한 정수를 얻으려면 
                // int rndnum = rnd.nextInt(max - min + 1) + min;
				
				// 영소문자 'a' 부터 'z' 까지 랜덤하게 1개를 만든다. 
				randchar = (char)(rnd.nextInt('z' - 'a' + 1) + 'a'); // int 보다 작은 byte, short, char는 사칙연산을 만나면 자연적으로 int를 만난다. 
				certificationCode += randchar;
			} // end of for
			
			int randnum = 0;
			for(int i=0; i<7; i++) { 
				// 공식 : min 부터 max 사이의 값으로 랜덤한 정수를 얻으려면 
                // int rndnum = rnd.nextInt(max - min + 1) + min;
				
				// 숫자 0 부터 9 까지 랜덤하게 1개를 만든다. 
				randnum = rnd.nextInt(9 - 0 + 1) + 0; // int 보다 작은 byte, short, char는 사칙연산을 만나면 자연적으로 int를 만난다. 
				certificationCode += randnum;
			} // end of for
			
			System.out.println("확인용 인증코드 : " + certificationCode);
			// 확인용 인증코드 : ulbys7013440
			
			// 랜덤하게 생성한 인증코드(certificationCode) 를 비밀번호 찾기를 하고자 하는 사용자의 이메일로 전송시켜준다.
			GoogleMail mail = new GoogleMail();
			
			try { 
				mail.sendmail(email, certificationCode);
				sendMailSuccess = true; // 메일 전송이 성공했음을 알려주는 플래그
				
			} catch(Exception e) { // 메일 전송이 실패한 경우. GoogleMail 에서 throw Exception을 처리해 줬기 때문이다.
				e.printStackTrace();
				sendMailSuccess = false; // console 창에 에러 여부를 찍어주고, 메일 전송이 실패되었다는 것을 알리기 위해 플래그를 사용한다. 
			}
			
			JSONObject jsonObj = new JSONObject(); // {}
			jsonObj.put("certificationCode", certificationCode);     // {"isExists":true} 또는 {"isExists":false} 으로 만들어준다. 
			
			String json = jsonObj.toString(); // 문자열 형태인 "{"isExists":true}" 또는 "{"isExists":false}" 으로 만들어준다.
			
			request.setAttribute("json", json);
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
				
		}
	}
}
