package pca.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.CategoryVO;
import common.model.InquiryVO;
import common.model.MemberVO;
import common.model.ProductVO;
import common.model.SpecVO;
import pca.cs.model.InquiryDAO;
import pca.cs.model.InterInquiryDAO;
import pca.shop.model.InterProductDAO;
import pca.shop.model.ProductDAO;

public class ProductGiftSetJSON extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		Map<String, String> paraMap = new HashMap<>();
		
		// 정렬기준
		String order = request.getParameter("order");
		
		// 카테고리 넘버
		String cnum = request.getParameter("cnum");
		
		String currentShowPageNo = "1";
		if(!"".equals(request.getParameter("currentShowPageNo")))
			currentShowPageNo = request.getParameter("currentShowPageNo");
		
		paraMap.put("order", order);
		paraMap.put("cnum", cnum);
		paraMap.put("currentShowPageNo", currentShowPageNo);
		
		InterProductDAO pdao = new ProductDAO();
		
		List<ProductVO> productList = pdao.selectSetGoodsByCategory(paraMap);
		
		// json객체 배열로 넘긴다.
		JSONArray jsonArr = new JSONArray();

		if (productList.size() > 0) {

			for (ProductVO pvo : productList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("pnum", pvo.getPnum());
				jsonObj.put("pname", pvo.getPname());
				jsonObj.put("cname", pvo.getCategvo().getCname());
				jsonObj.put("pimage", pvo.getPimage());
				jsonObj.put("pqty", pvo.getPqty());
				jsonObj.put("price", pvo.getPrice());
				jsonObj.put("saleprice", pvo.getSaleprice());
				jsonObj.put("sname", pvo.getSpvo().getSname());
				jsonObj.put("pcontent", pvo.getPcontent());
				jsonObj.put("psummary", pvo.getPsummary());
				jsonObj.put("point", pvo.getPoint());
				jsonObj.put("pinputdate", pvo.getPinputdate());
				jsonObj.put("reviewCnt", pvo.getReviewCnt());
				jsonObj.put("orederCnt", pvo.getOrederCnt());
				jsonArr.put(jsonObj);
			}
		}
		String json = jsonArr.toString();
		request.setAttribute("json", json);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		
	}

}
