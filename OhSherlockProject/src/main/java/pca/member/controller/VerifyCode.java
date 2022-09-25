package pca.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import pca.member.model.InterMemberDAO;
import pca.member.model.MemberDAO;

public class VerifyCode extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		HttpSession session = request.getSession(); // 세션 불러오기
		String authentiCode = (String) session.getAttribute("authentiCode");
		
		String message = "";
		String loc = "";		

		if ("POST".equalsIgnoreCase(method)) {
			String userAuthentiCode = request.getParameter("userAuthentiCode");
			String userid = request.getParameter("userid");
			String clientip = request.getRemoteAddr();
			
			// 인증코드 일치 시
			if(authentiCode.equals(userAuthentiCode)) {
				
				// idle 컬럼 상태 update하기
				InterMemberDAO mdao = new MemberDAO();
				int n = mdao.activateMember(userid, clientip);
				
				if (n==1) {
					// 성공 메시지를 띄우고 인덱스로 돌아간다.
					message = "휴면상태가 해제되었습니다. 다시 로그인 하세요.";
					loc = request.getContextPath() + "/login/login.tea";
				}
				else {
					loc = request.getContextPath() + "/error.tea";
				}
			}
			// 인증코드 불일치 시
			else {
				String email = request.getParameter("email");
				String last_login_date = request.getParameter("last_login_date");
				String idleDate = request.getParameter("idleDate");

				request.setAttribute("userid", userid);
				request.setAttribute("email", email);
				request.setAttribute("last_login_date", last_login_date);
				request.setAttribute("idleDate", idleDate);
				request.setAttribute("verifyFail", true);
				
				// 인증 창으로 다시 돌아간다.
				super.setViewPage("/WEB-INF/login/activate.jsp");
				
				// 세션에 저장된 인증코드 삭제
				session.removeAttribute("certificationCode");
				
				return;
			}
		} 
		// get방식 접근 시
		else {
			message = "잘못된 접근입니다.";
			loc = "javascript:history.back()";
		}
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			super.setViewPage("/WEB-INF/msg.jsp");
		
		// 세션에 저장된 인증코드 삭제
		session.removeAttribute("certificationCode");
		
	}
}
