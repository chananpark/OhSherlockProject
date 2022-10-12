package common.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.model.ProductVO;
import pca.shop.model.InterProductDAO;
import pca.shop.model.ProductDAO;

public class IndexController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 로그인 또는 로그아웃을 하면 시작페이지로 가는 것이 아니라 방금 보았던 그 페이지로 그대로 가기 위한 것임. 
		super.goBackURL(request);
		
		InterProductDAO pdao = new ProductDAO();
		// 메인에 표시할 최신상품 4개 가져오기
		List<ProductVO> todayProductList = pdao.selectTodayProducts();
		request.setAttribute("todayProductList", todayProductList);
		
		super.setViewPage("/WEB-INF/index.jsp");
		
	}

}
