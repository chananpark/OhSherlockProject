package pca.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class Inquiry extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		boolean isLogined = checkLogin(request);
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		// 로그인 했을때만 들어올 수 있음
		if(isLogined) {
			
			// get방식의 경우
			if("get".equalsIgnoreCase(method)) {
				
				// 사용자의 경우
				if(!loginuser.getUserid().equals("admin"))
					super.setViewPage("/WEB-INF/cs/inquiry.jsp");
				// 관리자의 경우
				else
					super.setViewPage("/WEB-INF/admin/inquary_list_admin.jsp");
			}
			// post방식의 경우
			else {
				String inquirytype = request.getParameter("inquirytype");
				String title = request.getParameter("title");
				String content = request.getParameter("content");
				String answer_email = request.getParameter("answer_email"); // 체크:on 미체크:null
				String answer_sms = request.getParameter("answer_sms"); // 체크:on 미체크:null
				
				//System.out.println((answer_email==null));
			}
			
		} else {
			// 로그인 안했으면

			String message = "로그인이 필요한 메뉴입니다.";
			String loc = request.getContextPath() + "/login/login.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
