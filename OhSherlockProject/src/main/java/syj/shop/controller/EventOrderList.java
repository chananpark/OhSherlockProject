package syj.shop.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.ProductVO;
import syj.shop.model.InterProductDAO;
import syj.shop.model.ProductDAO;

public class EventOrderList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 로그인 또는 로그아웃을 하면 시작페이지로 가는 것이 아니라 방금 보았던 그 페이지로 그대로 가기 위한 것임. 
		super.goBackURL(request);

		String order = request.getParameter("order"); 
		String cnum = request.getParameter("cnum"); 
		String snum = request.getParameter("snum"); 
		String currentShowPageNo = request.getParameter("currentShowPageNo"); 

		InterProductDAO pdao = new ProductDAO();
		
		Map<String, String> paraMap = new HashMap<>();
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";
		} else if ("".equals(currentShowPageNo)) {
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
		
		if( snum == null ) {
			snum = "";
		}
		
		if( cnum == null ) {
			cnum = "";
		}
		
		paraMap.put("order", order); 
		paraMap.put("cnum", cnum); 
		paraMap.put("snum", snum); 
		paraMap.put("currentShowPageNo", currentShowPageNo); 
		
		// 페이지바를 위한 검색이 없는 특정 카테고리 상품에 대한 총 페이지 알아오기
		int totalPage = pdao.getEventTotalPage(paraMap); 
		
		if( Integer.parseInt(currentShowPageNo) > totalPage ) {
			currentShowPageNo = "1"; // 없는 페이지로 장난질 칠 때는 무조건 1을 보여준다.
			paraMap.put("currentShowPageNo", currentShowPageNo); // url에 장난질 쳤을 경우에는 1로 바뀐 값을 담아 준다.
		}
		
		List<ProductVO> productList = pdao.selectEventGoodsByCategory(paraMap);
		
		request.setAttribute("productList", productList);

		// *** 페이지바 만들기 시작 *** //
		String pageBar = "";
		
		int blockSize = 5; // blockSize 는 블럭(토막) 당 보여지는 페이지 번호의 개수이다.
		
		int loop = 1; // loop 는 1부터 증가하여 1개 블럭을 이루는 페이지 번호의 개수(지금은 10개, 1~10, 11~20 ) 까지만 증가하는 용도이다.
		
		// !!! 다음은 pageNo를 구하는 공식이다. !!! //
		int pageNo = ( (Integer.parseInt(currentShowPageNo)- 1) / blockSize ) * blockSize + 1; // pageNo는 페이지바에서 보여지는 첫번째 번호이다.
		// ***** 맨처음/이전 만들기 ***** //
		if( pageNo != 1 ) {  
			pageBar += "<li class='page-item'><a class='page-link' href='eventOrderList.tea?currentShowPageNo=1&snum="+snum+"&cnum="+cnum+"&order="+order+"'><<</a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='eventOrderList.tea?currentShowPageNo="+(pageNo-1)+"&snum="+snum+"&cnum="+cnum+"&order="+order+"'><</a></li>";
		} 

		while( !(loop > blockSize || pageNo > totalPage) ) { // 10번을 반복한 다음에 11이 되면 그대로 빠져나간다. 페이지바가 한 세트당 10개만 찍어줄 것이기 때문. 만일 1-5까지만 보여줄 거면 blockSize를 5로 잡으면 될까?
			
			if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
			} else {
				pageBar += "<li class='page-item'><a class='page-link' href='eventOrderList.tea?currentShowPageNo="+pageNo+"&snum="+snum+"&cnum="+cnum+"&order="+order+"'>"+pageNo+"</a></li>";
			}
			
			loop++;   
			pageNo++; 
		} // end of while( loop > blockSize )
		
		if( pageNo <= totalPage ) {  // 계속 다음을 누르면 22페이지가 나오게 되는데 없는 번호를 누르면 1페이지로 보내주기 때문에 마지막 페이지(totalPage 보다 작아질 때)에서는 다음 버튼을 막아주어야 한다.
			pageBar += "<li class='page-item'><a class='page-link' href='eventOrderList.tea?currentShowPageNo="+pageNo+"&snum="+snum+"&cnum="+cnum+"&order="+order+"'>></a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='eventOrderList.tea?currentShowPageNo="+totalPage+"&snum="+snum+"&cnum="+cnum+"&order="+order+"'>>></a></li>";
		} 
		
		request.setAttribute("currentShowPageNo", currentShowPageNo);
		request.setAttribute("pageBar", pageBar);
		request.setAttribute("cnum", cnum);
		request.setAttribute("snum", snum);
		request.setAttribute("order", order);

		// *** 페이지바 만들기 끝 *** //

		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/product_list_event.jsp");
	
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
