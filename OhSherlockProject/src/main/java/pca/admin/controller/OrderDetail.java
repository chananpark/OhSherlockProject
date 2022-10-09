package pca.admin.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.OrderDetailVO;
import common.model.OrderVO;
import pca.shop.model.InterOrderDAO;
import pca.shop.model.OrderDAO;

public class OrderDetail extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		boolean isLogined = checkLogin(request);
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

		// 관리자만 접근 가능
		if (isLogined && loginuser.getUserid().equals("admin")) {
			// 주문번호
			String odrcode = request.getParameter("odrcode");
			
			InterOrderDAO idao = new OrderDAO();
			OrderVO ovo = idao.getOrderDetail(odrcode);
			List<OrderDetailVO> orderPrdList = idao.getOrderPrdDetail(odrcode);
			
			int refundSum = 0;
			for(OrderDetailVO odvo : orderPrdList) {
				if (odvo.getRefund() == 1) {
					refundSum += odvo.getOprice();
				}
			}
			
			request.setAttribute("ovo", ovo);
			request.setAttribute("orderPrdList", orderPrdList);
			request.setAttribute("refundSum", refundSum);
			
			String goBackURL = request.getParameter("goBackURL");
			request.setAttribute("goBackURL", goBackURL);

			super.setViewPage("/WEB-INF/admin/order_detail_admin.jsp");
		}
		// 로그인 안 되었거나 일반사용자인 경우
		else {
			String message = "관리자만 접근 가능한 메뉴입니다.";
			String loc = request.getContextPath() + "/index.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
