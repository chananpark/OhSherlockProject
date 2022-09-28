package lye.member.controller;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.MemberVO;
import lye.member.model.*;

public class MemberWithdrawal extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();

		if ("get".equalsIgnoreCase(method)) {  // get 방식의 경우
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/member/member_withdrawal.jsp"); // 회원탈퇴 페이지로 이동
		}
		else {  // post 방식의 경우

			String userid = request.getParameter("userid");
			
			InterMemberDAO mdao = new MemberDAO();
			
			try {
				int n = mdao.deleteMember(userid);
				
				if(n==1) {  // DB 에 정상적으로 insert 됐다면,
					
				//	super.setRedirect(false);
					super.setViewPage("/WEB-INF/member/memberWithdrawal_success.jsp");
				}
				
			} catch(SQLException e) {
				e.printStackTrace();
				super.setRedirect(true);   // sendRedirect 방식
			    super.setViewPage(request.getContextPath()+"/error.up");  // 페이지 URL 주소(/error.up)로 이동함.
			}
			
		}
		
	}

}
