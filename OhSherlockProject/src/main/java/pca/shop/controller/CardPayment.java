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

			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

			String pnamejoin = request.getParameter("pnamejoin");
			int totalOrderPrice = Integer.parseInt(request.getParameter("totalOrderPrice"));

			String productName = pnamejoin; 
			
			int index = pnamejoin.indexOf(",");
			if (index > 0)
				productName = pnamejoin.substring(0, index) + " 외";

			request.setAttribute("productName", productName);
			request.setAttribute("sumtotalPrice", totalOrderPrice);

			request.setAttribute("email", loginuser.getEmail());
			request.setAttribute("name", loginuser.getName());
			request.setAttribute("mobile", loginuser.getMobile());

			super.setViewPage("/WEB-INF/product/paymentGateway.jsp");

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