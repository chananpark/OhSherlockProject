package syj.shop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import syj.shop.model.InterProductDAO;
import syj.shop.model.ProductDAO;

public class CartDel extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();
		
		if(!"POST".equalsIgnoreCase(method)) {
			// get 방식
			String message = "비정상적인 접근입니다.";
	        String loc = "javascript:history.back()";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
			
		} else if("POST".equalsIgnoreCase(method) && super.checkLogin(request) ){
			// post 방식 이면서 동시에 로그인이 된 상태여야 한다.
			String cartno = request.getParameter("cartno");
			
			InterProductDAO pdao = new ProductDAO();
				
			// 장바구니 테이블에서 특정 제품을 장바구니에서 지우기
			int n = pdao.delCart(cartno);
			
			JSONObject jsobj = new JSONObject(); // {}
			jsobj.put("n", n); // {n:1}

			String json = jsobj.toString(); // "{n:1}"  // 문자타입으로 변환
			
			request.setAttribute("json", json);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
		}
		
		
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
