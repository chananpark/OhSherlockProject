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
		
		InterProductDAO pdao = new ProductDAO();
		// 메인에 표시할 최신상품 4개 가져오기
		List<ProductVO> todayProductList = pdao.selectTodayProducts();
		request.setAttribute("todayProductList", todayProductList);
		
		super.setViewPage("/WEB-INF/index.jsp");
		
	}

}
