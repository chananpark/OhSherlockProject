package pca.member.controller;

import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;

public class Activate extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();

		// get 방식의 경우
		if ("get".equalsIgnoreCase(method)) {
			super.setViewPage("/WEB-INF/login/activate.jsp"); // 휴면 해제 페이지로 이동
		}
		// post 방식의 경우
		else {
			// 휴면해제 페이지에서 확인을 클릭했을 경우

			String userid = request.getParameter("userid");
			String email = request.getParameter("email");
			String name = request.getParameter("name");

			// 해당 유저의 이메일로 메일보내기
			boolean sendMailSuccess = false; // 메일이 정상적으로 전송되었는지 유무를 알아오기 위한 용도

			// 랜덤 인증키 생성
			Random rnd = new Random();

			// 영문소문자 5글자 + 숫자 7글자
			String authentiCode = "";

			char randchar = ' ';
			for (int i = 0; i < 5; i++) {
				randchar = (char) (rnd.nextInt('z' - 'a' + 1) + 'a');
				authentiCode += randchar;
			}

			int randnum = 0;
			for (int i = 0; i < 7; i++) {
				randnum = rnd.nextInt(9 - 0 + 1) + 0;
				authentiCode += randnum;
			} 
			// 생성된 인증코드(certificationCode)를 사용자의 email로 전송한다.
			GoogleMail mail = new GoogleMail();

			try {
				mail.sendmail(userid, email, authentiCode);
				sendMailSuccess = true; // 메일 전송 성공 표시

				HttpSession session = request.getSession();
				// 발급한 인증코드를 세션에 저장
				session.setAttribute("authentiCode", authentiCode);

			} catch (Exception e) { // 메일 전송이 실패한 경우
				e.printStackTrace();
				sendMailSuccess = false; // 메일 전송 실패 표시
			}
 
			request.setAttribute("userid", userid);
			request.setAttribute("email", email);
			request.setAttribute("name", name);
			request.setAttribute("sendMailSuccess", sendMailSuccess);
			request.setAttribute("method", method);
			super.setViewPage("/WEB-INF/login/activate.jsp");
		}
	}

}
