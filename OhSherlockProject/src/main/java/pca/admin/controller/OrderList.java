package pca.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.OrderVO;
import pca.shop.model.InterOrderDAO;
import pca.shop.model.OrderDAO;

public class OrderList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		
		boolean isLogined = checkLogin(request);
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String message;
		String loc;
		
		// 관리자만 들어올 수 있음
		if(isLogined && loginuser.getUserid().equals("admin")) {
			
			InterOrderDAO idao = new OrderDAO();
			Map<String, String> paraMap = new HashMap<>();

			// 배송상태
			String odrstatus = "1"; 
			
			// odrstatus가 null이 아니고 공백도 아니라면
			if(request.getParameter("odrstatus") != null && !request.getParameter("odrstatus").trim().isEmpty()) {
				odrstatus = request.getParameter("odrstatus");
			}
			
			// 검색어
			String searchType = request.getParameter("searchType");
			String searchWord = request.getParameter("searchWord");
			
			if (searchType == null) {
				searchType = "";
			}
			
			if (searchWord == null) {
				searchWord = "";
			}
			
			// 한 페이지당 보여줄 행 수
			String sizePerPage = request.getParameter("sizePerPage");
			if (sizePerPage == null || !("10".equals(sizePerPage) || "30".equals(sizePerPage) || "50".equals(sizePerPage))) {
				sizePerPage = "10";
			}
			
			// 현재 페이지 번호
			String currentShowPageNo = request.getParameter("currentShowPageNo");
			
			if (currentShowPageNo == null) {
				currentShowPageNo = "1";
			}
			
			try {
				if (Integer.parseInt(currentShowPageNo) < 1) {
					currentShowPageNo = "1";
				}

			} catch (NumberFormatException e) {
				currentShowPageNo = "1";
			}

			paraMap.put("odrstatus", odrstatus);
			paraMap.put("sizePerPage", sizePerPage);
			paraMap.put("searchType", searchType);
			paraMap.put("searchWord", searchWord);
			paraMap.put("currentShowPageNo", currentShowPageNo);
			
			// 토탈 페이지 수
			int totalPage = idao.getTotalPage(paraMap);
			
			// currentShowPageNo에 totalPage보다 큰 값을 입력한 경우 1페이지로 가게함
			if (Integer.parseInt(currentShowPageNo) > totalPage) {
				currentShowPageNo = "1";
				paraMap.put("currentShowPageNo", currentShowPageNo);
			}
			
			// 주문 목록 select
			List<OrderVO> orderList = idao.showOrderList(paraMap);
			
			
			// 페이지바
			String pageBar = "";

			int blockSize = 5;
			// blockSize 블럭(토막)당 보여지는 페이지 번호의 개수이다.

			int loop = 1;
			// loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.

			// pageNo 구하는 공식
			int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

			// 맨 첫 페이지와 이전 페이지 버튼
			if (pageNo > 1) {
				pageBar += "<li class='page-item'><a class='page-link' href='orderList.tea?sizePerPage=" + sizePerPage + "&currentShowPageNo=1&searchType="+searchType+"&searchWord="+searchWord+"&odrstatus="+odrstatus+"'><<</a></li>";				
				pageBar += "<li class='page-item'><a class='page-link' href='orderList.tea?sizePerPage=" + sizePerPage + "&currentShowPageNo=" + (pageNo - 1) + "&searchType="+searchType+"&searchWord="+searchWord+"&odrstatus="+odrstatus+"'><</a></li>";
			}
			
			// 페이지바
			while( !(loop > blockSize || pageNo > totalPage) ) {
				
				if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
					// 선택한 페이지에 active 클래스
					pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
				} else {
					pageBar += "<li class='page-item'><a class='page-link' href='orderList.tea?sizePerPage=" + sizePerPage + "&currentShowPageNo="+pageNo+"&searchType="+searchType+"&searchWord="+searchWord+"&odrstatus="+odrstatus+"'>"+pageNo+"</a></li>";
				}
				
				loop++;
				pageNo++;
				
			} 
			
			// 다음 페이지와 맨 마지막 페이지 버튼
			if( pageNo <= totalPage ) { 
				pageBar += "<li class='page-item'><a class='page-link' href='orderList.tea?sizePerPage=" + sizePerPage + "&currentShowPageNo="+pageNo+"&searchType="+searchType+"&searchWord="+searchWord+"&odrstatus="+odrstatus+"'>></a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='orderList.tea?sizePerPage=" + sizePerPage + "&currentShowPageNo="+totalPage+"&searchType="+searchType+"&searchWord="+searchWord+"&odrstatus="+odrstatus+"'>>></a></li>";
			}
			
			request.setAttribute("pageBar", pageBar);
			request.setAttribute("odrstatus", odrstatus);
			request.setAttribute("sizePerPage", sizePerPage);
			request.setAttribute("searchType", searchType);
			request.setAttribute("searchWord", searchWord);
			request.setAttribute("orderList", orderList);
			
			super.setViewPage("/WEB-INF/admin/order_list_admin.jsp");
		
		} 
		// 로그인 안 되었거나 일반사용자인 경우
		else {
			message = "관리자만 접근 가능한 메뉴입니다.";
			loc = request.getContextPath() + "/index.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
