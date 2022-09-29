package pca.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.InquiryVO;
import common.model.MemberVO;
import pca.cs.model.InquiryDAO;
import pca.cs.model.InterInquiryDAO;

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
					super.setRedirect(false);
				// 사용자의 경우
				if(!loginuser.getUserid().equals("admin"))
					super.setViewPage("/WEB-INF/cs/inquiry.jsp");
				// 관리자의 경우
				else
					super.setViewPage("/WEB-INF/admin/inquary_list_admin.jsp");
			}
			// post방식의 경우
			else {
				String inquiry_type = request.getParameter("inquiry_type");
				String inquiry_subject = request.getParameter("inquiry_subject");
				String inquiry_content = request.getParameter("inquiry_content");
				inquiry_content = inquiry_content.replace("\r\n","<br>");
				String inquiry_email = request.getParameter("inquiry_email"); // 체크:on 미체크:null
				String inquiry_sms = request.getParameter("inquiry_sms"); // 체크:on 미체크:null
				
				InquiryVO ivo = new InquiryVO();
				InterInquiryDAO idao = new InquiryDAO();
				
				ivo.setFk_userid(loginuser.getUserid());
				ivo.setInquiry_type(inquiry_type);
				ivo.setInquiry_subject(inquiry_subject);
				ivo.setInquiry_content(inquiry_content);
				
				if(inquiry_email != null) {
					ivo.setInquiry_email(1);
				}else{
					ivo.setInquiry_email(0);
				}
				
				if(inquiry_sms != null) {
					ivo.setInquiry_sms(1);
				}else{
					ivo.setInquiry_sms(0);
				}
				
				int n = idao.makeInquiry(ivo);
				
				if (n==1) {
					// 글쓰기 성공 시
					// 마이페이지에서 1:1 문의내역 페이지로 이동시킨다.
					super.setRedirect(true);
					super.setViewPage(request.getContextPath() + "/mypage/inquiryList.tea");
				}
				else {
					// 실패 시 오류 페이지로 리다이렉트
					super.setRedirect(true);
					super.setViewPage(request.getContextPath() + "/error.up");
				}
				
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
