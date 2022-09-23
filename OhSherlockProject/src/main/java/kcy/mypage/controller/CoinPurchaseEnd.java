package kcy.mypage.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import kcy.mypage.model.MemberVO;

public class CoinPurchaseEnd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		
						// 로그인한 사용자가 자신의 코인을 결제하는 경우 
						
						String productName = "코인충전"; //"새우깡";
						String coinmoney = request.getParameter("coinmoney");
										
						request.setAttribute("productName", productName);
						request.setAttribute("coinmoney", coinmoney);
					/*	
						request.setAttribute("email", loginuser.getEmail());
						request.setAttribute("name", loginuser.getName());
						request.setAttribute("mobile", loginuser.getMobile());
						
						request.setAttribute("userid", userid); */
										
					//	super.setRedirect(false);
						super.setViewPage("/WEB-INF/mypage/paymentGateway.jsp");
					
		
	}
	
	
	
	
	
	
	
	
	
	

}
