package lye.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;

public class AutoLogout extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 로그아웃 처리하기
 
		HttpSession session = request.getSession();
		session.invalidate();  // 세션을 없애고 세션에 속해있는 값 삭제하기
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/index.jsp");
	}

}
