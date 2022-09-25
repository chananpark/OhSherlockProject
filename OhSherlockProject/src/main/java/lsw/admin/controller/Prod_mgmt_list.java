package lsw.admin.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import lsw.admin.model.InterProductDAO;
import lsw.admin.model.ProductDAO;
import lsw.admin.model.ProductVO;

public class Prod_mgmt_list extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		if("GET".equalsIgnoreCase(method)) { //"GET"

			InterProductDAO pdao = new ProductDAO();
			
			List<ProductVO> productList = new ArrayList<>();
			productList = pdao.showProductList();
			
			if (productList.size() > 0) {
				request.setAttribute("productList", productList);
			}
			
		}
		
		else {	// "POST""

		}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/admin/prod_mgmt_list.jsp");
		
	}

}
