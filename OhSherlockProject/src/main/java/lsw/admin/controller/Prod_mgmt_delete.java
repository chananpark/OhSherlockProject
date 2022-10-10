package lsw.admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import common.model.MemberVO;
import lsw.admin.model.InterProductDAO;
import lsw.admin.model.ProductDAO;

public class Prod_mgmt_delete extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		HttpSession session =  request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if(!"POST".equals(method)) {
			// GET 방식이라면
			String message = "비정상적인 경로로 들어왔습니다.";
	        String loc = "javascript:history.back()";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        //super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
		}
		
		
		else if("POST".equals(method) && "admin".equals(loginuser.getUserid())) {
			// POST 방식이고 로그인을 했다라면 
			
			String pnum = request.getParameter("pnum");
			
			InterProductDAO pdao = new ProductDAO();
			
			// 상품테이블에서 상품 삭제
			int n = pdao.prod_mgmt_delete(pnum);
			
			JSONObject jsonObj = new JSONObject(); // {}
			jsonObj.put("n", n); // {n:1}
			
			String json = jsonObj.toString(); // "{n:1}"
			
			request.setAttribute("json", json);
			
			// super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		}// end of else if 

	}

}
