package pca.cs.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.NoticeVO;
import my.util.MyUtil;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;

public class Notice extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 로그인 또는 로그아웃을 하면 시작페이지로 가는 것이 아니라 방금 보았던 그 페이지로 그대로 가기 위한 것임. 
		super.goBackURL(request);
		
		InterNoticeDAO ndao = new NoticeDAO();
		Map<String, String> paraMap = new HashMap<>();
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
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

		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		// 총 페이지 수 알아오기
		int totalPage = ndao.getTotalPage(paraMap);
		
		// currentShowPageNo에 totalPage보다 큰 값을 입력한 경우 1페이지로 가게함
		if (Integer.parseInt(currentShowPageNo) > totalPage) {
			currentShowPageNo = "1";
			paraMap.put("currentShowPageNo", currentShowPageNo);
		}
		
		List<NoticeVO> noticeList = ndao.showNoticeList(paraMap);
		request.setAttribute("noticeList", noticeList);
		
		String pageBar = "";

		int blockSize = 5;
		// blockSize 블럭(토막)당 보여지는 페이지 번호의 개수이다.

		int loop = 1;
		// loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.

		// !!!! 다음은 pageNo를 구하는 공식이다. !!!! //
		int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;
		// pageNo는 페이지바에서 보여지는 첫번째 번호이다.

		// 검색어가 없는 경우 searchType과 searchWord에는 아무글자도 없도록한다
		if (searchType == null) {
			searchType = "";
		}
		
		if (searchWord == null) {
			searchWord = "";
		}
		
		// 맨 첫 페이지와 이전 페이지 버튼
		if (pageNo > 1) {
			pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo=1&searchType="+searchType+"&searchWord="+searchWord+"'><<</a></li>";				
			pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo=" + (pageNo - 1) + "&searchType="+searchType+"&searchWord="+searchWord+"'><</a></li>";
		}
		
		// 페이지바
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
				// 선택한 페이지에 active 클래스
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
			} else {
				pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo="+pageNo+"&searchType="+searchType+"&searchWord="+searchWord+"'>"+pageNo+"</a></li>";
			}
			
			loop++;
			pageNo++;
			
		} 
		
		// 다음 페이지와 맨 마지막 페이지 버튼
		if( pageNo <= totalPage ) { 
			pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo="+pageNo+"&searchType="+searchType+"&searchWord="+searchWord+"'>></a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo="+totalPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>>></a></li>";
		}
		
		//
		String currentURL = MyUtil.getCurrentURL(request);
		request.setAttribute("goBackURL", currentURL);
		//
		
		request.setAttribute("pageBar", pageBar);
		request.setAttribute("searchType", searchType);
		request.setAttribute("searchWord", searchWord);
		
		super.setViewPage("/WEB-INF/cs/notice.jsp");
		
	}

}
