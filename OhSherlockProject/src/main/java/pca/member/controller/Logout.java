package pca.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;

public class Logout extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 로그아웃 처리하기
 
		HttpSession session = request.getSession();
		session.invalidate();

		String message = "로그아웃 되었습니다.";
		String loc = request.getContextPath() + "/index.tea";
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);

		super.setRedirect(false);
		super.setViewPage("/WEB-INF/msg.jsp");
	}

}
