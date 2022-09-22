package syj.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;

public class VerifyCertification extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String userid = request.getParameter("userid");
	    String userCertificationCode = request.getParameter("userCertificationCode");

		
		// PwdFind 에서 랜덤하게 발생시킨 인증코드를 여기서도 받아와서 입력한 값과 동일한지 확인해야 한다. 
		// 이때의 인증키를 session에 넣어서 저장해주어야 한다.
		// 세션 불러오기
	    HttpSession session = request.getSession();
	    String certificationCode = (String)session.getAttribute("certificationCode"); // certificationCode 은 이메일로 발송한 코드
	    // return 타입은 object 이나 userCertificationCode 이 string 타입이기 때문에 형변환이 필요하다.
		
		
		String message = ""; // msg.jsp의 메시지와 loc 이다.
		String loc = "";

		if(certificationCode.equals(userCertificationCode)) { // 인증코드와 유저가 입력한 값(둘다 문자열)이 같은지에 대해서 확인
			// 입력한 값이 같다면
	        message = "인증성공 되었습니다.";
	        loc = request.getContextPath() + "/login/passwdFind_update.tea?userid=" + userid; // 비밀번호 변경 하러 이동 // userid 까지 포함해서 보내준다.
	        // 비밀번호를 갱신할 때 누구인지 알아야하기 때문에 여기로 유저 아이디를 넘긴다.
	        // msg.jsp 때문에 인증이 성공하면 /login/pwdUpdateEnd.up?userid 여기로 넘어간다. 
	     }
	     else {
	    	// 입력한 값이 같지 않다면 
	        message = "발급된 인증코드가 아닙니다. \\n인증코드를 다시 발급받으세요.";
	        loc = request.getContextPath() + "/login/passwdFind.tea"; // 다시 원래의 비밀번호 찾기 창으로 이동한다.
	    }
		
		
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/msg.jsp");
		
		// !!!!!!!!! 중요 !!!!!!!!!
		// !!! 세션에 저장된 인증코드 삭제하기 !!! 
		session.removeAttribute("certificationCode"); // 세션에 저장되어져 있던 키값을 삭제해준다.
		
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
