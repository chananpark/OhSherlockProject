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

public class FaqRegisterEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String message;
		String loc;
		
		// url을 알아내서 접속할 수도 있기 때문에 로그인 없이 들어올 수 없도록 막아주어야 한다.
		
		HttpSession session =  request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if( loginuser != null && "admin".equals(loginuser.getUserid()) ) {
			// 관리자(admin)으로 로그인 했을 경우
			
			String faq_category = request.getParameter("faq_category");
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			content = content.replace("\r\n","<br>");
			
			InterFaqDAO fdao = new FaqDAO();

			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("faq_category", faq_category);
			paraMap.put("title", title);
			paraMap.put("content", content);
			
			// 자주묻는 질문 글 작성
			int n = fdao.registerFaq(paraMap);
			
			if (n==1) {
				message = "자주묻는질문 등록이 완료되었습니다.";
				// 방금 작성한 글 조회 화면
				loc = request.getContextPath() + "/cs/faq.tea";
	
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
	
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			else {
				message = "자주묻는질문 등록을 실패하였습니다.";
				loc = request.getContextPath() + "/cs/faq.tea";
	
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
	
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			
		} else {
			// 로그인을 안한 경우 또는 일반 사용자로 로그인 했을 경우
			message = "관리자 이외에는 접근이 불가합니다.";
	        loc = "javascript:history.back()";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
		} // end of if-else

		
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
