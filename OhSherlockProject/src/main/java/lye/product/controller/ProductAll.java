package lye.product.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import common.model.ProductVO;
import lye.product.model.*;

public class ProductAll extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// *** 카테고리번호에 해당하는 제품들을 페이징 처리하여 보여주기 *** //
		String currentShowPageNo = request.getParameter("currentShowPageNo");  // 선택받아온 currentShowPageNo(몇 페이지)
		// currentShowPageNo 은 사용자가 보고자하는 페이지바의 페이지번호 이다.
        // 카테고리 메뉴에서 카테고리명만을 클릭했을 경우에는 currentShowPageNo 은 null 이 된다.
        // currentShowPageNo 이 null 이라면 currentShowPageNo 을 1 페이지로 바꾸어야 한다.
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1";  // 회원전체목록 페이지의 기본값을 1 페이지로 줌.
		}
		
		try {
			if(Integer.parseInt(currentShowPageNo) < 1) {  // 기본이 String 타입이므로 숫자(int) 타입으로 바꿔준다. 또한, 0 페이지 이하는 없으므로 만약 get 방식으로 0 페이지 이하가 들어갈 경우
				currentShowPageNo = "1";  // 기본값을 1페이지로 보여준다.
			}   
		} catch(NumberFormatException e) {   // 만약 get 방식으로 문자가 들어갈 경우(예: sfsdf) 또는 int 범위를 초과한 숫자를 입력한 경우(예: 30억번째 페이지 => 3000000000)
			currentShowPageNo = "1";  // 기본값을 1페이지로 보여준다.
		}
		
		Map<String, String> paraMap = new HashMap<>();
		
		// 한 페이지당 화면상에 보여줄 제품의 개수는 6으로 한다. sizePerPage 는 ProductDAO 에서 상수로 설정해 두었음.
		paraMap.put("currentShowPageNo", currentShowPageNo);  // 기본값이 1 페이지. 단, 정렬조건을 선택할때마다 매번 바뀔 것이므로 currentShowPageNo 로 변수처리함.
		
		InterProductDAO pdao = new ProductDAO();
		
		// 페이지바를 만들기 위해서 특정 카테고리의 제품개수에 대한 총페이지수 알아오기
		int totalPage = pdao.getTotalPage();
		// System.out.println("~~~ 확인용 totalPage => " + totalPage);
		
		if( Integer.parseInt(currentShowPageNo) > totalPage ) { // GET 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 토탈페이지수 보다 큰 값을 입력하여 장난친 경우에는 1페이지로 가게끔 막아주는 것 시작
			currentShowPageNo = "1";   // 기본값인 1 페이지로 이동하도록 하여 사용자가 url 에서 장난치지 못하도록 막아둔다.
			paraMap.put("currentShowPageNo", currentShowPageNo);  // 그리고 paraMap 에 다시 변경된 "currentShowPageNo" 을 넣어준다.
		}
		
		List<ProductVO> productList = pdao.selectPagingProduct(paraMap);  // mdao 를 통해 paraMap 을  MemberDAO 클래스의 selectPagingMember() 메소드에 넘겨준다.
		
		request.setAttribute("productList", productList);    //  키값 "productList" 에 저장하여 productList.jsp 로 넘겨준다. 그럼 .jsp 파일에서 mvo 를 통해 하나씩 받아온다.
		
		// ***** ====== 페이지바 만들기 시작 ====== ***** //
		String pageBar = "";  // 만약 3 페이지를 보고 싶다면 1 2 3 4 5 6 7 8 9 10 페이지바를 보여줘서 memberList.jsp 에 있는 ${requestScope.pageBar} 로 보내준다.

		int blockSize = 10;
		// blockSize 는 블럭(토막)당 보여지는 페이지 번호의 개수이다.
		
		int loop = 1;
		// loop 는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다. => 지금은 10씩 증가?
		
		// !!!! 다음은 pageNo 를 구하는 공식이다ㅣ. !!!! //
		int pageNo  = ( (Integer.parseInt(currentShowPageNo) - 1)/blockSize ) * blockSize + 1;  // currentShowPageNo 는 get 방식으로 넘어옴.
		// pageNo 는 페이지바에서 보여지는 첫번째 번호이다.  예: 1/ 11/ 21 .....
		
		
		// **** [맨처음][이전] 만들기 **** //
		if(pageNo != 1) {  // pageNo 가 1 이 아닌  11, 21, ... 일때만 [맨처음][이전] 버튼이 나온다.
			pageBar += "<li class='page-item'><a class='page-link' href='productAll.tea?currentShowPageNo=1'>[맨처음]</a></li>";      // [맨처음] 은 무조건 1 페이지를 보여줌.  // sizePerPage 는 없고 한페이지당 무조건 10개씩 보여준다.
			pageBar += "<li class='page-item'><a class='page-link' href='productAll.tea?currentShowPageNo="+(pageNo-1)+"'>[이전]</a></li>"; // [이전] 은 현재페이지 pageNo 보다 -1 되어야 함.
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {  // loop 는 10번 반복한다. loop 가 11 이상이 되면 페이지가 넘어간다. 즉, 11 > 10 와 같이 되면 페이지가 넘어간다. 단, 마지막 21 페이지 블럭에서는 loop 가 10번 반복하면 안되고 totalPage 인 21 페이지에서 멈춰야하기 때문에 || pageNo > totalPage 를 해준다. 만약 || pageNo > totalPage 를 안해주면 22페이지가 없어도 21 ~ 30 페이지까지 페이지바가 나타난다. 
			
			if( pageNo == Integer.parseInt(currentShowPageNo) ) {   //  currentShowPageNo 는 String 타입
				pageBar += "<li class='page-item active'> <a class='page-link' href='#'>"+pageNo+"</a> </li>";  // a 링크(url 변경) // class 속성은 부트스트랩을 준 것임.  active 는 페이지바에서 현재페이지에 배경색이 깔리는 부트스트랩 속성임.  // href='#' 는 현재 보고있는 페이지(자기페이지)로 이동함.
			}
			else {
				pageBar += "<li class='page-item'><a class='page-link' href='productAll.tea?currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";   // href='memberList.up?sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"' 는 다른 페이지로 이동함.
			}
			
			loop++;   //  1  2  3  4  5  6  7  8  9 10 => 첫번째 블럭
			
			pageNo++; //  1  2  3  4  5  6  7  8  9 10
			          // 11 12 13 14 15 16 17 18 19 20
					  // 21
					  // 위의 것은 sizePerPage 가 10 일때 페이지바이다.
			
		}// end of while-----------
		
		if( pageNo <= totalPage ) {  // 페이지가 totalPage 21페이지와 같거나 작을때만 페이지바에 [다음] 이 나오고, 페이지가 totalPage 21페이지보다 큰 경우에는 [다음] 이 나오지 않는다.
			                         // 즉, 마지막페이지 pageNo == 21 일때, while 문을 빠져나오면 pageNo++; 로인해 22 가 된다. 즉 totalPage 21페이지보다 큰 경우이므로 [다음] 이 나오지 않는다.
			pageBar += "<li class='page-item'><a class='page-link' href='productAll.tea?currentShowPageNo="+pageNo+"'>[다음]</a></li>";
			pageBar += "<li class='page-item'><a class='page-link' href='productAll.tea?currentShowPageNo="+totalPage+"'>[마지막]</a></li>"; // totalPage 페이지가 마지막 페이지임.
		}
		
		request.setAttribute("pageBar", pageBar);
		request.setAttribute("currentCatePage", "all"); // 현재 카테고리 페이지(전체)
		
		// ***** ====== 페이지바 만들기 끝 ====== ***** //
		
	//	super.setRedirect(false);
		super.setViewPage("/WEB-INF/product/product_list_tea.jsp");
				
			
	}

}
