package lsw.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.OrderVO;
import lsw.mypage.model.InterOrderDAO;
import lsw.mypage.model.OrderDAO;

public class OrderCheck_detail extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		boolean isLogin = super.checkLogin(request);

		if(!isLogin) { // 로그인을 하지 않은 상태라면
			
			request.setAttribute("message", "먼저 로그인 하셔야 합니다.");
			request.setAttribute("loc", "javascript:history.back()");
			
			// super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
			
			return;
		}
		else {
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			// 자기 목록만 조회가능하게 해야함
			InterOrderDAO odao = new OrderDAO();
			Map<String, String> paraMap = new HashMap<>();
			
			String ordcode = request.getParameter("ordcode");
			paraMap.put("loginuser", loginuser.getUserid());
			paraMap.put("ordcode", ordcode);
			
			List<OrderVO> orderList = odao.selectMyOrderDetail(paraMap);
			
			request.setAttribute("orderList", orderList);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/orderCheck/orderCheck_detail.jsp");
		}
	}

}
