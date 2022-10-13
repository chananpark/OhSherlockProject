package lsw.mypage.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.OrderVO;
import lsw.mypage.model.InterOrderDAO;
import lsw.mypage.model.OrderDAO;

public class OrderCheckJson extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

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
		
		List<OrderVO> orderList = odao.selectMyOrder(paraMap);
		
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
		
		
		// json객체 배열로 넘긴다.
		JSONArray jsonArr = new JSONArray();
		JSONObject jsonObj = new JSONObject();
		if (orderList.size() > 0) {
			for (OrderVO ovo : orderList) {
				jsonObj = new JSONObject();
				jsonObj.put("fk_userid", ovo.getFk_userid());
				jsonObj.put("odrdate", ovo.getOdrdate());
				jsonObj.put("odrcode", ovo.getOdrcode());
				jsonObj.put("odnum", ovo.getOdvo().getOdnum());
				jsonObj.put("fk_pnum", ovo.getOdvo().getFk_pnum());
				jsonObj.put("oqty", ovo.getOdvo().getOqty());
				jsonObj.put("oprice", ovo.getOdvo().getOprice());
				jsonObj.put("pname", ovo.getOdvo().getPvo().getPname());
				jsonObj.put("pimage", ovo.getOdvo().getPvo().getPimage());
				jsonObj.put("odrstatus", ovo.getOdrstatus());
				
				jsonArr.put(jsonObj);
			}
		}
		jsonObj.put("pageBar", pageBar);
		
		String json = jsonArr.toString();
		request.setAttribute("json", json);
		super.setViewPage("/WEB-INF/jsonview.jsp");

	}

}
