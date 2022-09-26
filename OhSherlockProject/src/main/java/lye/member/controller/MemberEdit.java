package lye.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class MemberEdit extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
	
		// 내정보(회원정보)를 수정하기 위한 전제조건은 먼저 로그인을 해야 하는 것이다.
		if( super.checkLogin(request) ) {  // 부모클래스(super)인 AbstractController 에서 넘어옴.
			// 로그인을 했으면
			
			String userid = request.getParameter("userid");  // 로그인한 userid
		
			HttpSession sesseion = request.getSession(); // 세션 불러오기
			MemberVO loginuser = (MemberVO) sesseion.getAttribute("loginuser");  // 세션에 저장된 회원정보 키값 "loginuser" 불러옴.
			
			if( loginuser.getUserid().equals(userid) ) {
				// 로그인한 사용자가 자신의 정보를 수정하는 경우
				
			 // super.setRedirect(false); 
				request.setAttribute("loginuser", loginuser);
				super.setViewPage("/WEB-INF/member/memberInfo_edit.jsp");  // 회원정보수정으로 이동
				
			}
			else {
				// 로그인한 사용자가 다른 사용자의 정보를 수정하려고 시도한 경우(장난친 경우 -> 굳이 본인계정으로 로그인해서 get방식으로 다른사용자 정보수정하기 페이지를 url 로 검색하여 들어간 경우)
				
				String message ="다른 사용자의 정보 변경은 불가합니다!!";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				
			//	super.setRedirect(false);  
				super.setViewPage("/WEB-INF/msg.jsp");  // view단 페이지(msg.jsp) 로 넘겨준다. - forward 방식 
				
			}
			
		}
		
	/*	
		else {
			// 로그인을 안 했으면   => 로그인없이 예전 본인 로그인시 정보수정하기 페이지에 접속했던 url 을 복붙한경우(get방식)
			
			String message ="회원정보를 수정 하기 위해서는 먼저 로그인을 하세요!!";
			String loc = "javascript:history.go(-2)";  // 자동 로그아웃 후 로그인페이지 이동으로 수정하기***
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
		//	super.setRedirect(false); 
			super.setViewPage("/WEB-INF/msg.jsp");  // view단 페이지(msg.jsp) 로 넘겨준다. - forward 방식  
	
		}
		*/
	}

}
