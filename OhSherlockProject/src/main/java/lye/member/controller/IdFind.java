package lye.member.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import lye.member.model.*;

public class IdFind extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();   // "GET" 또는 "POST"
		
		if("POST".equalsIgnoreCase(method)) { 
			// 아이디 찾기 모달창에서 찾기 버튼을 클릭했을 경우
			
			String name = request.getParameter("name");   
			String email = request.getParameter("email"); 
			
			InterMemberDAO mdao = new MemberDAO();  
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("name", name);
			paraMap.put("email", email);
			
			String userid = mdao.idFind(paraMap); // 아이디값 찾기. 입력한 값이 존재하는지 여부확인
			
			if(userid != null) {  // 입력한 성명 및 이메일이 존재한다면
				request.setAttribute("userid", userid);
			}
			else {  // 입력한 성명 및 이메일이 존재하지 않는다면
				request.setAttribute("userid", "fail");
			}
			
			request.setAttribute("name", name);  
			request.setAttribute("email", email);
			
		}// end of if("POST".equalsIgnoreCase(method))-----------------------------
		
		request.setAttribute("method", method);
		
	//	super.setRedirect(false);
		super.setViewPage("/WEB-INF/login/idFind.jsp");  // idFind.jsp 로 넘겨준다. forward 방식
	}
		
		

}
