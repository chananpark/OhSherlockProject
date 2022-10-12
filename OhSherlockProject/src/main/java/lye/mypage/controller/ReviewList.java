package lye.mypage.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.ReviewVO;
import lye.shop.model.InterProductDAO;
import lye.shop.model.ProductDAO;

public class ReviewList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 마이페이지 상품 리뷰는 반드시 해당사용자가 로그인을 해야만 볼 수 있다.
		boolean isLogin = super.checkLogin(request);
		
		if(!isLogin) { // 로그인을 하지 않은 상태이라면
			
			request.setAttribute("message", "상품 리뷰는 로그인 후 이용 가능합니다.");
			request.setAttribute("loc", request.getContextPath() + "/login/login.tea");
			
			// super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
			return; // 종료
		}
		else {  // 로그인한 상태라면
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			InterProductDAO pdao = new ProductDAO();
			List<ReviewVO> reviewList = pdao.ProductReviewList(loginuser.getUserid()); 
			
			
			
			
			request.setAttribute("reviewList", reviewList);
			
		    // super.setRedirect(false);
			super.setViewPage("/WEB-INF/mypage/review_list.jsp"); // reviewList 를 담아서 myReview_list.jsp 에 넘겨준다.
			
		}
		
	}

}
