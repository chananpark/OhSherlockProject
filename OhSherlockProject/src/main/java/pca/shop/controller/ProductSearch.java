package pca.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.ProductVO;
import pca.shop.model.InterProductDAO;
import pca.shop.model.ProductDAO;

public class ProductSearch extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 로그인 또는 로그아웃을 하면 시작페이지로 가는 것이 아니라 방금 보았던 그 페이지로 그대로 가기 위한 것임. 
		super.goBackURL(request);
		
		String searchWord = request.getParameter("searchWord");
		String cnum = request.getParameter("cnum");
		String currentShowPageNo = request.getParameter("currentShowPageNo");
		String order = request.getParameter("order");
		
		if(order == null) {
			order = "pnum desc";
		}

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
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchWord", searchWord); // 검색어
		paraMap.put("cnum", cnum); // 카테고리
		paraMap.put("order", order); // 정렬기준
		paraMap.put("currentShowPageNo", currentShowPageNo); // 현재페이지
		
		InterProductDAO pdao = new ProductDAO();
		
		// 검색결과 개수
		int totalCnt = pdao.countSearchedGoods(paraMap);
		request.setAttribute("totalCnt", totalCnt);
		
		// 전체 페이지 수 가져오기
		int totalPage = pdao.getSearchedTotalPage(paraMap);
		
		// 요청한 페이지가 전체 페이지 수보다 크다면
		if (Integer.parseInt(currentShowPageNo) > totalPage) {
			currentShowPageNo = "1";
			paraMap.put("currentShowPageNo", currentShowPageNo);
		}
		
		// 검색어로 상품 목록 가져오기
		List<ProductVO> productList = pdao.selectSearchedGoods(paraMap);
		request.setAttribute("productList", productList);
		
		// 페이지바 만들기
		String pageBar = "";

		// 블럭당 페이지 번호 개수
		int blockSize = 10;

		int loop = 1;

		// 페이지블럭의 첫 페이지 구하기 공식
		int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;
		
		// [맨처음][이전] 만들기
		if (pageNo > 1) {
			pageBar += "<li class='page-item'><a class='page-link' href='productSearch.tea?searchWord="+searchWord+"&currentShowPageNo=1&cnum="+cnum+"&order="+order+"'> << </a></li>";				
			pageBar += "<li class='page-item'><a class='page-link' href='productSearch.tea?searchWord="+searchWord+"&currentShowPageNo="+ (pageNo - 1) +"&cnum="+cnum+"&order="+order+"'><</a></li>";
		}
		
		//while( !(loop > blockSize || pageNo > totalPage)) {
		while(loop <= blockSize && pageNo <= totalPage) {
			
			// 현재 페이지에 active 클래스 넣기, href url 빼기("#" == 자기 자신의 페이지로 이동)
			if (pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageNo + "</a></li>";
			}
			else
				pageBar += "<li class='page-item'><a class='page-link' href='productSearch.tea?searchWord="+searchWord+"&currentShowPageNo=" + pageNo + "&cnum="+cnum+"&order="+order+"'>" + pageNo + "</a></li>";
			
			loop++;
			pageNo++;
		}
		
		// [다음][마지막] 만들기
		if (pageNo <= totalPage) {
			pageBar += "<li class='page-item'><a class='page-link' href='productSearch.tea?searchWord="+searchWord+"&currentShowPageNo=" + pageNo + "&cnum="+cnum+"&order="+order+"'>></a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='productSearch.tea?searchWord="+searchWord+"&currentShowPageNo=" + totalPage + "&cnum="+cnum+"&order="+order+"'>>></a></li>";				
		}
				
		request.setAttribute("pageBar", pageBar);
		
		request.setAttribute("searchWord", searchWord);
		request.setAttribute("cnum", cnum);
		request.setAttribute("currentShowPageNo", currentShowPageNo);
		request.setAttribute("order", order);
		
		super.getTeaCategoryList(request);
		super.getGiftsetCategoryList(request);
		
		super.setViewPage("/WEB-INF/product/product_search.jsp");
		
	}

}
