package lye.member.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import common.controller.AbstractController;
import lye.member.model.InterMemberDAO;
import lye.member.model.MemberDAO;

public class SendEmailCode_2 extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();  // "GET" 또는 "POST"
		
		if("POST".equalsIgnoreCase(method)) {  // "POST" 방식일때만 검사해준다.
			// 이메일 인증하기 버튼을 클릭했을 경우
			
			String userid = request.getParameter("userid");  
			String email = request.getParameter("email");    
			
			InterMemberDAO mdao = new MemberDAO();   // 객체생성
			
			Map<String, String>  paraMap = new HashMap<>();  
			paraMap.put("userid", userid);
			paraMap.put("email", email);
			
			boolean isUserExist = mdao.isUserEmailExist(paraMap); // paraMap 의 아이디 및 이메일 존재하는지 여부 확인함.
			
			JSONObject jsonObj = new JSONObject(); // {}  ==> {} 라는 객체 생성
			jsonObj.put("isUserExist", isUserExist);  // {"isExists":true} 또는 {"isExists":false} 으로 만들어준다.
			
			String json = jsonObj.toString();
			request.setAttribute("json", json);
			
			boolean sendMailSuccess = false; // 메일이 정상적으로 전송되었는지 유무를 알아오기 위한 용도  // 초기값
			
			if(isUserExist) {  // true 이라면
				// 회원으로 존재하는 경우
				
				// 인증키를 랜덤으로 생성하도록 한다.
				Random rnd = new Random();  // 객체생성
				
				String certificationCode = "";
				// 인증키는 영문소문자 5글자 + 숫자 7글자 로 만들겠습니다.
				// 예 : certificationCode ==> dngrn4745003
				
				char randchar  = ' ';
				for(int i=0; i<5; i++) {
				/*
					min 부터 max 사이의 값으로 랜덤한 정수를 얻으려면 
                	int rndnum = rnd.nextInt(max - min + 1) + min;
				*/
				//  영문 소문자 'a' 부터 'z' 까지 랜덤하게 1개를 만든다.
					
					randchar = (char) (rnd.nextInt('z' - 'a' + 1) + 'a');  // int 보다 작은타입은(byte,short,char) 사칙연산을 만나면 자동적으로 int타입으로 변환된다. 따라서 (char) 타입으로 다시 형변환시켜줌.
					certificationCode += randchar;
				}// end of for---------------
				
				int randnum  = 0;
				for(int i=0; i<7; i++) {
					randnum = rnd.nextInt(9 - 0 + 1) + 0;
					certificationCode += randnum;
				}// end of for---------------
				
			//	System.out.println("~~~ 확인용 certificationCode => " + certificationCode);
			//  ~~~ 확인용 certificationCode => covno2737399	
				
				// 랜덤하게 생성한 인증코드(certificationCode)를 비밀번호 찾기를 하고자 하는 사용자의 email 로 전송시킨다.
				GoogleMail mail = new GoogleMail();  // GoogleMail 클래스 객체생성
				
				
				try {
					mail.sendmail(email, certificationCode, userid);  // GoogleMail 클래스 객체 mail 을 통해 사용자의 email로 certificationCode(인증번호)를 보낸다.
					sendMailSuccess = true;  // 메일 전송 성공했음을 기록함.
					
					// 세션(session) 영역에 저장되어진 정보는 모든 클래스파일 및 모든 .jsp 파일에서 사용가능하다. 즉, 모든 .jsp 파일에서 꺼내볼 수 있다.
					// 그런데 request 영역에 저장되어진 정보는 forward 되어지는 특정 .jsp 파일에서만 사용가능하다. 즉, 특정 .jsp 파일에서만 꺼내볼 수 있다.
					// 세션(session) 불러오기
					HttpSession session = request.getSession();
					session.setAttribute("certificationCode", certificationCode); 
					// 발급한 인증코드를 세션에 저장시킴. 즉 누구나 세션 영역에서 인증코드를 가져올 수 있음.
					
				} catch (Exception e) {  // 메일 전송이 실패한 경우
					e.printStackTrace();
					sendMailSuccess = false; // 메일 전송 실패했음을 기록함.
				}
				
			}// end of if(isUserExist)-------------------------
			
			request.setAttribute("isUserExist", isUserExist);  // true 라면 값을 넘겨주어 이메일인증할 수 있도록 하고, false 라면 끝내버린다.
			request.setAttribute("userid", userid);  // 입력한 userid 값을 view단(.jsp) 에 넘겨준다. view단에서 ${requestScope.userid} 로 넘겨받는다.
			request.setAttribute("email", email);    // 입력한 email 값을 view단(.jsp) 에 넘겨준다. 
			request.setAttribute("sendMailSuccess", sendMailSuccess);   // true 또는 false
			
		}// end of if("POST".equalsIgnoreCase(method))---------------------
		
		request.setAttribute("method", method);  // 어떤 method 방식인지 넘겨준다.
		
		
		// "GET" 또는 "POST" 방식 모두 해준다.
	//	super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		
	}

}
