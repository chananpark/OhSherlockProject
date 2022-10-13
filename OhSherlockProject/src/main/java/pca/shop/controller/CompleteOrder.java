package pca.shop.controller;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.ProductVO;
import pca.member.controller.GoogleMail;
import pca.shop.model.InterOrderDAO;
import pca.shop.model.InterProductDAO;
import pca.shop.model.OrderDAO;
import pca.shop.model.ProductDAO;

public class CompleteOrder extends AbstractController {
	
	private String getOdrcode() throws SQLException{
		// 날짜 생성
		Date now = new Date();
		SimpleDateFormat smdatefm = new SimpleDateFormat("yyyyMMdd"); 
	    String today = smdatefm.format(now);
	    
	    InterOrderDAO pdao = new OrderDAO();
	    int seq = pdao.getSeq_tbl_order();
	    
	    return "O"+today+"-"+seq;
	}

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String recipient_name = request.getParameter("recipient_name");
		String recipient_mobile = request.getParameter("recipient_mobile");
		String recipient_postcode = request.getParameter("recipient_postcode");
		String recipient_address = request.getParameter("recipient_address");
		String recipient_extra_address = request.getParameter("recipient_extra_address");
		String recipient_detail_address = request.getParameter("recipient_detail_address");
		String recipient_memo = request.getParameter("recipient_memo");
		if(recipient_memo != null && !recipient_memo.trim().isEmpty()) {
			recipient_memo = recipient_memo.replaceAll("<", "&lt");
			recipient_memo = recipient_memo.replaceAll(">", "&gt");
		}
		
		// 구매하는 물건의 pnum들
		String pnumjoin = request.getParameter("pnumjoin");
		// 물건각각의 구매량
		String oqtyjoin = request.getParameter("oqtyjoin");
		// 배송비
		String delivery_cost = request.getParameter("delivery_cost");
		// 물건 각각의 구매금액
		String totalPricejoin = request.getParameter("totalPricejoin");
		// 총 물건 금액
		String sumtotalPrice = request.getParameter("sumtotalPrice");
		// 총 실제 결제 금액
		String totalPaymentAmount = request.getParameter("totalPaymentAmount");
		// 장바구니 번호들
		String cartnojoin = request.getParameter("cartnojoin");
		
		// 결제시 사용된 적립금
		String odrusedpoint = request.getParameter("odrusedpoint");
		// 결제방법
		String paymentMethod = request.getParameter("paymentMethod");
		
		// 주문으로인해 적립되는 적립금
		int odrtotalpoint = 0;
		// 적립금을 사용하여 주문하지 않았으면 1% 적립
		if(Integer.parseInt(odrusedpoint) == 0) {
			odrtotalpoint = Integer.parseInt(sumtotalPrice)/100;
		}
		
		Map<String, Object> paraMap = new HashMap<>();
		
		String[] pnumArr = pnumjoin.split("\\,"); 
		
		String[] oqtyArr = oqtyjoin.split("\\,");
		
		String[] totalPriceArr = totalPricejoin.split("\\,");
		
		// 주문코드 생성 메소드 호출
		String odrcode = getOdrcode();
		// 주문코드 형식: O+날짜+sequence
		
		// 주문 테이블 insert
		paraMap.put("odrcode", odrcode);
		paraMap.put("userid", loginuser.getUserid());
		paraMap.put("recipient_name", recipient_name);
		paraMap.put("recipient_mobile", recipient_mobile);
		paraMap.put("recipient_postcode", recipient_postcode);
		paraMap.put("recipient_address", recipient_address);
		paraMap.put("recipient_extra_address", recipient_extra_address);
		paraMap.put("recipient_detail_address", recipient_detail_address);
		paraMap.put("sumtotalPrice", sumtotalPrice);
		paraMap.put("delivery_cost", delivery_cost);
		paraMap.put("odrusedpoint", odrusedpoint);
		paraMap.put("odrtotalpoint", odrtotalpoint);
		paraMap.put("recipient_memo", recipient_memo);

		// 주문상세 테이블에 insert
		paraMap.put("pnumArr", pnumArr);
		paraMap.put("oqtyArr", oqtyArr);
		paraMap.put("totalPriceArr", totalPriceArr);

		// 장바구니 테이블에 delete시 필요한 것
		paraMap.put("cartnojoin", cartnojoin);
		// 바로주문하기 한 경우라면 cartnojoin 의 값은 null임
		
		// 예치금 사용했으면 tbl_member 예치금 update, 예치금 내역 insert
		paraMap.put("paymentMethod", paymentMethod);
		paraMap.put("totalPaymentAmount", totalPaymentAmount);

		// 주문하기 트랜잭션 메소드 실행
		InterOrderDAO odao = new OrderDAO();
		int nSuccess = odao.completeOrder(paraMap);
		
		if(nSuccess == 1) {
			
			// 이메일 발송하기
			GoogleMail mail = new GoogleMail();
			InterProductDAO pdao = new ProductDAO();
			List<ProductVO> jumunProductList = pdao.getJumunProductList(pnumjoin);
			// 주문한 제품에 대해 email을 보내기시 email 내용에 넣을 주문한 제품번호들에 대한 제품정보를 얻어오는것
			
			StringBuilder sb = new StringBuilder();
			sb.append("주문코드번호 : <span style='color:blue; font-weight:bold;'>"+odrcode+"</span><br><br>");
			sb.append("<주문상품><br>");
			
			for(int i = 0; i < jumunProductList.size(); i++) {
				sb.append(jumunProductList.get(i).getPname()+"&nbsp;"+oqtyArr[i]+"개&nbsp;&nbsp;");
				sb.append("<img src='http://127.0.0.1:9090/OhSherlockProject/images/"+jumunProductList.get(i).getPimage()+"'/>");
			}
			
			sb.append("<br>이용해주셔서 감사합니다.");
			
			String emailContents = sb.toString();
			
			mail.sendmail_OrderFinish(loginuser.getEmail(), loginuser.getName(), emailContents);
			
			// session loginuser정보 update
			if(paymentMethod.equals("coin")) {
				loginuser.setCoin(loginuser.getCoin() - Integer.parseInt(totalPaymentAmount)); // 코인빼기
			}
			// 결제시 포인트 사용하였으면
			if(Integer.parseInt(odrusedpoint) > 0) {
				
				loginuser.setPoint(loginuser.getPoint() - Integer.parseInt(odrusedpoint)); // 포인트빼기
			}else {
				loginuser.setPoint(loginuser.getPoint() + Integer.parseInt(sumtotalPrice)/100); // 포인트더하기
			}
			
			
			String message = "주문이 완료되었습니다.";
			String loc = request.getContextPath() + "/mypage/mypage.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}else {
			String message = "주문 실패";
			String loc = request.getContextPath() + "/cart/cart.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
			
		}
		
	}

}
