package kcy.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.ReviewVO;
import kcy.shop.model.InterProductDAO;
import kcy.shop.model.ProductDAO;
import my.util.MyUtil;

public class Review_look extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		// *** 리뷰 상세보여주기 ***//
		String pnum = request.getParameter("pnum");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("pnum", pnum);

		InterProductDAO pdao = new ProductDAO();
		ReviewVO review_select_one = pdao.rnumReviewDetail(paraMap);
		
		
		System.out.println("실행됨");
//		System.out.println(review_look.size());
		
		String currentURL = MyUtil.getCurrentURL(request);
		request.setAttribute("goBackURL", currentURL);
		//
		
		request.setAttribute("pnum", pnum);
		
		
		super.setViewPage("/WEB-INF/product/modal_review_look.jsp"); // key값이 json 인 jsonview.jsp에 뿌러준다.
		
		
		// *** 리뷰 보여주기 끝 ***//
		
		
		
		
		
	}

}
