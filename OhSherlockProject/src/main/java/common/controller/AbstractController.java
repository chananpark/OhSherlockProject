package common.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import common.model.MemberVO;
import pca.shop.model.InterProductDAO;
import pca.shop.model.ProductDAO;

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
	
	///////////////////////////////////////////////////////////////
	// 티제품 카테고리 조회
	public void getTeaCategoryList(HttpServletRequest request) throws SQLException {
		InterProductDAO pdao = new ProductDAO();
		List<HashMap<String, String>> categoryList = pdao.getCategoryList(); 
		
		request.setAttribute("categoryList", categoryList);
	}
	
	// 기프트세트 카테고리 조회
	public void getGiftsetCategoryList(HttpServletRequest request) throws SQLException {
	    InterProductDAO pdao = new ProductDAO();
	    List<HashMap<String, String>> categoryList = pdao.getCategoryList(); 
	    //ProductDAO 카테고리 조회 메소드 실행

	    request.setAttribute("giftsetCategoryList", categoryList);
	    // request 영역에 저장
	}
	
	// 이벤트 단품 카테고리 조회
	public void getEventCategoryList(HttpServletRequest request) throws SQLException {
	    syj.shop.model.InterProductDAO pdao = new syj.shop.model.ProductDAO();
	    List<HashMap<String, String>> prodCategoryList = pdao.getProdCategoryList(); 
	    //ProductDAO 카테고리 조회 메소드 실행

	    request.setAttribute("prodCategoryList", prodCategoryList);
	    // request 영역에 저장
	}
}
