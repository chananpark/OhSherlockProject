package common.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kcy.mypage.model.MemberVO;


public abstract class AbstractController implements InterCommand {

	/*
	    ※ view 단 페이지(.jsp) 이동시 
	    forward 방법: super.setRedirect(false); 
	    redirect 방법: super.setRedirect(true);
	    이동하고자 하는 페이지: super.setViewPage("페이지경로");
	*/	
	
	private boolean isRedirect = false;
	
	private String viewPage;

	public boolean isRedirect() {
		return isRedirect;
	}

	public void setRedirect(boolean isRedirect) {
		this.isRedirect = isRedirect;
	}

	public String getViewPage() {
		return viewPage;
	}

	public void setViewPage(String viewPage) {
		this.viewPage = viewPage;
	}
	
	///////////////////////////////////////////////////////////////
	// 로그인 유무를 검사해서 로그인 했으면 true 를 리턴해주고
	// 로그인 안했으면 false 를 리턴해주도록 한다.
	public boolean checkLogin(HttpServletRequest request) {
	
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if(loginuser != null) {
		// 로그인 한 경우
		return true;
		}
		else {
		// 로그인 안한 경우
		return false;
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
