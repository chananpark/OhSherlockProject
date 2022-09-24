package pca.admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class NoticeWrite extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();
		
		if ("post".equalsIgnoreCase(method)) {
			
			super.setViewPage("/WEB-INF/admin/noticeWrite_admin.jsp");
		}
		else {
			
			String message = "잘못된 접근입니다!";
			String loc = "javascript:history.back()";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}

	}

}
