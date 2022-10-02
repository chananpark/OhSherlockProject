package syj.shop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class Product_list_event extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/product_list_event.jsp");
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
