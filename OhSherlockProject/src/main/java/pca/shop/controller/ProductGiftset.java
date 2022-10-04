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

public class ProductGiftset extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		super.getGiftsetCategoryList(request); // 카테고리 목록
		
		String cnum = request.getParameter("cnum");
		if (cnum == null) {
			cnum = "";
		}
		
		// 카테고리번호에 해당하는 제품들을 페이징처리하여 보여주기
		String currentShowPageNo = request.getParameter("currentShowPageNo");
		// 현재 페이지바의 페이지번호

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
		
		// 한 페이지당 화면상에 보여줄 제품의 개수는 10 => ProductDAO에 상수로 설정
		paraMap.put("cnum", cnum); // 카테고리번호
		paraMap.put("order", "pnum desc"); // 정렬기준
		paraMap.put("currentShowPageNo", currentShowPageNo); // 현재페이지

		InterProductDAO pdao = new ProductDAO();
		
		// 페이징처리를 위한 특정 카테고리 총페이지 알아오기
		int totalPage = pdao.getTotalPage(cnum);

		if (Integer.parseInt(currentShowPageNo) > totalPage) {
			currentShowPageNo = "1";
			paraMap.put("currentShowPageNo", currentShowPageNo);
		}
		List<ProductVO> productList = pdao.selectSetGoodsByCategory(paraMap);
		request.setAttribute("productList", productList);
		
		String pageBar = "";

		int blockSize = 10;
		// blockSize 블럭당 페이지 번호 개수

		int loop = 1;

		// 페이지블럭의 첫 페이지 구하기 공식
		int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;
		
		// [맨처음][이전] 만들기
		if (pageNo > 1) {
			pageBar += "<li class='page-item'><a class='page-link' href='productGiftset.tea?currentShowPageNo=1&cnum="+cnum+"'> << </a></li>";				
			pageBar += "<li class='page-item'><a class='page-link' href='productGiftset.tea?currentShowPageNo="+ (pageNo - 1) +"&cnum="+cnum+"'><</a></li>";
		}
		
		//while( !(loop > blockSize || pageNo > totalPage)) {
		while(loop <= blockSize && pageNo <= totalPage) {
			
			// 현재 페이지에 active 클래스 넣기, href url 빼기("#" == 자기 자신의 페이지로 이동)
			if (pageNo == Integer.parseInt(currentShowPageNo)) {
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageNo + "</a></li>";
			}
			else
				pageBar += "<li class='page-item'><a class='page-link' href='productGiftset.tea?currentShowPageNo=" + pageNo + "&cnum="+cnum+"'>" + pageNo + "</a></li>";
			
			loop++;
			pageNo++;
		}
		
		// [다음][마지막] 만들기
		if (pageNo <= totalPage) {
			pageBar += "<li class='page-item'><a class='page-link' href='productGiftset.tea?currentShowPageNo=" + pageNo + "&cnum="+cnum+"'>></a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='productGiftset.tea?currentShowPageNo=" + totalPage + "&cnum="+cnum+"'>>></a></li>";				
		}
		
		request.setAttribute("pageBar", pageBar);
		
		request.setAttribute("currentShowPageNo", currentShowPageNo);
		request.setAttribute("cnum", cnum);
		
		super.setViewPage("/WEB-INF/product/product_list_giftset.jsp");
	}

}