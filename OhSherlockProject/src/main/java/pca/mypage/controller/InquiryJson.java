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

public class InquiryJson extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		InterInquiryDAO idao = new InquiryDAO();
		HttpSession session = request.getSession();
		
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String userid = loginuser.getUserid();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("userid", userid);

		// 기간 조회 범위 개월수
		String s_period = "1"; // 기본값: 1개월
		
		// 탭으로 개월수를 선택했을 경우
		if(request.getParameter("period") != null) {
			s_period = request.getParameter("period");
		}

		int period = -Integer.parseInt(s_period); // 조회하고자 하는 기간

		String startDate;
		String endDate;
		// datepicker에서 날짜를 선택했을 경우
		if (request.getParameter("startDate") != null && request.getParameter("endDate") != null) {
			startDate = request.getParameter("startDate");
			endDate = request.getParameter("endDate");
		}
		else { // 탭으로 개월수를 선택했을 경우
			Calendar cal = Calendar.getInstance();
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	
			cal.setTime(new Date()); // 현재날짜
			endDate = df.format(cal.getTime()); // 조회 마지막일
	
			cal.add(Calendar.DATE, -1);
			cal.add(Calendar.MONTH, period); // 조회기간 개월수만큼 뺌
			startDate = df.format(cal.getTime()); // 조회 시작일
		}
		paraMap.put("startDate", startDate);
		paraMap.put("endDate", endDate);

		// 한 페이지당 글 개수
		String sizePerPage = "5";

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

		paraMap.put("sizePerPage", sizePerPage);
		paraMap.put("currentShowPageNo", currentShowPageNo);

		// 총 페이지 수 알아오기
		int totalPage = idao.getTotalPage(paraMap);

		// currentShowPageNo에 totalPage보다 큰 값을 입력한 경우 1페이지로 가게함
		if (Integer.parseInt(currentShowPageNo) > totalPage) {
			currentShowPageNo = "1";
			paraMap.put("currentShowPageNo", currentShowPageNo);
		}

		List<InquiryVO> inquiryList = idao.showMyInquiryList(paraMap);
		request.setAttribute("inquiryList", inquiryList);

		String pageBar = "";

		int blockSize = 5;
		// blockSize 블럭(토막)당 보여지는 페이지 번호의 개수이다.

		int loop = 1;
		// loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.

		// !!!! 다음은 pageNo를 구하는 공식이다. !!!! //
		int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;
		// pageNo는 페이지바에서 보여지는 첫번째 번호이다.

		// 맨 첫 페이지와 이전 페이지 버튼
		if (pageNo > 1) {
			pageBar += "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo=1&startDate="
					+ startDate + "&endDate=" + endDate + "'><<</a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo="
					+ (pageNo - 1) + "&startDate=" + startDate + "&endDate=" + endDate + "'><</a></li>";
		}

		// 페이지바
		while (!(loop > blockSize || pageNo > totalPage)) {

			if (pageNo == Integer.parseInt(currentShowPageNo)) { // currentShowPageNo는 String 타입이라서 변경
				// 선택한 페이지에 active 클래스
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageNo + "</a></li>";
			} else {
				pageBar += "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo="
						+ pageNo + "&startDate=" + startDate + "&endDate=" + endDate + ">" + pageNo + "</a></li>";
			}

			loop++;
			pageNo++;

		}

		// 다음 페이지와 맨 마지막 페이지 버튼
		if (pageNo <= totalPage) {
			pageBar += "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo" + pageNo
					+ "&startDate=" + startDate + "&endDate=" + endDate + "'>></a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='inquiryList.tea?currentShowPageNo" + totalPage
					+ "&startDate=" + startDate + "&endDate=" + endDate + "'>>></a></li>";
		}

		///////////////////////////////////////////////////
		String currentURL = MyUtil.getCurrentURL(request);
		request.setAttribute("goBackURL", currentURL);
		///////////////////////////////////////////////////

		request.setAttribute("pageBar", pageBar);

		// json객체 배열로 넘긴다.
		JSONArray jsonArr = new JSONArray();

		if (inquiryList.size() > 0) {

			for (InquiryVO ivo : inquiryList) {
				JSONObject jsonObj = new JSONObject(); // {}
				jsonObj.put("inquiry_no", ivo.getInquiry_no());
				jsonObj.put("inquiry_type", ivo.getInquiry_type());
				jsonObj.put("inquiry_subject", ivo.getInquiry_subject());
				jsonObj.put("inquiry_content", ivo.getInquiry_content());
				jsonObj.put("inquiry_date", ivo.getInquiry_date());
				jsonObj.put("inquiry_answered", ivo.getInquiry_answered());

				jsonArr.put(jsonObj);
			}

			String json = jsonArr.toString();
			request.setAttribute("json", json);
			super.setViewPage("/WEB-INF/jsonview.jsp");
		} else {
			// DB에서 조회된 것이 없으면
			String json = jsonArr.toString(); // 빈껍데기
			request.setAttribute("json", json);
			super.setViewPage("/WEB-INF/jsonview.jsp");

		}
	}

}
