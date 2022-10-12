package pca.admin.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import pca.shop.model.InterOrderDAO;
import pca.shop.model.OrderDAO;

public class RefundOrder extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String odnums = request.getParameter("odnums");
		String[] odnumArr = odnums.split("\\,");
		
		String userids = request.getParameter("userids");
		String[] useridArr = userids.split("\\,");
		
		String odrcodes = request.getParameter("odrcodes");
		String[] odrcodeArr = odrcodes.split("\\,");
		
		String oprices = request.getParameter("oprices");
		String[] opriceArr = oprices.split("\\,");
		
		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("odnumArr", odnumArr);
		paraMap.put("useridArr", useridArr);
		paraMap.put("odrcodeArr", odrcodeArr);
		paraMap.put("opriceArr", opriceArr);
		
		InterOrderDAO idao = new OrderDAO();
		int n = 0;
		boolean isSuccess = false;
		
		// 환불처리하기
		int result = idao.refundOrder(paraMap);
	
		if (result == odnumArr.length)
			isSuccess = true;
		
		JSONObject jsobj = new JSONObject();
		jsobj.put("isSuccess", isSuccess);
		String json = jsobj.toString();
		request.setAttribute("json", json);
		
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}

}
