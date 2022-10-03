package pca.shop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class ProductGiftset extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		super.getGiftsetCategoryList(request);
		
		super.setViewPage("/WEB-INF/product/product_list_giftset.jsp");
	}

}
