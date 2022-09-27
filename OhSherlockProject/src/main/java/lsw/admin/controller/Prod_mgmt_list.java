package lsw.admin.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;


public class Prod_mgmt_list extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		if("GET".equalsIgnoreCase(method)) { //"GET"
			if( !super.checkLogin(request) ) {
				// == 로그인을 안한 상태로 들어왔을 때는 접근을 못하게 막는다. == //
				String message = "상품 조회를 위해서는 로그인을 해주세요.";
		        String loc = "javascript:history.back()";
		        
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		        
		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
		        
			}
			
		}
		else {	// "POST""

		}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/admin/prod_mgmt_list.jsp");
		
	}

}
