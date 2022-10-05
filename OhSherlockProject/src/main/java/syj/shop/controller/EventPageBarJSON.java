package syj.shop.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import syj.shop.model.InterProductDAO;
import syj.shop.model.ProductDAO;

public class EventPageBarJSON extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String cnum = request.getParameter("cnum");
		String snum = request.getParameter("snum");
		
		// *** 카테고리 번호에 해당하는 제품들을 페이징처리하여 보여주기 *** //
		String currentShowPageNo = request.getParameter("currentShowPageNo");

		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		}
		// === GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 숫자가 아닌 문자를 입력한 경우 또는 
        //     int 범위를 초과한 숫자를 입력한 경우라면 currentShowPageNo 는 1 페이지로 만들도록 한다. 
		// 	   currnetShowPageNO 가 0 이하라면  currentShowPageNo 는 1 페이지로 만들도록 한다. ==== // 
		try {
			if(Integer.parseInt(currentShowPageNo) < 1) {
				currentShowPageNo = "1";  // 0과 음수로 들어온다면 1페이지를 보여준다.
			}
		} catch (NumberFormatException e) {
			currentShowPageNo = "1"; // integer로 바꿨는데 바뀌지 않는다면(url에 문자를 넣었다면), 그냥 1페이지를 보여준다.
		}
				
		Map<String,String> paraMap = new HashMap<>();
		// 한 페이지당 화면상에 보여줄 제품의 개수는 10개로 고정한다. sizePerPage는 ProductDAO에서 상수로 설정해두었음
		paraMap.put("currentShowPageNo", currentShowPageNo); // 1페이지 볼거냐 2페이지 볼거냐, 뒤의 숫자는 계속 변경 
		paraMap.put("cnum", cnum);
		paraMap.put("snum", snum);
		
		InterProductDAO pdao = new ProductDAO();
		
		// 페이지바를 위한 검색이 없는 특정 카테고리 상품에 대한 총 페이지 알아오기
		int totalPage = pdao.getEventTotalPage(paraMap); 
		// System.out.println("확인용totalpage : " + totalPage);
		
		// == get 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 토탈페이지수 보다 큰 값을 입력하여 장난친 경우에는 1페이지로 가게끔 막아주는 것 시작
		// pageBar 가 만일 20,21이 끝일 때 22페이지는 없기 때문에 url에서 장난질을 친 것이다. 
		// 이렇게 없는 페이지를 url 에서 장난질 쳤을 경우에는 아래와 같이 해준다.
		if( Integer.parseInt(currentShowPageNo) > totalPage ) {
			currentShowPageNo = "1"; // 없는 페이지로 장난질 칠 때는 무조건 1을 보여준다.
			paraMap.put("currentShowPageNo", currentShowPageNo); // url에 장난질 쳤을 경우에는 1로 바뀐 값을 담아 준다.
			
		}
		
		// *** 페이지바 만들기 시작 *** //
		String pageBar = "";
		
		int blockSize = 5; // blockSize 는 블럭(토막) 당 보여지는 페이지 번호의 개수이다.
		
		int loop = 1; // loop 는 1부터 증가하여 1개 블럭을 이루는 페이지 번호의 개수(지금은 10개, 1~10, 11~20 ) 까지만 증가하는 용도이다.
		
		// !!! 다음은 pageNo를 구하는 공식이다. !!! //
		int pageNo = ( (Integer.parseInt(currentShowPageNo)- 1) / blockSize ) * blockSize + 1; // pageNo는 페이지바에서 보여지는 첫번째 번호이다.
		JSONObject jsonObj = new JSONObject(); // {}
		if( snum != null ) {
			// snum 이 넘어올 경우
			// ***** 맨처음/이전 만들기 ***** //
			if( pageNo != 1 ) {  
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_spec.tea?currentShowPageNo=1&snum="+snum+"'><<</a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_spec.tea?currentShowPageNo="+(pageNo-1)+"&snum="+snum+"'><</a></li>";
			} 
			
			while( !(loop > blockSize || pageNo > totalPage) ) { // 10번을 반복한 다음에 11이 되면 그대로 빠져나간다. 페이지바가 한 세트당 10개만 찍어줄 것이기 때문. 만일 1-5까지만 보여줄 거면 blockSize를 5로 잡으면 될까?
				
				if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
					pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
				} else {
					pageBar += "<li class='page-item'><a class='page-link' href='productEvent_spec.tea?currentShowPageNo="+pageNo+"&snum="+snum+"'>"+pageNo+"</a></li>";
				}
				
				loop++; 
				pageNo++;
				
				
			} // end of while( loop > blockSize )
			
			// ***** 다음/마지막 만들기 ***** //
			
			if( pageNo <= totalPage ) {  // 계속 다음을 누르면 22페이지가 나오게 되는데 없는 번호를 누르면 1페이지로 보내주기 때문에 마지막 페이지(totalPage 보다 작아질 때)에서는 다음 버튼을 막아주어야 한다.
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_spec.tea?currentShowPageNo="+pageNo+"&snum="+snum+"'>></a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_spec.tea?currentShowPageNo="+totalPage+"&snum="+snum+"'>>></a></li>";
			} 
			jsonObj.put("pageBar", pageBar);  // {"isExists":true} 또는 {"isExists":false} 으로 만들어 준다.  
			
		} else if( cnum != null) {
			// cnum 이 넘어올 경우
			// ***** 맨처음/이전 만들기 ***** //
			if( pageNo != 1 ) {  
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_category.tea?currentShowPageNo=1&cnum="+cnum+"'><<</a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_category.tea?currentShowPageNo="+(pageNo-1)+"&cnum="+cnum+"'><</a></li>";
			} 
			
			while( !(loop > blockSize || pageNo > totalPage) ) { // 10번을 반복한 다음에 11이 되면 그대로 빠져나간다. 페이지바가 한 세트당 10개만 찍어줄 것이기 때문. 만일 1-5까지만 보여줄 거면 blockSize를 5로 잡으면 될까?
				
				if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
					pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
				} else {
					pageBar += "<li class='page-item'><a class='page-link' href='productEvent_category.tea?currentShowPageNo="+pageNo+"&cnum="+cnum+"'>"+pageNo+"</a></li>";
				}
				
				loop++;  
				pageNo++;
				
			} // end of while( loop > blockSize )
			
			// ***** 다음/마지막 만들기 ***** //
			if( pageNo <= totalPage ) {  

				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_category.tea?currentShowPageNo="+pageNo+"&cnum="+cnum+"'>></a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_category.tea?currentShowPageNo="+totalPage+"&cnum="+cnum+"'>>></a></li>";

			} 
			jsonObj.put("pageBar", pageBar);  // {"isExists":true} 또는 {"isExists":false} 으로 만들어 준다.  
		} else {
			// 전체 상품
			// ***** 맨처음/이전 만들기 ***** //
			if( pageNo != 1 ) {  
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent.tea?currentShowPageNo=1'><<</a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent.tea?currentShowPageNo="+(pageNo-1)+"'><</a></li>";
			} 
			
			while( !(loop > blockSize || pageNo > totalPage) ) { 
				
				if( pageNo == Integer.parseInt(currentShowPageNo) ) {

					pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; 
				} else {
					pageBar += "<li class='page-item'><a class='page-link' href='productEvent.tea?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
				}
				
				loop++;   
				pageNo++;
				
			} // end of while( loop > blockSize )
			
			// ***** 다음/마지막 만들기 ***** //
			if( pageNo <= totalPage ) {  
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent.tea?currentShowPageNo="+pageNo+"'>></a></li>";
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent.tea?currentShowPageNo="+totalPage+"'>>></a></li>";
			} 
			jsonObj.put("pageBar", pageBar);  // {"isExists":true} 또는 {"isExists":false} 으로 만들어 준다.  
		}
		// *** 페이지바 만들기 끝 *** //

		String json = jsonObj.toString(); 
		// 문자열 형태인 "{"isExists":true}" 또는 "{"isExists":false}" 으로 만들어 준다.  
//		System.out.println("확인용 json : " + json); // 확인용 json : {"isExists":true} // 이게 통으로 String 
		
		request.setAttribute("json", json);
		request.setAttribute("currentShowPageNo", currentShowPageNo);
		request.setAttribute("snum", snum);
		request.setAttribute("cnum", cnum);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
