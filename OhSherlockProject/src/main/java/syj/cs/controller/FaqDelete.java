package syj.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import syj.cs.model.FaqDAO;
import syj.cs.model.InterFaqDAO;

public class FaqDelete extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session =  request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if( loginuser != null && "admin".equals(loginuser.getUserid()) ) {
			// 관리자(admin)으로 로그인 했을 경우
			String faq_num = request.getParameter("faq_num");
			
			InterFaqDAO fdao = new FaqDAO();
			
			// faq 삭제하기
			int n = fdao.faqDelete(faq_num);
			
			if(n==1) {
				String message = "자주묻는질문이 삭제되었습니다.";
		        String loc = request.getContextPath() + "/cs/faq.tea";
		        
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		        
		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
			} else {
				String message = "자주묻는질문 삭제에 실패하였습니다.";
		        String loc = request.getContextPath() + "/cs/faq.tea";
		        
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		        
		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
			}
			
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
