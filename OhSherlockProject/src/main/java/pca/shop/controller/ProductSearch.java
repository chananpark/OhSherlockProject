package pca.shop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class ProductSearch extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String searchWord = request.getParameter("searchWord");
		request.setAttribute("searchWord", searchWord);
		
		super.setViewPage("/WEB-INF/product/product_search.jsp");
		
	}

}
