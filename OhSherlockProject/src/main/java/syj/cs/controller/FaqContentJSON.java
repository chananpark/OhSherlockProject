package syj.cs.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.*;
import common.model.*;
import syj.cs.model.*;

public class FaqContentJSON extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 여기로 ajax를 이용하여 넘겨 준 것 
		String selectid = request.getParameter("selectid");  // 이거는 클릭한 아이디를 넘겨준 것
			
		InterFaqDAO fdao = new FaqDAO();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("selectid", selectid); 
		
		List<FaqVO> faqList = fdao.selectFaqList(paraMap); // 이 결과물을 json 타입으로 바꿔서 뿌려주면 된다.
		// 파라맵이 where절에 들어간다.
		// 넘어온 ajax 값에 따른 결과값 8개 리스트를 json(자바스크립트) 형태로 바꿔야만 jsp 로 넘어가서 화면에 보여줄 수 있다.
		
		JSONArray jsonArr = new JSONArray(); 	// [] 리스트이기 때문에 배열 [] 로 바꿔주어야 한다. 
		if(faqList.size() > 0) { // 배열이 비어있지 않다면
		
			for(FaqVO fvo : faqList) {
				JSONObject jsonObj = new JSONObject(); 	// {} 자바스크립트의 객체로 바꾸는 것 
				// 매번 객체 {} 하나를 만들어준다.
				
				jsonObj.put("faq_num", fvo.getFaq_num());  
				jsonObj.put("faq_category", fvo.getFaq_category());  
				jsonObj.put("faq_subject", fvo.getFaq_subject());  
				jsonObj.put("faq_content", fvo.getFaq_content());  
	            
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
