package lye.mypage.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.InquiryVO;
import common.model.MemberVO;
import common.model.OrderVO;
import syj.cs.model.InquiryDAO;
import syj.cs.model.InterInquiryDAO;
import syj.shop.model.InterOrderDAO;
import syj.shop.model.OrderDAO;

public class Mypage extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		
		// 마이페이지 접속 전제조건은 먼저 로그인을 해야 한다.
		if( super.checkLogin(request) ) { 
			// 로그인을 했으면
			
			HttpSession session =  request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			String userid = loginuser.getUserid();
			
			InterInquiryDAO idao = new InquiryDAO();
			InterOrderDAO odao = new OrderDAO();

			List<InquiryVO> inquiryList = idao.mypageInquiryList(userid);
			List<OrderVO> orderList = odao.mypageOrderList(userid);
			
			request.setAttribute("inquiryList", inquiryList);
			request.setAttribute("orderList", orderList);
			
           	super.setRedirect(false); 		
			super.setViewPage("/WEB-INF/mypage/mypage.jsp"); // 마이페이지로 이동  
			
		}
		else {
			// 로그인을 안 했으면   => 로그인없이 예전 본인 로그인시 마이페이지에 접속했던 url 을 복붙한경우(get방식)
			
			String message ="로그인 후 접속가능합니다.";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
		    //	super.setRedirect(false); 
			super.setViewPage("/WEB-INF/msg.jsp");
	
		}
	}

}
