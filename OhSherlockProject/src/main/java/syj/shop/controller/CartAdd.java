package syj.shop.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.LikeVO;
import common.model.MemberVO;
import syj.shop.model.InterProductDAO;
import syj.shop.model.ProductDAO;

public class CartAdd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// == 로그인 유무 검사하기 == //
		boolean isLogin = super.checkLogin(request);
		
		if(!isLogin) { // 로그인이 되어져 있지 않다면
			
			request.setAttribute("message", "장바구니는 로그인 후 이용 가능합니다.");
			request.setAttribute("loc", request.getContextPath() + "/login/login.tea");
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
			
		} else { // 로그인이 되어진 상태
			
			// 장바구니 테이블(tbl_cart)에 해당 제품을 담아야 한다.
	        // 장바구니 테이블에 해당 제품이 존재하지 않는 경우에는 tbl_cart 테이블에 insert 를 해야하고, 
	        // 장바구니 테이블에 해당 제품이 존재하는 경우에는 또 그 제품을 추가해서 장바구니 담기를 한다라면 tbl_cart 테이블에 update 를 해야한다.
			
			String method = request.getMethod();
			
			if("POST".equalsIgnoreCase(method)) {
				// post 방식이라면
				String pnum = request.getParameter("pnum");
				String oqty = request.getParameter("oqty"); // 주문량
				
				// 상품 목록에서 넘겨준 경우
				//System.out.println("확인용 pnum => "+ pnum);
				
				// 상품목록에서 넘겨준 경우
				if(oqty == null) {
					oqty = "1";
				}
				//System.out.println("확인용 oqty => "+ oqty);
				
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
				
				InterProductDAO pdao = new ProductDAO();
				
				// 장바구니에 추가하기
				int n = pdao.addCart(loginuser.getUserid(), pnum, oqty);
				
				if( n == 1 ) {
					// 장바구니에 insert/update 가 정상적으로 되었을 경우
					
					String likeno = request.getParameter("likeno");
					if(likeno != null) {
						
						// 찜목록 테이블에서 장바구니 담기 성공시 특정제품 1개행을 찜목록에서 비우기(예은)
						n = pdao.delLiketoCart(likeno);  // 성공시 n==1
						
						request.setAttribute("message", "장바구니에 상품을 담았습니다. 장바구니로 이동하시겠습니까?");
						request.setAttribute("loc", request.getContextPath() + "/cart/cart.tea");
						// 장바구니 목록 보여주기 페이지로 이동
						
						super.setRedirect(false);
						super.setViewPage("/WEB-INF/msg_confirm_likeList.jsp");
					}
					else {
						request.setAttribute("message", "장바구니에 상품을 담았습니다. 장바구니로 이동하시겠습니까?");
						request.setAttribute("loc", request.getContextPath() + "/cart/cart.tea");
						// 장바구니 목록 보여주기 페이지로 이동
						
						super.setRedirect(false);
						super.setViewPage("/WEB-INF/msg_confirm.jsp");
					}
					
					
				} else {
					request.setAttribute("message", "장바구니에 상품 담기를 실패하였습니다.");
					request.setAttribute("loc", "javascript:history.back()");
					
					super.setRedirect(false);
					super.setViewPage("/WEB-INF/msg_confirm.jsp");
				}
				
				
			} else {
				// get 방식이라면
				String message = "비정상적인 접근입니다.";
		        String loc = "javascript:history.back()";
		        
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		        
		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
				
			} // end of if-else get-post
			
		} // end of if(!isLogin) - else 
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
