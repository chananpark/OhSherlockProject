package syj.member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import syj.member.model.InterMemberDAO;
import syj.member.model.MemberDAO;

public class PasswdFind_update extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 인증이 성공했을 경우에만 이렇게 들어온다.
		String userid = request.getParameter("userid");
		// 비밀번호를 갱신할 때 누구인지 알아야하기 때문에 여기로 유저 아이디를 넘긴다.

		String method = request.getMethod(); // get 또는 post
		
		if("POST".equalsIgnoreCase(method)) {
			// 암호 변경하기 버튼을 누른 경우
		
			String passwd = request.getParameter("passwd");
			
			Map<String,String> paraMap = new HashMap<>();
			paraMap.put("passwd", passwd);
			paraMap.put("userid", userid);
			
			InterMemberDAO mdao = new MemberDAO();
			int n = mdao.passwdUpdate(paraMap);
			
			request.setAttribute("n", n); // 1 이 나와야만 업데이트가 완료된 것이다.
		}
		
		// 여기는 포스트든 겟이든 모두 한다.
		request.setAttribute("userid", userid); // userid도 뷰단으로 넘겨준다.
		request.setAttribute("method", method); // 뷰단으로 넘어갈 때 get인지 post 인지
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/login/passwdFind_update.jsp");
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
