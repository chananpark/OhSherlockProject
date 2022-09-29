package syj.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class FaqEdit extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session =  request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if( loginuser != null && "admin".equals(loginuser.getUserid()) ) {
			// 관리자(admin)으로 로그인 했을 경우
			String faq_num = request.getParameter("faq_num");

			// TODO 
			// faq num 을 받아줬으니 이 num 에 따른 데이터를 가져와서 다시 수정하는 단으로 넘겨주어야 한다.
			
			
			
			
			
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/admin/faqRegister_admin.jsp");
			
		} else {
			// 로그인을 안한 경우 또는 일반 사용자로 로그인 했을 경우
			String message = "관리자 이외에는 접근이 불가합니다.";
	        String loc = "javascript:history.back()";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
		} // end of if-else
		
		
		
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
