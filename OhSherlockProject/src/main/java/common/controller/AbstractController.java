package common.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import common.model.MemberVO;
import my.util.MyUtil;
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
	// **** 제품목록(Category)을 보여줄 메소드 생성하기 **** //
	// VO를 사용하지 않고 Map 으로 처리해보겠습니다.  ==> db 에서 카테고리목록을 읽어올 것이다.
	public void getCategoryList(HttpServletRequest request) throws SQLException {
		
		InterProductDAO pdao = new ProductDAO();  // 객체생성 // ProductVO, ProductDAO, InterProductDAO 는 예전에 메인페이지 광고배너 이미지때문에 생성해놓았음.
		List<HashMap<String, String>> categoryList = pdao.getCategoryList();  // db 에서 조회(select)해온 것을 HashMap 에 넣어주고,
		
		request.setAttribute("categoryList", categoryList); // 키값 categoryList 을 넣어준다.
		
	}
	
	// 티제품 카테고리 조회
	public void getTeaCategoryList(HttpServletRequest request) throws SQLException {
		InterProductDAO pdao = new ProductDAO();
		List<HashMap<String, String>> categoryList = pdao.getTeaCategoryList(); 
		
		request.setAttribute("teaCategoryList", categoryList);
	}
	
	// 기프트세트 카테고리 조회
	public void getGiftsetCategoryList(HttpServletRequest request) throws SQLException {
	    InterProductDAO pdao = new ProductDAO();
	    List<HashMap<String, String>> categoryList = pdao.getCategoryList(); 
	    //ProductDAO 카테고리 조회 메소드 실행

	    request.setAttribute("giftsetCategoryList", categoryList);
	    // request 영역에 저장
	}

	// 로그인 또는 로그아웃을 하면 시작페이지로 가는 것이 아니라 방금 보았던 그 페이지로 그대로 가기 위한 것임.
	public void goBackURL(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		session.setAttribute("goBackURL", MyUtil.getCurrentURL(request));  
		// MyUtil.getCurrentURL(request) 는 현재 보고있는 url 을 알아온다.
	}
	
}
