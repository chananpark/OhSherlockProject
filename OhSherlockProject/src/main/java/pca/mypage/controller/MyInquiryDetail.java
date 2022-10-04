package pca.mypage.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.InquiryVO;
import common.model.MemberVO;
import pca.cs.model.InquiryDAO;
import pca.cs.model.InterInquiryDAO;

public class MyInquiryDetail extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String fk_userid = request.getParameter("fk_userid");
		String inquiry_no = request.getParameter("inquiry_no");

		if (loginuser == null) {
			String message = "먼저 로그인 하셔야 합니다.";
			String loc = request.getContextPath() + "/login/login.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
		else if(loginuser.getUserid().equals(fk_userid)){
			// 로그인한 사용자가 자신의 문의내용을 조회하는 경우
			
			InterInquiryDAO idao = new InquiryDAO();
			InquiryVO ivo = idao.showMyInquiryDetail(inquiry_no);
			
			if(ivo != null) {
				request.setAttribute("ivo", ivo);
			}
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/mypage/my_inquiry_detail.jsp");
		
		} else {
			String message = "다른 사용자의 문의내용은 조회할 수 없습니다!";
			String loc = request.getContextPath() + "/login/login.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
	}

}
