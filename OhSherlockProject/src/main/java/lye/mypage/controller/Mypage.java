package lye.mypage.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class Mypage extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		
		// 마이페이지 접속 전제조건은 먼저 로그인을 해야 한다.
		if( super.checkLogin(request) ) { 
			// 로그인을 했으면
			
           	//super.setRedirect(false); 		
			super.setViewPage("/WEB-INF/mypage/mypage.jsp"); // 마이페이지로 이동  
			
		}
		else {
			// 로그인을 안 했으면   => 로그인없이 예전 본인 로그인시 마이페이지에 접속했던 url 을 복붙한경우(get방식)
			
			String message ="로그인 후 접속가능합니다.";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
		    //	super.setRedirect(false); 
			super.setViewPage("/WEB-INF/msg.jsp");
	
		}
	}

}
