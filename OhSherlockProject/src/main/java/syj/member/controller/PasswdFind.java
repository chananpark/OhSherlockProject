package syj.member.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import syj.member.model.*;

public class PasswdFind extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();
		
		if("POST".equalsIgnoreCase(method)) {
			
			// 비밀번호 찾기 모달창에서 찾기 버튼을 클릭했을 경우
			
			String userid = request.getParameter("userid");
			String name = request.getParameter("name");
			String email = request.getParameter("email");
			
			InterMemberDAO mdao = new MemberDAO();
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("userid", userid);
			paraMap.put("email", email);
			paraMap.put("name", name);
			
			boolean isUserExist = mdao.isUserExist(paraMap);
			
			boolean sendMailSuccess = false; // 메일 정상 전송 여부
			
			if(isUserExist) {
				// 회원으로 존재하는 경우
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
					mail.sendmail(userid, email, certificationCode);
					sendMailSuccess = true; // 메일 전송이 성공했음을 알려주는 플래그
					
					// 세션영역에 저장되어진 정보는 모든 클래스파일 및 모든 jsp 파일애서 사용가능하다. 
					// request 영역의 저장되어진 정보는 forward 되어지는 특정 jsp 파일에서만 사용가능하다. 
					// 세션(session)불러오기
					// 이 때의 session은 톰캣서버가 깔린 서버의 세션(저장소)이다.
					// 크롬f12의 어플리케이션의 로컬스토리지와 세션스토리지와는 세션이라는 이름만 같을 뿐 다르다.
					HttpSession session = request.getSession(); // 저장영역 불러오기 
					session.setAttribute("certificationCode", certificationCode); // session 에 저장해주었기 때문에 다른 class에서도 꺼내볼 수 있다.
					// 발급한 인증코드를 세션영역에 저장시킨다.
					// request에 넣으면 forward 되어진 파일만 열어볼 수 있기 때문에 session에 저장해서 누구나 확인할 수 있도록 만든다.
					
				} catch(Exception e) { // 메일 전송이 실패한 경우. GoogleMail 에서 throw Exception을 처리해 줬기 때문이다.
					e.printStackTrace();
					sendMailSuccess = false; // console 창에 에러 여부를 찍어주고, 메일 전송이 실패되었다는 것을 알리기 위해 플래그를 사용한다. 
				}
					
			} // end of if
			
			
			request.setAttribute("userid", userid); 
			request.setAttribute("email", email); 
			request.setAttribute("name", name); 
			request.setAttribute("sendMailSuccess", sendMailSuccess); // 메일 전송 성공 플래그 전달
			request.setAttribute("isUserExist", isUserExist); 
			// boolean 값을 set 해준다.
			// 회원으로 존재하지 않는 경우 사용자 정보가 없습니다 라고 출력
			// false 라면 없다 하고 끝내면 된다. 
			
		} // end of if("POST".equalsIgnoreCase(method))
		
		request.setAttribute("method", method);
		
		// method가 get 방식일 경우에는 그냥 비밀번호 찾기 모달창으로 보내준다.
		// 만일 post 로 들어온다면 위에 메소드를 지나온 다음에 여기로 넘어온다. 
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/login/passwdFind.jsp");
		
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
