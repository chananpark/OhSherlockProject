package lsw.admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import lsw.admin.model.InterProductDAO;
import lsw.admin.model.ProductDAO;
import lsw.admin.model.ProductVO;

public class Prod_mgmt_register extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		String method = request.getMethod(); 
		
		if("GET".equalsIgnoreCase(method)) {
		// GET 방식이라면    
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/admin/prod_mgmt_register.jsp");
		}
		
		else {
		 // POST 방식이라면(즉, 등록 버튼을 클릭한 경우) 
			
			String p_category = request.getParameter("p_category"); 
			
			String p_code = "";
				if("녹차/말차".equals(p_category)) {
					p_code = "G";
				}
				else if("홍차".equals(p_category)) {
					p_code = "B";
				}
				else if("허브차".equals(p_category)) {
					p_code = "H";
				}
				else {
					p_code = "S"; // 기프트박스
					
				}
				
			String p_name = request.getParameter("p_name"); 
			int p_price = Integer.parseInt(request.getParameter("p_price")); 
			String p_discount_rate = request.getParameter("p_discount_rate");
			int p_stock = Integer.parseInt(request.getParameter("p_stock")); 
			String p_info = request.getParameter("p_info"); 
			String p_desc = request.getParameter("p_desc"); 
			String p_thumbnail = request.getParameter("p_thumbnail"); 
			String p_image = request.getParameter("p_image"); 
			
			ProductVO product = new ProductVO(p_code, p_category, p_name, p_price, p_discount_rate, p_stock,
					 p_info, p_desc, p_thumbnail, p_image); 
			
			InterProductDAO pdao = new ProductDAO();
			
				int n = pdao.registerProduct(product);
				if(n==1) {
					
					String message = "상품등록이 완료되었습니다.";
					String loc = "javascript:self.close()"; // 팝업창 닫기
					
					request.setAttribute("message", message);
			        request.setAttribute("loc", loc);
					
					super.setRedirect(false);
					super.setViewPage("/WEB-INF/msg.jsp");
				}
				else {
					super.setRedirect(true); 
					super.setViewPage(request.getContextPath()+"/error.tea");
				}
		}
	}
}
