package pca.member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import syj.member.model.InterMemberDAO;
import syj.member.model.MemberDAO;

public class PasswdReset extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();
		String message = "";
		String loc = "";
		 
		// get 방식이라면
		if ("GET".equalsIgnoreCase(method)) {
			message = "잘못된 접근입니다.";
			loc = request.getContextPath() + "/index.tea";
		}
		
		else {
			// 암호 변경하기 버튼을 누른 경우

			String userid = request.getParameter("userid");
			String passwd = request.getParameter("passwd");

			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("passwd", passwd);
			paraMap.put("userid", userid);

			InterMemberDAO mdao = new MemberDAO();
			int n = mdao.passwdUpdate(paraMap);
			
			if (n == 1) { // 변경 성공시
				message = "비밀번호가 변경되었습니다. 다시 로그인 하세요.";
				loc = request.getContextPath() + "/login/login.tea";
			} else {
				loc = request.getContextPath() + "/error.tea";
			}

		}
		
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);
		
		super.setViewPage("/WEB-INF/msg.jsp");

	}

}
