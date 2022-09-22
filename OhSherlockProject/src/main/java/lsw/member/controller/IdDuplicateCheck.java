package lsw.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import lsw.member.model.InterMemberDAO;
import lsw.member.model.MemberDAO;

public class IdDuplicateCheck extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod(); // "GET" 또는 "POST"
		
		if("POST".equalsIgnoreCase(method)) {
		
			String userid = request.getParameter("userid");
			
			InterMemberDAO mdao = new MemberDAO();
			boolean isExists = mdao.idDuplicateCheck(userid); 
			
			JSONObject jsonObj = new JSONObject(); //  {}
			jsonObj.put("isExists", isExists); // {"isExists":true} 또는 {"isExists":false} 으로 만들어준다.
			
			String json = jsonObj.toString(); // 문자열 형태인 "{"isExists":true}" 또는 "{"isExists":false}" 으로 만들어준다.
			
			request.setAttribute("json", json);
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp");
		}
	}
		
}
