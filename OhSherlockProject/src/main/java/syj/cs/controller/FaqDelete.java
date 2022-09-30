package syj.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.FaqVO;
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
			System.out.println(faq_num);
			
			// TODO 여기서부터 삭제 만들기
			InterFaqDAO fdao = new FaqDAO();
			
			// 기존의 faq 내용을 faqEdit_admin.jsp 단에 뿌려주기
			FaqVO fvo = fdao.faqEditSelect(faq_num);
			
			String faq_content = fvo.getFaq_content();
			faq_content = faq_content.replace("<br>","\r\n");
			
			fvo.setFaq_content(faq_content);
			
			request.setAttribute("fvo", fvo);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/cs/faq.jsp");
			
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
