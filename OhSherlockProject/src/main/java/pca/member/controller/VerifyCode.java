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
			else {
				message = "인증코드가 다릅니다. \\n인증코드를 다시 발급받으세요.";
				loc = request.getContextPath() + "/login/activate.tea";
				// 인증 창으로 다시 돌아간다.
			}
		} else {
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
