package lye.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.ReviewVO;
import lye.shop.model.InterProductDAO;
import lye.shop.model.ProductDAO;
import my.util.MyUtil;

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
			
			
			Map<String, Object> paraMap = new HashMap<>();
			
			paraMap.put("loginuser", loginuser);
			String userid = loginuser.getUserid();
			
			//List<ReviewVO> reviewList = pdao.ProductReviewList(loginuser.getUserid()); 
			
			
			// 현재 페이지 번호
			String currentShowPageNo = request.getParameter("currentShowPageNo");
			
			if (currentShowPageNo == null) {
				currentShowPageNo = "1";
			}
			
			try {
				if (Integer.parseInt(currentShowPageNo) < 1) {
					currentShowPageNo = "1";
				}

			} catch (NumberFormatException e) {
				currentShowPageNo = "1";
			}
			
			paraMap.put("currentShowPageNo", currentShowPageNo);
			
			// 총 페이지 수 알아오기
			int totalPage = pdao.getTotalPages(userid);
			
			// currentShowPageNo에 totalPage보다 큰 값을 입력한 경우 1페이지로 가게함
			if (Integer.parseInt(currentShowPageNo) > totalPage) {
				currentShowPageNo = "1";
			}
			
			List<ReviewVO> reviewList = pdao.selectPagingReview(paraMap);
			System.out.println(reviewList);
			request.setAttribute("reviewList", reviewList);
			
			String pageBar = "";

			int blockSize = 5;
			// blockSize 블럭(토막)당 보여지는 페이지 번호의 개수이다.

			int loop = 1;
			// loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.

			// !!!! 다음은 pageNo를 구하는 공식이다. !!!! //
			int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;
			// pageNo는 페이지바에서 보여지는 첫번째 번호이다.

			// 맨 첫 페이지와 이전 페이지 버튼
			if (pageNo > 1) {
				pageBar += "<li class='page-item'><a class='page-link' href='reviewList.tea?currentShowPageNo=1'><<</a></li>";				
				pageBar += "<li class='page-item'><a class='page-link' href='reviewList.tea?currentShowPageNo=" + (pageNo - 1) + "'><</a></li>";
			}
			
			// 페이지바
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
					// 선택한 페이지에 active 클래스
					pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
				} else {
					pageBar += "<li class='page-item'><a class='page-link' href='reviewList.tea?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
				}
				
				loop++;
				pageNo++;
				
			} 
			
			// 다음 페이지와 맨 마지막 페이지 버튼
			if( pageNo <= totalPage ) { 
				pageBar += "<li class='page-item'><a class='page-link' href='reviewList.tea?currentShowPageNo="+pageNo+"'>></a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='reviewList.tea?currentShowPageNo="+totalPage+"'>>></a></li>";
			}
			
			//
			String currentURL = MyUtil.getCurrentURL(request);
			request.setAttribute("goBackURL", currentURL);
			//
			
			request.setAttribute("pageBar", pageBar);
			request.setAttribute("reviewList", reviewList);
			
		    // super.setRedirect(false);
			super.setViewPage("/WEB-INF/mypage/review_list.jsp"); // reviewList 를 담아서 myReview_list.jsp 에 넘겨준다.
			
		}
		
	}

}
