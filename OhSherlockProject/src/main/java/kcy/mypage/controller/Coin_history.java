package kcy.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import kcy.mypage.model.CoinVO;
import kcy.mypage.model.InterMemberDAO;
import kcy.mypage.model.MemberDAO;

public class Coin_history extends AbstractController {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// url을 알아내서 접속할 수도 있기 때문에 로그인 없이 들어올 수 없도록 막아주어야 한다.

		if( !super.checkLogin(request) ) {
			// == 로그인을 안한 상태로 들어왔을 때는 접근을 못하게 막는다. == //
			String message = "예치금내역 조회를 위해서는 로그인을 해주세요.";
	        String loc = "javascript:history.back()";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
//	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
	        
		} else {
				// == 본인이 로그인 했을 때만 조회가 가능하도록 한다. == //
				
				InterMemberDAO mdao = new MemberDAO();
				Map<String, String> paraMap = new HashMap<>();
				
				// *** 페이징 처리한 목록 보여주기 *** //
				
				String sizePerPage = request.getParameter("sizePerPage");
				
				if( sizePerPage == null  ||  
						!("10".equals(sizePerPage) || "30".equals(sizePerPage) || "50".equals(sizePerPage) ) ) { // sizePerPage가 null 이거나 url에서 장난질 쳤을 경우에는 기본값인 10을 준다.
						sizePerPage = "10";
					}
				
				String currentShowPageNo = request.getParameter("currentShowPageNo");

				if(currentShowPageNo == null) {
					currentShowPageNo = "1";
				}
				
				
				try {
					if(Integer.parseInt(currentShowPageNo) < 1) {
						currentShowPageNo = "1";  // 0과 음수로 들어온다면 1페이지를 보여준다.
					}
				} catch (NumberFormatException e) {
					currentShowPageNo = "1"; // integer로 바꿨는데 바뀌지 않는다면(url에 문자를 넣었다면), 그냥 1페이지를 보여준다.
				}
				
				paraMap.put("sizePerPage", sizePerPage); // 한 페이지에 몇개씩 볼지, 기본 값은 10개씩 보고 이 숫자는 계속 변하게 된다.
				paraMap.put("currentShowPageNo", currentShowPageNo); // 1페이지 볼거냐 2페이지 볼거냐, 뒤의 숫자는 계속 변경 
				
				// 페이징 처리 대한 총 페이지 알아오기
//				int totalPage = mdao.getTotalPage(paraMap); 
				
				
				List<CoinVO> coin_history = mdao.selectPagingCoin(paraMap);
				
				
				// 확인용 시작 ==
				/*
				if(coin_history.size() > 0) {
					for(CoinVO cvo : coin_history) {
						System.out.println(cvo.getFk_userid() + " " + cvo.getCoin_amount() ); 
					}
				}
				*/
				// 확인용 끝 ==
				
				// 한페이지에 출력할 예치금내역
				request.setAttribute("sizePerPage", sizePerPage); // 받아온 sizePerPage 를 다시 view 단으로 넘겨주어야만, select 값이 변하지 않고 유지되게 된다.
				request.setAttribute("coin_history", coin_history);
				
				
				
				String pageBar = "";
				
				int blockSize = 5; // blockSize 는 블럭(토막) 당 보여지는 페이지 번호의 개수이다.
				
				int loop = 1; // loop 는 1부터 증가하여 1개 블럭을 이루는 페이지 번호의 개수(지금은 10개, 1~10, 11~20 ) 까지만 증가하는 용도이다.
				
				// !!! 다음은 pageNo를 구하는 공식이다. !!! //
				int pageNo = ( (Integer.parseInt(currentShowPageNo)- 1) / blockSize ) * blockSize + 1; // pageNo는 페이지바에서 보여지는 첫번째 번호이다.
				
				// ***** 맨처음/이전 만들기 ***** //
				if( pageNo != 1 ) {  
					// 맨처음으로 가기는 pageNo가 1이 아닐 때만 나오면 된다.
					pageBar += "<li class='page-item'><a class='page-link' href='coin_history.tea?sizePerPage="+sizePerPage+"&currentShowPageNo=1'></a></li>";
					pageBar += "<li class='page-item'><a class='page-link' href='coin_history.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+(pageNo-1)+"'></a></li>";
					// 이전으로 가는 페이지넘버는 페이지넘버보다 하나가 작아야하기 때문에 -1 을 해준다.
				} 
				
				while( !(loop > blockSize) ) { // 10번을 반복한 다음에 11이 되면 그대로 빠져나간다. 페이지바가 한 세트당 10개만 찍어줄 것이기 때문. 만일 1-5까지만 보여줄 거면 blockSize를 5로 잡으면 될까?
					
					if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
						// 내가 클릭한 페이지넘버와 내가 보고자한 페이지넘버와 같을 경우
						pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
						// 자기가 자기한테 가야하기 때문에 상대경로 이다.
						// active 를 하면 바탕색이 파랗게 깔리게 된다.
						// 자기자신을 클릭했을 경우에는, 위치이동이 없기 때문에 클릭해도 자기 자신이 있는 페이지가 나온다.
					} else {
						pageBar += "<li class='page-item'><a class='page-link' href='coin_history.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>";
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
				
				
				
				request.setAttribute("pageBar", pageBar);
				
				
				
//				super.setRedirect(false);
				super.setViewPage("/WEB-INF/mypage/coin_history.jsp");
				
		  }
		
		
		
		
		
	   }// end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception----------
	
	
	
	
	
	
	
	
	}
	
	
	
	
	
	
	

