package lsw.mypage.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
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
import my.util.MyUtil;

public class OrderCheck_refundCancelList extends AbstractController {

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
			
			// 자기 목록만 조회가능하게 
			InterOrderDAO odao = new OrderDAO();
			Map<String, String> paraMap = new HashMap<>();
			
			paraMap.put("loginuser", loginuser.getUserid());
			
			Calendar calendar = Calendar.getInstance();
			SimpleDateFormat sdmt = new SimpleDateFormat("yyyy-MM-dd");
			
			String endDate = request.getParameter("endDate");
			if(endDate == null) {
				endDate = sdmt.format(calendar.getTime());
			}
			
			String startDate = request.getParameter("startDate");
			if(startDate == null) {
				calendar.add(Calendar.MONTH, -1); //한달 전
				startDate = sdmt.format(calendar.getTime());
			}
			
			// System.out.println(endDate);
			// System.out.println(startDate);
			
			paraMap.put("startDate", startDate);
			paraMap.put("endDate", endDate);
			
			String currentShowPageNo = request.getParameter("currentShowPageNo");
			
			if(currentShowPageNo == null) {
				currentShowPageNo = "1";
			}
			
			try {
				if(Integer.parseInt(currentShowPageNo) < 1) {
					currentShowPageNo = "1"; 
				}
			} catch (NumberFormatException e) {
				currentShowPageNo = "1"; 
			}
			
			paraMap.put("currentShowPageNo", currentShowPageNo); 
			
			int totalPage = odao.getTotalMyOrderPage(paraMap); 
			
			if( Integer.parseInt(currentShowPageNo) > totalPage ) {
				currentShowPageNo = "1"; 
				paraMap.put("currentShowPageNo", currentShowPageNo);
			}
			
			List<OrderVO> orderList = odao.selectMyRCOrder(paraMap);
			
			request.setAttribute("orderList", orderList);
			
			// *** 페이지바 만들기 시작 *** //
			
			String pageBar = "";
			
			int blockSize = 5; 
			
			int loop = 1;
			
			int pageNo = ( (Integer.parseInt(currentShowPageNo)- 1) / blockSize ) * blockSize + 1; 
			
			// ***** 맨처음/이전 만들기 ***** //
			if( pageNo != 1 ) {  
				pageBar += "<li class='page-item'><a class='page-link' href='orderCheck.tea?currentShowPageNo=1'><<</a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='orderCheck.tea?currentShowPageNo="+(pageNo-1)+"'><</a></li>";
			} 
			
			while( !(loop > blockSize || pageNo > totalPage) ) { 
				
				if( pageNo == Integer.parseInt(currentShowPageNo) ) { 
					pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; 
					
				} else {
					pageBar += "<li class='page-item'><a class='page-link' href='orderCheck.tea?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
				}
				
				loop++;  
				
				pageNo++; 
				
			} // end of while( loop > blockSize )
			
			// ***** 다음/마지막 만들기 ***** //
			if( pageNo <= totalPage ) {  
				pageBar += "<li class='page-item'><a class='page-link' href='orderCheck.tea?currentShowPageNo="+pageNo+"'>></a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='orderCheck.tea?currentShowPageNo="+totalPage+"'>>></a></li>";
			}
			
			request.setAttribute("pageBar", pageBar);
			
			// *** 페이지바 만들기 끝 *** //
			
			String currentURL = MyUtil.getCurrentURL(request);
					
			currentURL = currentURL.replaceAll("&", " "); // & 를 공백으로 바꾸어라.

			request.setAttribute("goBackURL", currentURL);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/orderCheck/orderCheck_refundCancelList.jsp");
		}
	}

}
