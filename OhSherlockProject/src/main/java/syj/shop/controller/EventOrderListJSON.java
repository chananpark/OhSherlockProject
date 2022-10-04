package syj.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.ProductVO;
import syj.shop.model.InterProductDAO;
import syj.shop.model.ProductDAO;

public class EventOrderListJSON extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String selectid = request.getParameter("selectid"); 
		
		InterProductDAO pdao = new ProductDAO();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("selectid", selectid); 
		
	//	List<ProductVO> productList = pdao.selectOrderProductList(paraMap);
		
		
		
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception 

}
