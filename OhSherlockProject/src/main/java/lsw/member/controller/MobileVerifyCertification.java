package lsw.member.controller;

import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;

public class MobileVerifyCertification extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod(); // "GET" 또는 "POST"
		
		if("POST".equalsIgnoreCase(method)) {
		
			String mobile = request.getParameter("mobile");
			
			boolean sendSmsSuccess = false; // 문자 정상 전송 여부
			
			// 인증키를 랜덤하게 생성하도록 한다. 
			Random rnd  = new Random();
			
		     int randnum = 0;
		        for (int i = 0; i < 6; i++) {
		        	randnum += rnd.nextInt(9 - 0 + 1) + 0;
		           
		        } // end of for---------------
			
			String certificationCode = "오!셜록 본인확인 인증번호는 ["+randnum+"] 입니다. 정확히 입력해주세요.";
	        
			// System.out.println("확인용 인증코드 : " + certificationCode);
			
			// 랜덤하게 생성한 인증코드(certificationCode) 를 비밀번호 찾기를 하고자 하는 사용자의 이메일로 전송시켜준다.
			SmsSend sms = new SmsSend();
			
			sms.sendSms(mobile, certificationCode);
			
			// System.out.println("문자 전송 결과 확인용 => " +  result);
			//sendSmsSuccess = true; // 메일 전송이 성공했음을 알려주는 플래그
				
			//	sendSmsSuccess = false; // console 창에 에러 여부를 찍어주고, 메일 전송이 실패되었다는 것을 알리기 위해 플래그를 사용한다. 
		
			JSONObject jsonObj = new JSONObject(); // {}
			jsonObj.put("randnum", randnum);     // {"isExists":true} 또는 {"isExists":false} 으로 만들어준다. 
			
			String json = jsonObj.toString(); // 문자열 형태인 "{"isExists":true}" 또는 "{"isExists":false}" 으로 만들어준다.
			
			request.setAttribute("json", json);
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
				
		}
	}

}
