package lye.member.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import lye.member.model.InterMemberDAO;
import lye.member.model.MemberDAO;

public class EmailDuplicateCheck_2 extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();   // "GET" 또는 "POST"
		
		if("POST".equalsIgnoreCase(method)) { 
			
			String email = request.getParameter("email");  
			String userid = request.getParameter("userid");
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("email", email);
			paraMap.put("userid", userid);
			
			InterMemberDAO mdao = new MemberDAO(); // MemberDAO 객체생성
			boolean isExists = mdao.emailDuplicateCheck_2(paraMap);
			
			JSONObject jsonObj = new JSONObject(); // {}  ==> {} 라는 객체 생성 => 즉, JSONObject 객체생성  => *jsonview.jsp 파일과 연결됨.
			jsonObj.put("isExists", isExists);  // {"isExists":true} 또는 {"isExists":false} 으로 만들어준다. ==> "isExists"(key값) : isExists(value값)
			
			String json = jsonObj.toString();   // 웹페이지에 보여주기 위해 문자열 형태인 "{"isExists":true}" 또는 "{"isExists":false}" 으로 만들어준다.
			//	System.out.println(">> 확인용 json => " + json);
			// >> 확인용 json => {"isExists":true}
			// >> 확인용 json => {"isExists":false}
			
			request.setAttribute("json", json);
			
			//  super.setRedirect(false);  
			super.setViewPage("/WEB-INF/jsonview.jsp");
			
		}
		
	}

}
