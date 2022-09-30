package syj.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.*;
import common.model.*;

public class FaqRegister extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// url을 알아내서 접속할 수도 있기 때문에 로그인 없이 들어올 수 없도록 막아주어야 한다.
		
		HttpSession session =  request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if( loginuser != null && "admin".equals(loginuser.getUserid()) ) {
			// 관리자(admin)으로 로그인 했을 경우
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/admin/faqRegister_admin.jsp");
			
		} else {
			// 로그인을 안한 경우 또는 일반 사용자로 로그인 했을 경우
			String message = "관리자 이외에는 접근이 불가합니다.";
	        String loc = request.getContextPath() + "/login/login.tea";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
		} // end of if-else
		
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
