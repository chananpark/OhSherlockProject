package pca.cs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.NoticeVO;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;

public class Notice extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		InterNoticeDAO ndao = new NoticeDAO();
		
		// 한 페이지당 글 개수
		String sizePerPage = "10";
		
		// 현재 페이지 번호
//		String currentShowPageNo = request.getParameter("currentShowPageNo");
//		if (currentShowPageNo == null) {
//			currentShowPageNo = "1";
//		}
		
//		try {
//			if (Integer.parseInt(currentShowPageNo) < 1) {
//				currentShowPageNo = "1";
//			}
//
//		} catch (NumberFormatException e) {
//			currentShowPageNo = "1";
//		}
		
//		Map<String, String> paraMap = new HashMap<>();
//
//		paraMap.put("sizePerPage", sizePerPage);
//		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		// 총 페이지 수 알아오기
//		int totalPage = ndao.getTotalPage(paraMap);
		
		// currentShowPageNo에 totalPage보다 큰 값을 입력한 경우 1페이지로 가게함
//		if (Integer.parseInt(currentShowPageNo) > totalPage) {
//			currentShowPageNo = "1";
//			paraMap.put("currentShowPageNo", currentShowPageNo);
//		}
		
		
		
		List<NoticeVO> noticeList = new ArrayList<>();
		noticeList = ndao.showNoticeList();
		
		if (noticeList.size() > 0) {
			request.setAttribute("noticeList", noticeList);
			request.setAttribute("sizePerPage", sizePerPage);
		}
		
//		String pageBar = "";
//
//		int blockSize = 10;
//		// blockSize 블럭(토막)당 보여지는 페이지 번호의 개수이다.
//
//		int loop = 1;
//		// loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.
//
//		// !!!! 다음은 pageNo를 구하는 공식이다. !!!! //
//		int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;
//		// pageNo는 페이지바에서 보여지는 첫번째 번호이다.
//
//		request.setAttribute("pageBar", pageBar);
		
		super.setViewPage("/WEB-INF/cs/notice.jsp");
		
	}

}
