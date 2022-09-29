package pca.mypage.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.InquiryVO;
import common.model.MemberVO;
import my.util.MyUtil;
import pca.cs.model.InquiryDAO;
import pca.cs.model.InterInquiryDAO;

public class InquiryList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		InterInquiryDAO idao = new InquiryDAO();
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if(loginuser == null) {
			String message = "먼저 로그인 하셔야 합니다.";
			String loc = request.getContextPath() + "/login/login.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
		else {
			/*
			 * String userid = loginuser.getUserid(); Map<String, String> paraMap = new
			 * HashMap<>(); paraMap.put("userid", userid);
			 * 
			 * String s_period = "1";
			 * 
			 * if(request.getParameter("period") != null) s_period =
			 * request.getParameter("period");
			 * 
			 * int period = -Integer.parseInt(s_period); // 조회하고자 하는 기간
			 * 
			 * Calendar cal = Calendar.getInstance(); DateFormat df = new
			 * SimpleDateFormat("yyyy-MM-dd");
			 * 
			 * cal.setTime(new Date()); // 현재날짜 cal.add(Calendar.DATE, 1); String endDate =
			 * df.format(cal.getTime()); // 조회 마지막일
			 * 
			 * cal.add(Calendar.DATE, -1); cal.add(Calendar.MONTH, period); // 조회기간 개월수만큼 뺌
			 * String startDate = df.format(cal.getTime()); // 조회 시작일
			 * 
			 * paraMap.put("startDate", startDate); paraMap.put("endDate", endDate);
			 * 
			 * // 한 페이지당 글 개수 String sizePerPage = "5";
			 * 
			 * // 현재 페이지 번호 String currentShowPageNo =
			 * request.getParameter("currentShowPageNo");
			 * 
			 * if (currentShowPageNo == null) { currentShowPageNo = "1"; }
			 * 
			 * try { if (Integer.parseInt(currentShowPageNo) < 1) { currentShowPageNo = "1";
			 * }
			 * 
			 * } catch (NumberFormatException e) { currentShowPageNo = "1"; }
			 * 
			 * paraMap.put("sizePerPage", sizePerPage); paraMap.put("currentShowPageNo",
			 * currentShowPageNo);
			 * 
			 * // 총 페이지 수 알아오기 int totalPage = idao.getTotalPage(paraMap);
			 * 
			 * // currentShowPageNo에 totalPage보다 큰 값을 입력한 경우 1페이지로 가게함 if
			 * (Integer.parseInt(currentShowPageNo) > totalPage) { currentShowPageNo = "1";
			 * paraMap.put("currentShowPageNo", currentShowPageNo); }
			 * 
			 * List<InquiryVO> inquiryList = idao.showMyInquiryList(paraMap);
			 * request.setAttribute("inquiryList", inquiryList);
			 * 
			 * String pageBar = "";
			 * 
			 * int blockSize = 5; // blockSize 블럭(토막)당 보여지는 페이지 번호의 개수이다.
			 * 
			 * int loop = 1; // loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.
			 * 
			 * // !!!! 다음은 pageNo를 구하는 공식이다. !!!! // int pageNo =
			 * ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1; //
			 * pageNo는 페이지바에서 보여지는 첫번째 번호이다.
			 * 
			 * // 맨 첫 페이지와 이전 페이지 버튼 if (pageNo > 1) { pageBar +=
			 * "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo=1&startDate="
			 * +startDate+"&endDate="+endDate+"'><<</a></li>"; pageBar +=
			 * "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo="
			 * + (pageNo - 1) + "&startDate="+startDate+"&endDate="+endDate+"'><</a></li>";
			 * }
			 * 
			 * // 페이지바 while( !(loop > blockSize || pageNo > totalPage) ) {
			 * 
			 * if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는
			 * String 타입이라서 변경 // 선택한 페이지에 active 클래스 pageBar +=
			 * "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+
			 * "</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다. } else { pageBar +=
			 * "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo="
			 * +pageNo+"&startDate="+startDate+"&endDate="+endDate+">"+pageNo+"</a></li>"; }
			 * 
			 * loop++; pageNo++;
			 * 
			 * }
			 * 
			 * // 다음 페이지와 맨 마지막 페이지 버튼 if( pageNo <= totalPage ) { pageBar +=
			 * "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo"
			 * +pageNo+"&startDate="+startDate+"&endDate="+endDate+"'>></a></li>"; pageBar
			 * +=
			 * "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo"
			 * +totalPage+"&startDate="+startDate+"&endDate="+endDate+"'>>></a></li>"; }
			 * 
			 * /////////////////////////////////////////////////// String currentURL =
			 * MyUtil.getCurrentURL(request); request.setAttribute("goBackURL", currentURL);
			 * ///////////////////////////////////////////////////
			 * 
			 * request.setAttribute("pageBar", pageBar);
			 */
			super.setViewPage("/WEB-INF/cs/inquiry_list.jsp");
			
			
		}
	}

}
