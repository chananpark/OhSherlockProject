package pca.admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import pca.shop.model.InterOrderDAO;
import pca.shop.model.OrderDAO;

public class ProcessDeliver extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String type = request.getParameter("type");
		String odrcodes = request.getParameter("odrcodes");
		
		InterOrderDAO idao = new OrderDAO();
		int n = 0;
		boolean isSuccess = false;
		
		// 발송처리
		if ("deliver".equals(type)) {
			n = idao.sendDelivery(odrcodes);
		}
		// 배송완료처리
		else if("complete".equals(type)) {
			n = idao.completeDelivery(odrcodes);
		}
		
		if (n > 0)
			isSuccess = true;
		
		JSONObject jsobj = new JSONObject();
		jsobj.put("isSuccess", isSuccess);
		String json = jsobj.toString();
		request.setAttribute("json", json);
		
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}

}
