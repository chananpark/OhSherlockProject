package pca.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class Login extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		if("GET".equalsIgnoreCase(method)) { // get 방식이라면
			super.setViewPage("/WEB-INF/login/login.jsp"); // 로그인 페이지로 이동
		}
		else { // post 방식이라면
			// 로그인 처리를 해준다.
			
		}
		
	}

}
