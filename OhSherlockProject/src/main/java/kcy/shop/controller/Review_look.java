package kcy.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.ReviewVO;
import kcy.shop.model.InterProductDAO;
import kcy.shop.model.ProductDAO;
import my.util.MyUtil;

public class Review_look extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 카테고리 목록을 조회해오기
		super.getCategoryList(request);
				
		// *** 리뷰 상세보여주기 ***//
		String pnum = request.getParameter("pnum");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("pnum", pnum);

		InterProductDAO pdao = new ProductDAO();
		ReviewVO review_select_one = pdao.rnumReviewDetail(paraMap);
		
		request.setAttribute("review_select_one", review_select_one);
		
		System.out.println(review_select_one);
		
	//  *** 현재 페이지를 돌아갈 페이지(goBackURL)로 주소 지정하기 *** //
		String goBackURL = request.getParameter("goBackURL");
//		System.out.println("확인용 : " + goBackURL); 

		request.setAttribute("goBackURL", goBackURL); // 공백이 있는 상태 그대로 전달해준다.
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/modal_review_look.jsp"); 
		
		
		// *** 리뷰 보여주기 끝 ***//
		
		
		
		
		
	}

}
