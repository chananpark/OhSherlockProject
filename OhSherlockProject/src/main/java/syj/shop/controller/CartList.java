package syj.shop.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.CartVO;
import common.model.MemberVO;
import syj.shop.model.InterProductDAO;
import syj.shop.model.ProductDAO;

public class CartList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 장바구니 보기는 반드시 해당 사용자가 로그인을 해야만 볼 수 있다.
		boolean isLogin = super.checkLogin(request);
		
		if(!isLogin) { // 로그인이 되어져 있지 않다면
			
			request.setAttribute("message", "장바구니는 로그인 후 이용 가능합니다.");
			request.setAttribute("loc", request.getContextPath() + "/login/login.tea");
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
			
			return;
		} else { // 로그인 되어진 상태
			
			// *** 장바구니 목록보기는 페이징 처리를 안한다 *** //
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			InterProductDAO pdao = new ProductDAO();
			
			// 로그인한 사용자의 장바구니 목록을 조회하기 
	//		List<CartVO> cartList = pdao.selectProductCart(loginuser.getUserid()); 
			// 로그인한 사용자의 장바구니에 담긴 주문 총액 합계 및 총 포인트 합계
	//		HashMap<String,String> sumMap= pdao.selectCartSumPricePoint(loginuser.getUserid());
			
	//		request.setAttribute("cartList", cartList);
	//		request.setAttribute("sumMap", sumMap);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/cart/cart.jsp");
			
		}
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
