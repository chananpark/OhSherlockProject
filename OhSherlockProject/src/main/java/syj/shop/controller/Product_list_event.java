package syj.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.ProductVO;
import syj.shop.model.*;

public class Product_list_event extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String category = request.getParameter("");
		String orderList = request.getParameter("");
		
		InterProductDAO pdao = new ProductDAO();
		Map<String, String> paraMap = new HashMap<>();

		
		
		
	//	List<ProductVO> prodList = pdao.selectProduct();
		
		
		
		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/product_list_event.jsp");
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
