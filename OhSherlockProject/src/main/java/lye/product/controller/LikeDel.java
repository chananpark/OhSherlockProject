package lye.product.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import lye.product.model.InterProductDAO;
import lye.product.model.ProductDAO;

public class LikeDel extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();  // 무슨 방식인지 알아옴.
		
		if(!"POST".equalsIgnoreCase(method)) {
			// GET 방식이라면 
			
			String message = "비정상적인 경로로 들어왔습니다.";
			String loc = "javascript:history.back()";  // 이전페이지로 이동
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	         
	        // super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
		}
		else if("POST".equalsIgnoreCase(method) && super.checkLogin(request)) {  
			// POST 방식이면서 로그인을 했을 경우 (올바른경우)
			
			String likenojoin = request.getParameter("likenojoin");
			
			String[] likeno = likenojoin.split("\\,");  // 배열로 만들어줌.
			
			InterProductDAO pdao = new ProductDAO();  // ProductDAO 객체생성
			
			// 찜목록 테이블에서 특정제품만 삭제하기
			int n = pdao.delLike(likeno);  // 성공적으로 pdao 에서 넘겨받았다면 n=1 이 나온다.
			
			JSONObject jsobj = new JSONObject();  // {} => JSONObject 객체생성
			jsobj.put("n", n); // {n:1}  => jsobj 에 n 값 저장하기(1 또는 0)
			
			String json = jsobj.toString();  // "{n:1}"
			
			request.setAttribute("json", json);
			
		    // super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
		}
		
		
		
	}

}
