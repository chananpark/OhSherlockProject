package lye.mypage.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class LikeList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 찜목록을 조회하기 위한 전제조건은 먼저 로그인을 해야 하는 것이다.
		if( super.checkLogin(request) ) {  // 부모클래스(super)인 AbstractController 에서 넘어옴.
			// 로그인을 했으면
			
			String userid = request.getParameter("userid");  
		
			HttpSession sesseion = request.getSession(); // 세션 불러오기
			MemberVO loginuser = (MemberVO) sesseion.getAttribute("loginuser");
			
			if( loginuser.getUserid().equals(userid) ) {
				// 로그인한 사용자가 찜목록을 조회하는 경우
				
			 // super.setRedirect(false); 
				request.setAttribute("loginuser", loginuser);
				
				super.setViewPage("/WEB-INF/mypage/like_list.jsp");  // 찜목록 페이지로 이동
				
			}
			else {
				// 로그인한 사용자가 다른 사용자의 찜목록 접속을 시도한 경우
				
				String message ="비정상적인 경로로 들어왔습니다.";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				
			//	super.setRedirect(false);  
				super.setViewPage("/WEB-INF/msg.jsp");
				
			}
			
		}
		else {
			// 로그인을 안 했으면  => 로그인없이 예전 본인 로그인시 정보수정하기 페이지에 접속했던 url 을 복붙한경우(get방식)
			
			String message ="로그인 후 접속가능합니다.";
			String loc = "javascript:history.back()";  
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
		//	super.setRedirect(false); 
			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
