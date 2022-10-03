package pca.mypage.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class InquiryList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

		if (loginuser == null) {
			String message = "먼저 로그인 하셔야 합니다.";
			String loc = request.getContextPath() + "/login/login.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}else {
			if(!loginuser.getUserid().equals("admin"))
				super.setViewPage("/WEB-INF/mypage/inquiry_list.jsp");
			else {
				String message = "회원 전용 메뉴입니다.";
				String loc = request.getContextPath() + "/index.tea";
	
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
			}
		}
	}
}
