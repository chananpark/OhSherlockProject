package lye.member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import lye.member.model.InterMemberDAO;
import lye.member.model.MemberDAO;

public class MemberEditEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod(); // "GET" 또는 "POST"
		
		if("POST".equalsIgnoreCase(method)) {
			
			String userid = request.getParameter("userid"); 
			String passwd = request.getParameter("passwd"); 
			String name = request.getParameter("name");    // memberRegister.jsp 파일의 html 에서 성명의 name 값을 받아옴.
			String postcode = request.getParameter("postcode");
			String address = request.getParameter("address"); 
			String detail_address = request.getParameter("detail_address"); 
			String extra_address = request.getParameter("extra_address"); 
			String birthyyyy = request.getParameter("birthyyyy"); 
			String birthmm = request.getParameter("birthmm"); 
			String birthdd = request.getParameter("birthdd"); 
	        String hp1 = request.getParameter("hp1"); 
	        String hp2 = request.getParameter("hp2"); 
	        String hp3 = request.getParameter("hp3"); 
	        String email = request.getParameter("email"); 
	        
			
	        String mobile =  hp1 + hp2 + hp3;                          // 쪼개져있는 연락처의 값을 합쳐서 DB 에서의 컬럼 mobile에 넣어준다. 
	        String birthday = birthyyyy+"-"+birthmm+"-"+birthdd;       // 쪼개져있는 생일의 값을 합쳐서 DB 에서의 컬럼 birthday에 넣어준다.
	        
        	MemberVO member = new MemberVO(userid, passwd, name, postcode, address, detail_address, extra_address, birthday, mobile, email); 
        	System.out.println("==================확인용" + member.toString());
			
			InterMemberDAO mdao = new MemberDAO();  //  MemberDAO 의 기본생성자
	        int n = mdao.updateMember(member);
	        
	        String message = "";
	        
	        if(n == 1) {  // update 성공했다면
	        	
	        	// !!! session 에 저장된 loginuser 를 변경된 사용자의 정보값으로 변경해주어야 한다 !!! //  재로그인없이도 바로 변경된 회원정보 update 반영될 수 있도록 세션값도 update 된 값으로 바꿈.
	        	HttpSession sesseion = request.getSession();  // 세션 불러오기
	        	MemberVO loginuser = (MemberVO) sesseion.getAttribute("loginuser");
	        	birthday = birthyyyy+birthmm+birthdd; 
	        	
	        	loginuser.setPasswd(passwd);
	        	loginuser.setName(name);
	        	loginuser.setPostcode(postcode);
	        	loginuser.setAddress(address);
	        	loginuser.setDetail_address(detail_address);
	        	loginuser.setExtra_address(extra_address);
	        	loginuser.setBirthday(birthday);
	        	loginuser.setMobile(mobile);
	        	loginuser.setEmail(email);
	        	
	        	message = "회원정보 수정 성공!!";
	        }
	        else {
	        	message = "회원정보 수정 실패!!";
	        }
			
	        
	        String loc = request.getContextPath() + "/mypage/mypage.tea";  // 이전페이지로 이동시킴.
	        
//	        HttpSession session = request.getSession();
//			session.removeAttribute("certificationCode");
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	         
	     // super.setRedirect(false);  
	        super.setViewPage("/WEB-INF/msg.jsp");  
				
			
		}
		else {
			// POST 방식이 아니라면
			
			String message = "비정상적인 경로로 접근했습니다!!";
	        String loc = "javascript:history.back()";
	         
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	         
	     // super.setRedirect(false);  
	        super.setViewPage("/WEB-INF/msg.jsp");
						
		}
		
		
	}

}
