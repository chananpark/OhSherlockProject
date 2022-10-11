package syj.cs.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import syj.cs.model.FaqDAO;
import syj.cs.model.InterFaqDAO;

public class FaqEditEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();
		
		if("POST".equalsIgnoreCase(method)) {
			
			HttpSession session =  request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			if( loginuser != null && "admin".equals(loginuser.getUserid()) ) {
				// 관리자(admin)으로 로그인 했을 경우
				
				String faq_num = request.getParameter("faq_num");
				String faq_category = request.getParameter("faq_category");
				String title = request.getParameter("title");
				String content = request.getParameter("content");
				content = content.replace("\r\n","<br>");
				content = content.replaceAll("<", "&lt;");
				content = content.replaceAll(">", "&gt;");
				
				Map<String,String> paraMap = new HashMap<>();
				paraMap.put("faq_num", faq_num);
				paraMap.put("faq_category", faq_category);
				paraMap.put("title", title);
				paraMap.put("content", content);
				
				// 수정된 FAQ DB에 업데이트 해주는 메소드
				InterFaqDAO fdao = new FaqDAO();
				int n = fdao.faqEditUpdate(paraMap);
				
				if(n == 1) {
					String message = "자주묻는질문 수정이 완료되었습니다.";
					String loc = request.getContextPath() + "/cs/faq.tea";

					request.setAttribute("message", message);
					request.setAttribute("loc", loc);

					super.setViewPage("/WEB-INF/msg.jsp");
				} else {
					String message = "공지사항 수정을 실패하였습니다.";
					String loc = request.getContextPath() + "/cs/faq.tea";

					request.setAttribute("message", message);
					request.setAttribute("loc", loc);

					super.setViewPage("/WEB-INF/msg.jsp");
				}
				
			} else {
				// 로그인을 안한 경우 또는 일반 사용자로 로그인 했을 경우
				String message = "관리자 이외에는 접근이 불가합니다.";
		        String loc = request.getContextPath() + "/login/login.tea";
		        
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		        
		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
				
			} // end of if-else
			
		} else {
			// get 방식으로 접근했을 경우
			String message = "잘못된 접근입니다.";
	        String loc =  request.getContextPath() + "/index.tea";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
		} // end of if-else
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
