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
			
			String odrcode = request.getParameter("odrcode");
			// System.out.println(odrcode);
			paraMap.put("loginuser", loginuser.getUserid());
			paraMap.put("odrcode", odrcode);
			
			List<OrderVO> orderList = odao.selectOneOrder(paraMap);
			OrderVO ovo = odao.getOrderDetail(odrcode);
			
			request.setAttribute("odrcode", odrcode);
			request.setAttribute("orderList", orderList);
			request.setAttribute("ovo", ovo);
			
			//  *** 현재 페이지를 돌아갈 페이지(goBackURL)로 주소 지정하기 *** //
			String goBackURL = request.getParameter("goBackURL");
	//		System.out.println("확인용 : " + goBackURL); 
			
			request.setAttribute("goBackURL", goBackURL); // 공백이 있는 상태 그대로 전달해준다.
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/orderCheck/orderCheck_detail.jsp");
		}
	}

}
