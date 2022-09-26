package kcy.mypage.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class CoinPurchaseEnd extends AbstractController { 

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 아임포트 결제창을 사용하기 위한 전제조건은 먼저 로그인을 해야 하는 것이다.
				if( super.checkLogin(request) ) {
					// 로그인을 했으면
					
					String userid = request.getParameter("userid");
					
					HttpSession session = request.getSession();
					MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
					
					if( loginuser.getUserid().equals(userid) ) {
						// 로그인한 사용자가 자신의 코인을 결제하는 경우 
						
						String productName = "코인충전"; //"새우깡";
						String coinmoney = request.getParameter("coinmoney");
										
						request.setAttribute("productName", productName);
						request.setAttribute("coinmoney", coinmoney);
						request.setAttribute("email", loginuser.getEmail());
						request.setAttribute("name", loginuser.getName());
						request.setAttribute("mobile", loginuser.getMobile());
						
						request.setAttribute("userid", userid);
										
					//	super.setRedirect(false);
						super.setViewPage("/WEB-INF/mypage/paymentGateway.jsp");
					}
					else {
						// 로그인한 사용자가 다른 사용자의 코인을 충전하려고 시도하는 경우 
						String message = "다른 사용자의 코인충전 결제 시도는 불가합니다.!!";
						String loc = "javascript:history.back()";
						
						request.setAttribute("message", message);
						request.setAttribute("loc", loc);
						
					//	super.setRedirect(false);
						super.setViewPage("/WEB-INF/msg.jsp");
						return;
					}
					
					
					
				}
				else {
					// 로그인을 안 했으면
					String message = "코인충전 결제를 하기 위해서는 먼저 로그인을 하세요!!";
					String loc = "javascript:history.back()";
					
					request.setAttribute("message", message);
					request.setAttribute("loc", loc);
					
				//	super.setRedirect(false);
					super.setViewPage("/WEB-INF/msg.jsp");
					return; 
				}
	
	
	
	}
	
	
}
