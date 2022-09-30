package pca.member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import pca.member.model.InterMemberDAO;
import pca.member.model.MemberDAO;

public class Login extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();
 
		// get 방식이라면
		if ("GET".equalsIgnoreCase(method)) {
			
			// 로그인을 누르기 전 url을 세션에 담는 작업
			String ctxPath = request.getContextPath();
			String preURL = request.getHeader("referer"); // 로그인을 누르기 전에 있던 url(http://부터)
			int idx = preURL.indexOf(ctxPath);
			preURL = preURL.substring(idx); // 컨텍스트 패스 부분부터 자름
			
			HttpSession session = request.getSession();
			session.setAttribute("preURL", preURL); // 세션에 저장
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/login/login.jsp"); // 로그인 페이지로 이동
		}

		// post 방식이라면
		else {
			// 로그인 처리를 해준다.

			String userid = request.getParameter("userid");
			String passwd = request.getParameter("passwd");

			// 클라이언트의 IP 주소
			String clientip = request.getRemoteAddr();

			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("userid", userid);
			paraMap.put("passwd", passwd);
			paraMap.put("clientip", clientip);

			InterMemberDAO mdao = new MemberDAO();
			
			// 로그인 처리 메소드 실행
			MemberVO loginuser = mdao.selectOneMember(paraMap);

			// 존재하는 회원이라면
			if (loginuser != null) {
				
				// 휴면 회원이라면
				if (loginuser.getIdle() == 1) {
					
					String last_login_date = loginuser.getLast_login_date().substring(0,10);
					int last_login_year = Integer.parseInt(last_login_date.substring(0, 4));
					int idle_year = last_login_year + 1;
					String idleDate = idle_year+last_login_date.substring(4);
					
					request.setAttribute("userid", loginuser.getUserid());
					request.setAttribute("email", loginuser.getEmail());
					request.setAttribute("last_login_date", last_login_date);
					request.setAttribute("idleDate", idleDate);

					super.setViewPage("/WEB-INF/login/activate.jsp");

					return; // 메소드 종료
				}
				
				// 비밀번호 변경이 필요할 경우
				if (loginuser.isPasswdChangeRequired() == true) {

					request.setAttribute("userid", loginuser.getUserid());
					// 비밀번호 변경 페이지로 이동
					super.setRedirect(false);
					super.setViewPage("/WEB-INF/login/passwdReset.jsp");
					
					return;
				}
				// 비밀번호를 변경한지 3개월 미만인 경우
				else {

					HttpSession session = request.getSession();
					// session에 로그인 사용자 정보 저장
					session.setAttribute("loginuser", loginuser);
					
					/*
					super.setRedirect(true);
					super.setViewPage(request.getContextPath() + "/index.tea"); // 시작페이지로 이동
					*/
					String preURL = (String) session.getAttribute("preURL");
					super.setRedirect(true);
					super.setViewPage(preURL);
				}

			} else {
				String message = "로그인 실패";
				String loc = "javascript:history.back()";

				request.setAttribute("message", message);
				request.setAttribute("loc", loc);

				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
			}
		}

	}

}