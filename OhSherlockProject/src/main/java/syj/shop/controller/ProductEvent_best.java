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

public class ProductEvent_best extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 카테고리 목록을 조회하기
		super.getEventCategoryList(request);
		
		// *** 카테고리 번호에 해당하는 제품들을 페이징처리하여 보여주기 *** //
		String currentShowPageNo = request.getParameter("currentShowPageNo");
		// currentShowPageNo 은 사용자가 보고자하는 페이지바의 페이지번호 이다.
        // 카테고리 메뉴에서 카테고리 명만 클릭했을 경우에는 currentShowPageNo 은 null 이 된다.
        // currentShowPageNo 이 null 이라면 currentShowPageNo 을 1 페이지로 바꾸어야 한다.
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

		InterProductDAO pdao = new ProductDAO();
		
		// 페이지바를 위한 검색이 없는 특정 카테고리 상품에 대한 총 페이지 알아오기
		int totalPage = pdao.getTotalBestPage(paraMap); 
		// System.out.println("확인용totalpage : " + totalPage);
		
		// == get 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 토탈페이지수 보다 큰 값을 입력하여 장난친 경우에는 1페이지로 가게끔 막아주는 것 시작
		// pageBar 가 만일 20,21이 끝일 때 22페이지는 없기 때문에 url에서 장난질을 친 것이다. 
		// 이렇게 없는 페이지를 url 에서 장난질 쳤을 경우에는 아래와 같이 해준다.
		if( Integer.parseInt(currentShowPageNo) > totalPage ) {
			currentShowPageNo = "1"; // 없는 페이지로 장난질 칠 때는 무조건 1을 보여준다.
			paraMap.put("currentShowPageNo", currentShowPageNo); // url에 장난질 쳤을 경우에는 1로 바뀐 값을 담아 준다.
			
		}
		// == get 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 토탈페이지수 보다 큰 값을 입력하여 장난친 경우에는 1페이지로 가게끔 막아주는 것 끝
		
		List<ProductVO> productList = pdao.selectProdByEventBest(paraMap);
		
		// 확인용 시작 ==
		/*
		if(productList.size() > 0) {
			for(ProductVO pvo : productList) {
				System.out.println(pvo.getPnum() + " " + pvo.getPname() );
			}
		}
		*/
		// 확인용 끝 ==
		
		// 한페이지에 출력할 상품 수
		request.setAttribute("productList", productList);
		
		// *** 페이지바 만들기 시작 *** //
		String pageBar = "";
		
		int blockSize = 5; // blockSize 는 블럭(토막) 당 보여지는 페이지 번호의 개수이다.
		
		int loop = 1; // loop 는 1부터 증가하여 1개 블럭을 이루는 페이지 번호의 개수(지금은 10개, 1~10, 11~20 ) 까지만 증가하는 용도이다.
		
		// !!! 다음은 pageNo를 구하는 공식이다. !!! //
		int pageNo = ( (Integer.parseInt(currentShowPageNo)- 1) / blockSize ) * blockSize + 1; // pageNo는 페이지바에서 보여지는 첫번째 번호이다.
		
		// ***** 맨처음/이전 만들기 ***** //
		if( pageNo != 1 ) {  
			// 맨처음으로 가기는 pageNo가 1이 아닐 때만 나오면 된다.
			pageBar += "<li class='page-item'><a class='page-link' href='productEvent_best.tea?currentShowPageNo=1'>[맨처음]</a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='productEvent_best.tea?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>";
			// 이전으로 가는 페이지넘버는 페이지넘버보다 하나가 작아야하기 때문에 -1 을 해준다.
		} 
		
		while( !(loop > blockSize || pageNo > totalPage) ) { // 10번을 반복한 다음에 11이 되면 그대로 빠져나간다. 페이지바가 한 세트당 10개만 찍어줄 것이기 때문. 만일 1-5까지만 보여줄 거면 blockSize를 5로 잡으면 될까?
			
			if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
				// 내가 클릭한 페이지넘버와 내가 보고자한 페이지넘버와 같을 경우
				pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
				// 자기가 자기한테 가야하기 때문에 상대경로 이다.
				// active 를 하면 바탕색이 파랗게 깔리게 된다.
				// 자기자신을 클릭했을 경우에는, 위치이동이 없기 때문에 클릭해도 자기 자신이 있는 페이지가 나온다.
			} else {
				pageBar += "<li class='page-item'><a class='page-link' href='productEvent_best.tea?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
			}
			
			loop++;   //  1  2  3  4  5  6  7  8  9 10
			
			pageNo++; //  1  2  3  4  5  6  7  8  9 10 // 10번 반복해도 pageNo는 10이 맥시멈이다.
					  // 11 12 13 14 15 16 17 18 19 20 // 11을 쿨릭했을 경우에는 공식에 의해서 pageNo 가 11이 되고, 10번을 반복해서 pageNo 가 20이 되고 loop는 10번을 반복했기 때문에 반복문을 탈출한다. 
					  // 21							   // 다시 loop은 1이 되고 pageNo도 21을 찍어준 다음에 22가 되면 22>21 로 totalPage가 더 작아지기 때문에 loop 가 10번을 반복하지 않아도 반복문을 탈출하게 된다.
					  // 위의 것은 sizePerPage가 10일 때 페이지바 이다.
			// 어느페이지를 클릭을 하던 1~10까지는 pagdNo 가 1이 나오게 된다. 
			
			
		} // end of while( loop > blockSize )
		
		// ***** 다음/마지막 만들기 ***** //
		// 첫번째 블럭(1  2  3  4  5  6  7  8  9 10)인 경우 pageNo 10까지 찍어주고 11되는 순간 빠져나온다.
		// 두번째 블럭(11 12 13 14 15 16 17 18 19 20)인 경우 pageNo 20까지 찍어주고 21되는 순간 빠져나온다.
		// 세번째 블럭(21) 인 경우 pageNo 22가 된다.(while문 빠져나오는 순간의 값)
		
		if( pageNo <= totalPage ) {  // 계속 다음을 누르면 22페이지가 나오게 되는데 없는 번호를 누르면 1페이지로 보내주기 때문에 마지막 페이지(totalPage 보다 작아질 때)에서는 다음 버튼을 막아주어야 한다.
			// 제일 마지막 블럭은 페이지넘버가 토탈페이지보다 커버리면 안되고 그 전까지만 다음과 마지막이 나와야 한다.
			pageBar += "<li class='page-item'><a class='page-link' href='productEvent_best.tea?currentShowPageNo="+pageNo+"'>[다음]</a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='productEvent_best.tea?currentShowPageNo="+totalPage+"'>[마지막]</a></li>";
			// 다음은 11페이지가 나와야 하고 while 문 빠져나온 다음에 pageNo는 11이 되어 있다. 다음을 클릭하면 currentShowPageNo 가 11이다. 
			// 글자는 다음이지만 11 페이지를 보여주어야 한다.
		} 
		
		request.setAttribute("pageBar", pageBar);
		
		// *** 페이지바 만들기 끝 *** //
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/product_list_event.jsp");
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
