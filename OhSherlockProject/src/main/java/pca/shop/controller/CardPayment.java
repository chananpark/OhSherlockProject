package pca.shop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;

public class CardPayment extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		if (super.checkLogin(request)) {
			// 로그인을 했으면

			HttpSession session = request.getSession(); MemberVO loginUser = (MemberVO)
					session.getAttribute("loginUser");
			
			String pnamejoin = request.getParameter("pnamejoin");
			int sumtotalPrice = Integer.parseInt(request.getParameter("sumtotalPrice"));

			 int index = pnamejoin.indexOf(",");
			 String productName = pnamejoin.substring(0, index);
			 System.out.println(productName);
			 System.out.println(sumtotalPrice);
			 
			 request.setAttribute("productName", productName);
			 request.setAttribute("sumtotalPrice", sumtotalPrice);
			 
			 request.setAttribute("email", loginUser.getEmail()); 
			 request.setAttribute("name", loginUser.getName());
			 request.setAttribute("mobile", loginUser.getMobile());
			 super.setViewPage("/WEB-INF/member/paymentGateway.jsp");
			 
			// 아임포트 결제창 띄우기
		} else {
			String message = "잘못된 접근입니다.";
			String loc = request.getContextPath() + "/index.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			// super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
			return;
		}

	}
}