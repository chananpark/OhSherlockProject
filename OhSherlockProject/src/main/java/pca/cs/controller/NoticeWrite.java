package pca.cs.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class NoticeWrite extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String message = "";
		String loc = "";

		// 사용자의 경우
		if ((loginuser != null && !loginuser.getUserid().equals("admin")) || loginuser == null) {
			message = "관리자만 접속 가능한 페이지입니다.";
			loc = request.getContextPath() + "/index.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
		// 관리자의 경우
		else
			super.setViewPage("/WEB-INF/admin/noticeWrite_admin.jsp");

	}

}
