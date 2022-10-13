package kcy.shop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.ReviewVO;
import kcy.shop.model.ProductDAO;

public class ReviewDetail extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String rnum = request.getParameter("rnum");
		
		ProductDAO pdao = new ProductDAO();
		ReviewVO rvo = pdao.rnumReviewDetail(rnum);
		
		if(rvo != null) {
			request.setAttribute("rvo", rvo);
		}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/product_review.jsp");
		
		
		
	}
	
	
	
	

}
