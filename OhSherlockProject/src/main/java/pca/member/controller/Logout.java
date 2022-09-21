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

		super.setRedirect(true);
		super.setViewPage(request.getContextPath() + "/index.tea");
	}

}
