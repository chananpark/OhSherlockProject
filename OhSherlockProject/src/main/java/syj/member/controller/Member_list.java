package syj.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import syj.member.model.InterMemberDAO;
import syj.member.model.MemberDAO;
import common.model.*;

public class Member_list extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// url을 알아내서 접속할 수도 있기 때문에 로그인 없이 들어올 수 없도록 막아주어야 한다.
		
		if( !super.checkLogin(request) ) {
			// == 로그인을 안한 상태로 들어왔을 때는 접근을 못하게 막는다. == //
			String message = "회원 목록 조회를 위해서는 로그인을 해주세요.";
	        String loc = "javascript:history.back()";
	        
	        request.setAttribute("message", message);
	        request.setAttribute("loc", loc);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
	        
		} else {

			HttpSession session =  request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			if( !( "admin".equals(loginuser.getUserid()) ) ) {
				// == 관리자(admin) 가 아닌 일반 사용자로 로그인 했을 때는 조회가 불가능 하도록 한다. == //
				String message = "관리자 이외에는 접근이 불가합니다.";
		        String loc = "javascript:history.back()";
		        
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		        
		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
			
			} else {
				// == 관리자(admin) 로 로그인 했을 때만 조회가 가능하도록 한다. == //
				
				InterMemberDAO mdao = new MemberDAO();
				Map<String, String> paraMap = new HashMap<>();
				
				// *** 페이징 처리를 한 모든 회원 또는 검색한 회원 목록 보여주기 *** //
				// 검색 조건이 있을 수도 있고 검색 조건이 없을 수도 있다
				
				String searchType = request.getParameter("searchType"); // form 태그로 보내준 것의 name이 searchType 인 것을 받아왔다
				String searchWord = request.getParameter("searchWord"); // form 태그로 보내준 것의 name
				
				paraMap.put("searchType", searchType); // dao 로 보내기 위해서 맵에 다 담아준다.
				paraMap.put("searchWord", searchWord); // 이거는 검색어, 검색어는 있을 수도 있고 없을수도 있다
				
				
				String sizePerPage = request.getParameter("sizePerPage");
				// 한 페이지당 화면상에 보여줄 회원의 개수
		        // 메뉴에서 회원목록 만을 클릭했을 경우에는 sizePerPage 는 null 이 된다.
		        // sizePerPage 가 null 이라면 sizePerPage 를 10 으로 바꾸어야 한다.
		        // "10" or "5" or "3" 
				
			//	System.out.println("sizePerPage : " + sizePerPage);
			//	System.out.println("sizePerPage : " + sizePerPage.length()); // 글자가 null 이 아니라, nullPointException 에서의 null 이다. url 에서 null 을 입력하면 이건 문자로서의 null
				
				if( sizePerPage == null  ||  
					!("10".equals(sizePerPage) || "30".equals(sizePerPage) || "50".equals(sizePerPage) ) ) { // sizePerPage가 null 이거나 url에서 장난질 쳤을 경우에는 기본값인 10을 준다.
					sizePerPage = "10";
				}
				
				String currentShowPageNo = request.getParameter("currentShowPageNo");
				// currentShowPageNo 은 사용자가 보고자하는 페이지바의 페이지번호 이다.
		        // 메뉴에서 회원목록 만을 클릭했을 경우에는 currentShowPageNo 은 null 이 된다.
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
				
				paraMap.put("sizePerPage", sizePerPage); // 한 페이지에 몇개씩 볼지, 기본 값은 10개씩 보고 이 숫자는 계속 변하게 된다.
				paraMap.put("currentShowPageNo", currentShowPageNo); // 1페이지 볼거냐 2페이지 볼거냐, 뒤의 숫자는 계속 변경 
				
				// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 전체 회원에 대한 총 페이지 알아오기
				int totalPage = mdao.getTotalPage(paraMap); 
				// 전체 몇 페이지가 나올지를 알아야하는데, map에 다 담아서 작업해줄 것
				// 이름에 '유'가 포함된 사람이 152명이라면 페이지바가 또 달라지게 된다.
				// 모든 회원수가 필요한 게 아니라, 검색해서 알아오는 경우도 필요하기 때문에 map 에 담아주는 것이다.
				// 따라서 map 에는 검색 컬럼이 뭔지 알고, 검색어도 알아서 보내야 한다. map 에서 보고싶은 것만 꺼내오면 되기 때문이다.
			//	System.out.println("확인용 totalPage : "+totalPage);
				
				// == get 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 토탈페이지수 보다 큰 값을 입력하여 장난친 경우에는 1페이지로 가게끔 막아주는 것 시작
				// pageBar 가 만일 20,21이 끝일 때 22페이지는 없기 때문에 url에서 장난질을 친 것이다. 
				// 이렇게 없는 페이지를 url 에서 장난질 쳤을 경우에는 아래와 같이 해준다.
				if( Integer.parseInt(currentShowPageNo) > totalPage ) {
					currentShowPageNo = "1"; // 없는 페이지로 장난질 칠 때는 무조건 1을 보여준다.
					paraMap.put("currentShowPageNo", currentShowPageNo); // url에 장난질 쳤을 경우에는 1로 바뀐 값을 담아 준다.
					
				}
				// == get 방식이므로 사용자가 웹브라우저 주소창에서 currentShowPageNo 에 토탈페이지수 보다 큰 값을 입력하여 장난친 경우에는 1페이지로 가게끔 막아주는 것 끝
				
				List<MemberVO> memberList = mdao.selectPagingMember(paraMap);
				
				// 확인용 시작 ==
				/*
				if(memberList.size() > 0) {
					for(MemberVO mvo : memberList) {
						System.out.println(mvo.getUserid() + " " + mvo.getName() );
					}
				}
				*/
				// 확인용 끝 ==
					
				// 한페이지에 출력할 회원명 수
				request.setAttribute("sizePerPage", sizePerPage); // 받아온 sizePerPage 를 다시 view 단으로 넘겨주어야만, select 값이 변하지 않고 유지되게 된다.
				request.setAttribute("memberList", memberList);
				
				// *** 페이지바 만들기 시작 *** //
				
					/*
		             1개 블럭당 10개씩 잘라서 페이지 만든다.  // 1 2 3 4 5 6 7 8 9 10 이게 한 블럭
		             1개 페이지당 3개행 또는 5개행 또는  10개행을 보여주는데
		                 만약에 1개 페이지당 5개행을 보여준다라면 
		                 총 몇개 블럭이 나와야 할까? 
		                 총 회원수가 207명 이고, 1개 페이지당 보여줄 회원수가 5 이라면
		             207/5 = 41.4 ==> 42(totalPage)        
		                 
		             1블럭               1 2 3 4 5 6 7 8 9 10 [다음][마지막]
		             2블럭   [맨처음][이전] 11 12 13 14 15 16 17 18 19 20 [다음][마지막]
		             3블럭   [맨처음][이전] 21 22 23 24 25 26 27 28 29 30 [다음][마지막]
		             4블럭   [맨처음][이전] 31 32 33 34 35 36 37 38 39 40 [다음][마지막]
		             5블럭   [맨처음][이전] 41 42 
		          */
		         
		         // ==== !!! pageNo 구하는 공식 !!! ==== // 
			      /*
			          1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은  1 이다.
			          11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.   
			          21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
			          
			           currentShowPageNo        pageNo  ==> ( (currentShowPageNo - 1)/blockSize ) * blockSize + 1 
			          ---------------------------------------------------------------------------------------------
			                 1                   1 = ( (1 - 1)/10 ) * 10 + 1 			
			                 2                   1 = ( (2 - 1)/10 ) * 10 + 1 			// 자바이기 때문에 몫만 나온다. 
			                 3                   1 = ( (3 - 1)/10 ) * 10 + 1 			// 공식에 의해서 pageNo 는 무조건 1이 나오게 된다.
			                 4                   1 = ( (4 - 1)/10 ) * 10 + 1  
			                 5                   1 = ( (5 - 1)/10 ) * 10 + 1 			// 이 블럭에서 아무 숫자나 클릭하든 공식에 의해서 pageNo는 1이 나온다.
			                 6                   1 = ( (6 - 1)/10 ) * 10 + 1 			// 7 페이지를 눌러도 1~10이라면 pageNo이 1 이기 때문에 1 ~ 10 까지만 화면에 나와야 한다.
			                 7                   1 = ( (7 - 1)/10 ) * 10 + 1 
			                 8                   1 = ( (8 - 1)/10 ) * 10 + 1 			// 그렇게 반복된 1~10까지를 pageBar 에 담에서 view 단에 보내준다.
			                 9                   1 = ( (9 - 1)/10 ) * 10 + 1 			// 마지막 페이지의 경우에는 전체 41~50까지 하는 게 아니라, 남아있는 멤버 만큼만 보여준다.
			                10                   1 = ( (10 - 1)/10 ) * 10 + 1 
			                 
			                11                  11 = ( (11 - 1)/10 ) * 10 + 1 
			                12                  11 = ( (12 - 1)/10 ) * 10 + 1
			                13                  11 = ( (13 - 1)/10 ) * 10 + 1
			                14                  11 = ( (14 - 1)/10 ) * 10 + 1
			                15                  11 = ( (15 - 1)/10 ) * 10 + 1
			                16                  11 = ( (16 - 1)/10 ) * 10 + 1
			                17                  11 = ( (17 - 1)/10 ) * 10 + 1
			                18                  11 = ( (18 - 1)/10 ) * 10 + 1 
			                19                  11 = ( (19 - 1)/10 ) * 10 + 1
			                20                  11 = ( (20 - 1)/10 ) * 10 + 1
			                 
			                21                  21 = ( (21 - 1)/10 ) * 10 + 1 
			                22                  21 = ( (22 - 1)/10 ) * 10 + 1
			                23                  21 = ( (23 - 1)/10 ) * 10 + 1
			                24                  21 = ( (24 - 1)/10 ) * 10 + 1
			                25                  21 = ( (25 - 1)/10 ) * 10 + 1
			                26                  21 = ( (26 - 1)/10 ) * 10 + 1
			                27                  21 = ( (27 - 1)/10 ) * 10 + 1
			                28                  21 = ( (28 - 1)/10 ) * 10 + 1 
			                29                  21 = ( (29 - 1)/10 ) * 10 + 1
			                30                  21 = ( (30 - 1)/10 ) * 10 + 1                    
		
			       */
				
				String pageBar = "";
				
				int blockSize = 5; // blockSize 는 블럭(토막) 당 보여지는 페이지 번호의 개수이다.
				
				int loop = 1; // loop 는 1부터 증가하여 1개 블럭을 이루는 페이지 번호의 개수(지금은 10개, 1~10, 11~20 ) 까지만 증가하는 용도이다.
				
				// !!! 다음은 pageNo를 구하는 공식이다. !!! //
				int pageNo = ( (Integer.parseInt(currentShowPageNo)- 1) / blockSize ) * blockSize + 1; // pageNo는 페이지바에서 보여지는 첫번째 번호이다.
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				// === 페이지바를 만들 때 조건을 하나 달아주어야한다. === //
				
				if( searchType == null) {
				searchType = ""; // searchType이 null인 경우에는 기본으로 name 이 들어오도록 잡아준다. 여기다가 타입의 name을 적으면  해당하는 것을 기본으로 세팅
				}
				
				if( searchWord == null) {
				searchWord = "";
				}
				
				// 내가 검색어로 입력한 값을 그대로 유지해주기 
				// view 단 페이지에서 내가 입력한 검색값 그대로 유지해주기
				request.setAttribute("searchType", searchType);
				request.setAttribute("searchWord", searchWord);
				////////////////////////////////////////////////////
				
				// ***** 맨처음/이전 만들기 ***** //
				if( pageNo != 1 ) {  
					// 맨처음으로 가기는 pageNo가 1이 아닐 때만 나오면 된다.
					pageBar += "<li class='page-item'><a class='page-link' href='member_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo=1&searchType="+searchType+"&searchWord="+searchWord+"'><<</a></li>";
					pageBar += "<li class='page-item'><a class='page-link' href='member_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+(pageNo-1)+"&searchType="+searchType+"&searchWord="+searchWord+"'><</a></li>";
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
						pageBar += "<li class='page-item'><a class='page-link' href='member_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"&searchType="+searchType+"&searchWord="+searchWord+"'>"+pageNo+"</a></li>";
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
					pageBar += "<li class='page-item'><a class='page-link' href='member_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"&searchType="+searchType+"&searchWord="+searchWord+"'>></a></li>";
					pageBar += "<li class='page-item'><a class='page-link' href='member_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+totalPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>>></a></li>";
					// 다음은 11페이지가 나와야 하고 while 문 빠져나온 다음에 pageNo는 11이 되어 있다. 다음을 클릭하면 currentShowPageNo 가 11이다. 
					// 글자는 다음이지만 11 페이지를 보여주어야 한다.
				}
				
				request.setAttribute("pageBar", pageBar);
				
				// *** 페이지바 만들기 끝 *** //

				super.setRedirect(false);
				super.setViewPage("/WEB-INF/admin/member_list.jsp");
				
				
			} // end of if(!( "admin".equals(loginuser.getUserid()) ))-else 
		}

	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
