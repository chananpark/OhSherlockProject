package syj.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.FaqVO;
import common.model.ProductVO;
import syj.shop.model.InterProductDAO;
import syj.shop.model.ProductDAO;

public class EventOrderListJSON extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String selectid = request.getParameter("selectid"); 
		
		InterProductDAO pdao = new ProductDAO();
		
		Map<String, String> paraMap = new HashMap<>();
		
		String orderSQL = "";
		
		if("order_new".equalsIgnoreCase(selectid)) {
			// 신상품순
			orderSQL = " PINPUTDATE desc ";
		} else if("order_highPrice".equalsIgnoreCase(selectid)) {
			// 높은가격순
			orderSQL = " saleprice desc ";
		} else if("order_rowPrice".equalsIgnoreCase(selectid)) {
			// 낮은가격순
			orderSQL = " saleprice asc ";
		} else if("order_review".equalsIgnoreCase(selectid)) {
			// 리뷰많은순
			orderSQL = " reviewCnt desc ";
		} else if("order_sell".equalsIgnoreCase(selectid)) {
			// 주문순
			orderSQL = " orederCnt desc ";
		} 
		
		paraMap.put("orderSQL", orderSQL); 
		
		List<ProductVO> productList = pdao.selectEventGoodsByCategory(paraMap);
		
		JSONArray jsonArr = new JSONArray(); 	// [] 리스트이기 때문에 배열 [] 로 바꿔주어야 한다. 
		if(productList.size() > 0) { // 배열이 비어있지 않다면
		
			for(ProductVO pvo : productList) {
				JSONObject jsonObj = new JSONObject(); 	// {} 자바스크립트의 객체로 바꾸는 것 
				// 매번 객체 {} 하나를 만들어준다.
				
				jsonObj.put("cname", pvo.getCategvo().getCname());  
				jsonObj.put("sname", pvo.getSpvo().getSname());  
				jsonObj.put("pnum", pvo.getPnum());  
				jsonObj.put("pname", pvo.getPname());  
				jsonObj.put("pimage", pvo.getPimage());  
				jsonObj.put("pqty", pvo.getPqty());  
				jsonObj.put("price", pvo.getPrice());  
				jsonObj.put("saleprice", pvo.getSaleprice());  
				jsonObj.put("pcontent", pvo.getPcontent());  
				jsonObj.put("psummary", pvo.getPsummary());  
				jsonObj.put("point", pvo.getPoint());  
				jsonObj.put("pinputdate", pvo.getPinputdate());  
				jsonObj.put("reviewCnt", pvo.getReviewCnt());  
				jsonObj.put("orederCnt", pvo.getOrederCnt());  

				jsonArr.put(jsonObj); // [{}, {}, {}] 하니씩 불러온 애들을 배열에 넣어주어야 한다. ==> jsonArr
	            
			} // end of for
			
			String json = jsonArr.toString(); // jsonArr 를 문자열로 변환 "[{}, {}, {}]"
	//		System.out.println("확인용 : " + json);

			request.setAttribute("json", json);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp"); // key값이 json 인 jsonview.jsp에 뿌러준다.
			
		} else {
			// DB 에서 조회된 것이 없다면 
			String json = jsonArr.toString(); // "[]"
			// *** 만약에  select 되어진 정보가 없다라면 [] 로 나오므로 null 이 아닌 요소가 없는 빈배열이다. *** --
		    //   System.out.println("~~~~ 확인용 json => " + json);
		    //   ~~~~ 확인용 json => []
			// 배열은 이미 if 문 위에 만들어져 있기 때문에 빈껍데기를 돌려준다. 
			
			request.setAttribute("json", json);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/jsonview.jsp"); // key값이 json 인 jsonview.jsp에 뿌러준다.
			
		} // end of if(faqList.size() > 0) - else 
		
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception 

}
