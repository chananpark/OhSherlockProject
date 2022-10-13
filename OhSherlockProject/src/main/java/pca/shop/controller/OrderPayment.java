package pca.shop.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.OrderDetailVO;
import common.model.ProductVO;

public class OrderPayment extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		// get방식이거나 로그인하지 않았을때
		if(!"POST".equalsIgnoreCase(method) || loginuser == null) {
			String message = "비정상적인 접근입니다.";
	        String loc = "javascript:history.back()";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
		} 
		// post방식이고 로그인했을때
		else {
			
			Map<String, Object> paraMap = new HashMap<>();

			// 상품번호
			String pnumjoin = request.getParameter("pnumjoin");
			// 상품번호
			String pnamejoin = request.getParameter("pnamejoin");
			// 상품 구매수량
			String oqtyjoin = request.getParameter("oqtyjoin");
			// 상품 이미지
			String imagejoin = request.getParameter("imagejoin");
			// 상품 구매금액
			String totalPricejoin = request.getParameter("totalPricejoin");
			
			String[] pnumArr = pnumjoin.split("\\,"); 
			
			String[] pnameArr = pnamejoin.split("\\,"); 
			
			String[] oqtyArr = oqtyjoin.split("\\,");
			
			String[] imageArr = imagejoin.split("\\,");
			
			String[] totalPriceArr = totalPricejoin.split("\\,");
			
			List<OrderDetailVO> odList = new ArrayList<>();
			
			for(int i = 0; i < pnumArr.length; i++) {
				
				OrderDetailVO odvo = new OrderDetailVO();
				
				ProductVO pvo = new ProductVO();
				pvo.setPimage(imageArr[i]);
				pvo.setPname(pnameArr[i]);
				odvo.setPvo(pvo);
				
				odvo.setFk_pnum(Integer.parseInt(pnumArr[i]));
				odvo.setOqty(Integer.parseInt(oqtyArr[i]));
				odvo.setOprice(Integer.parseInt(totalPriceArr[i]));
				
				odList.add(odvo);
				
			}
			
			
			// 장바구니 번호 목록
			String cartnojoin = request.getParameter("cartnojoin");
			
			// 총 구매 정가
			int sumtotalOriginalPrice = Integer.parseInt(request.getParameter("sumtotalOriginalPrice"));
			
			// 총 구매금액
			int sumtotalPrice = Integer.parseInt(request.getParameter("sumtotalPrice"));
			
			// 배송비
			int delivery_cost = 0;
			if(sumtotalPrice < 30000) {
				delivery_cost = 2500;
			}
			
			// 배송비 포함 총 결제금액
			int totalPaymentAmount = sumtotalPrice + delivery_cost;
			
			// 총 할인금액
			int saleAmount = sumtotalOriginalPrice - sumtotalPrice;
					
			request.setAttribute("odList", odList);
			request.setAttribute("pnumjoin", pnumjoin);
			request.setAttribute("pnamejoin", pnamejoin);
			request.setAttribute("oqtyjoin", oqtyjoin);
			request.setAttribute("totalPricejoin", totalPricejoin);
			request.setAttribute("cartnojoin", cartnojoin);
			request.setAttribute("saleAmount", saleAmount);
			request.setAttribute("delivery_cost", delivery_cost);
			request.setAttribute("sumtotalPrice", sumtotalPrice);
			request.setAttribute("totalPaymentAmount", totalPaymentAmount);
	
			// 주문 결제 화면 이동
			super.setViewPage("/WEB-INF/product/payment.jsp");
		}
	}

}
