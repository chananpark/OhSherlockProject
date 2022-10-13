package kcy.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.ProductVO;
import common.model.ReviewVO;
import kcy.shop.model.InterProductDAO;
import kcy.shop.model.ProductDAO;
import my.util.MyUtil;

public class ProductView extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		// *** 리뷰 보여주기 ***//
		
		InterProductDAO pdao = new ProductDAO();
		Map<String, String> paraMap = new HashMap<>();
		
		String pnum = request.getParameter("pnum");
		paraMap.put("pnum", pnum);
	//	System.out.println(pnum);
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
		int totalPage = pdao.getTotalPage(paraMap);
		
		// currentShowPageNo에 totalPage보다 큰 값을 입력한 경우 1페이지로 가게함
		if (Integer.parseInt(currentShowPageNo) > totalPage) {
			currentShowPageNo = "1";
			paraMap.put("currentShowPageNo", currentShowPageNo);
		}
		
		List<ReviewVO> reviewList = pdao.showReviewList(paraMap);
		request.setAttribute("reviewList", reviewList);
		
		
		System.out.println("실행됨");
		System.out.println(reviewList.size());
		
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
			pageBar += "<li class='page-item'><a class='page-link' href='product_review.tea?currentShowPageNo=1'><<</a></li>";				
			pageBar += "<li class='page-item'><a class='page-link' href='product_review.tea?currentShowPageNo=" + (pageNo - 1) + "'><</a></li>";
		}
		
		// 페이지바
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
				// 선택한 페이지에 active 클래스
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
			} else {
				pageBar += "<li class='page-item'><a class='page-link' href='product_review.tea?currentShowPageNo="+pageNo+"</a></li>";
			}
			
			loop++;
			pageNo++;
			
		} 
		
		// 다음 페이지와 맨 마지막 페이지 버튼
		if( pageNo <= totalPage ) { 
			pageBar += "<li class='page-item'><a class='page-link' href='product_review.tea?currentShowPageNo="+pageNo+"'>></a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='product_review.tea?currentShowPageNo="+totalPage+"'>>></a></li>";
		}
		
		//
		String currentURL = MyUtil.getCurrentURL(request);
		request.setAttribute("goBackURL", currentURL);
		//
		
		request.setAttribute("pnum", pnum);
		
		request.setAttribute("pageBar", pageBar);
		
		
		
//		super.setViewPage("/WEB-INF/jsonview.jsp"); // key값이 json 인 jsonview.jsp에 뿌러준다.
		
		
		// *** 리뷰 보여주기 끝 ***//
		
		
		
		
		
		// 카테고리 목록을 조회해오기
		super.getCategoryList(request);
		
		
	//				InterProductDAO pdao = new ProductDAO();
		
		// 제품번호를 가지고서 해당 제품의 정보를 조회해오기
		ProductVO pvo = pdao.selectOneProductByPnum(pnum);
		
		// 제품번호를 가지고서 해당 제품의 추가된 이미지 정보를 조회해오기
		List<String> imgList = pdao.getImagesByPnum(pnum);
		
		if(pnum == null) {
			// GET 방식이므로 사용자가 웹브라우저 주소창에서 장난쳐서 존재하지 않는 제품번호를 입력한 경우
			String message = "검색하신 제품은 존재하지 않습니다.";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
			
			return;
		}
		
		else {
			// 제품이 있는 경우 
			request.setAttribute("pvo", pvo);  // 제품의 정보
			request.setAttribute("imgList", imgList); // 해당 제품의 추가된 이미지 정보 
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/product/product_view.jsp"); 
		}
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}
