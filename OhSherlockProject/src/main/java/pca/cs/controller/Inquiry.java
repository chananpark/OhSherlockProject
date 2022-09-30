package pca.cs.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.InquiryVO;
import common.model.MemberVO;
import common.model.NoticeVO;
import my.util.MyUtil;
import pca.cs.model.InquiryDAO;
import pca.cs.model.InterInquiryDAO;
import pca.cs.model.InterNoticeDAO;
import pca.cs.model.NoticeDAO;

public class Inquiry extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		boolean isLogined = checkLogin(request);
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		// 로그인 했을때만 들어올 수 있음
		if(isLogined) {
			
			// get방식의 경우
			if("get".equalsIgnoreCase(method)) {
					super.setRedirect(false);
				// 사용자의 경우
				if(!loginuser.getUserid().equals("admin"))
					super.setViewPage("/WEB-INF/cs/inquiry.jsp");
				// 관리자의 경우
				else {
					// 현재 문의 리스트 보여줌
					
					InterNoticeDAO ndao = new NoticeDAO();
					Map<String, String> paraMap = new HashMap<>();
					
					String searchType = request.getParameter("searchType");
					String searchWord = request.getParameter("searchWord");
					
					paraMap.put("searchType", searchType);
					paraMap.put("searchWord", searchWord);
					
					// 한 페이지당 글 개수
					String sizePerPage = "7";
					
					// 현재 페이지 번호
					String currentShowPageNo = request.getParameter("currentShowPageNo");
					
					if (currentShowPageNo == null) {
						currentShowPageNo = "1";
					}
					
					try {
						if (Integer.parseInt(currentShowPageNo) < 1) {
							currentShowPageNo = "1";
						}

					} catch (NumberFormatException e) {
						currentShowPageNo = "1";
					}

					paraMap.put("sizePerPage", sizePerPage);
					paraMap.put("currentShowPageNo", currentShowPageNo);
					
					// 총 페이지 수 알아오기
					int totalPage = ndao.getTotalPage(paraMap);
					
					// currentShowPageNo에 totalPage보다 큰 값을 입력한 경우 1페이지로 가게함
					if (Integer.parseInt(currentShowPageNo) > totalPage) {
						currentShowPageNo = "1";
						paraMap.put("currentShowPageNo", currentShowPageNo);
					}
					
					List<NoticeVO> noticeList = ndao.showNoticeList(paraMap);
					request.setAttribute("noticeList", noticeList);
					
					String pageBar = "";

					int blockSize = 5;
					// blockSize 블럭(토막)당 보여지는 페이지 번호의 개수이다.

					int loop = 1;
					// loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수(지금은 10개)까지만 증가하는 용도이다.

					// !!!! 다음은 pageNo를 구하는 공식이다. !!!! //
					int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;
					// pageNo는 페이지바에서 보여지는 첫번째 번호이다.

					// 검색어가 없는 경우 searchType과 searchWord에는 아무글자도 없도록한다
					if (searchType == null) {
						searchType = "";
					}
					
					if (searchWord == null) {
						searchWord = "";
					}
					
					// 맨 첫 페이지와 이전 페이지 버튼
					if (pageNo > 1) {
						pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo=1&searchType="+searchType+"&searchWord="+searchWord+"'><<</a></li>";				
						pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo=" + (pageNo - 1) + "&searchType="+searchType+"&searchWord="+searchWord+"'><</a></li>";
					}
					
					// 페이지바
					while( !(loop > blockSize || pageNo > totalPage) ) {
						
						if( pageNo == Integer.parseInt(currentShowPageNo) ) { // currentShowPageNo는 String 타입이라서 변경
							// 선택한 페이지에 active 클래스
							pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; // 그래서 pageBar 에 반복해서 페이지를 쌓아준다.
						} else {
							pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo="+pageNo+"&searchType="+searchType+"&searchWord="+searchWord+"'>"+pageNo+"</a></li>";
						}
						
						loop++;
						pageNo++;
						
					} 
					
					// 다음 페이지와 맨 마지막 페이지 버튼
					if( pageNo <= totalPage ) { 
						pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo="+pageNo+"&searchType="+searchType+"&searchWord="+searchWord+"'>></a></li>";
						pageBar += "<li class='page-item'><a class='page-link' href='notice.tea?currentShowPageNo="+totalPage+"&searchType="+searchType+"&searchWord="+searchWord+"'>>></a></li>";
					}
					
					//
					String currentURL = MyUtil.getCurrentURL(request);
					request.setAttribute("goBackURL", currentURL);
					//
					
					request.setAttribute("pageBar", pageBar);
					request.setAttribute("searchType", searchType);
					request.setAttribute("searchWord", searchWord);
					
					
					super.setViewPage("/WEB-INF/admin/inquary_list_admin.jsp");
				}
			}
			// post방식의 경우
			else {
				String inquiry_type = request.getParameter("inquiry_type");
				String inquiry_subject = request.getParameter("inquiry_subject");
				String inquiry_content = request.getParameter("inquiry_content");
				inquiry_content = inquiry_content.replace("\r\n","<br>");
				String inquiry_email = request.getParameter("inquiry_email"); // 체크:on 미체크:null
				String inquiry_sms = request.getParameter("inquiry_sms"); // 체크:on 미체크:null
				
				InquiryVO ivo = new InquiryVO();
				InterInquiryDAO idao = new InquiryDAO();
				
				ivo.setFk_userid(loginuser.getUserid());
				ivo.setInquiry_type(inquiry_type);
				ivo.setInquiry_subject(inquiry_subject);
				ivo.setInquiry_content(inquiry_content);
				
				if(inquiry_email != null) {
					ivo.setInquiry_email(1);
				}else{
					ivo.setInquiry_email(0);
				}
				
				if(inquiry_sms != null) {
					ivo.setInquiry_sms(1);
				}else{
					ivo.setInquiry_sms(0);
				}
				
				int n = idao.makeInquiry(ivo);
				
				if (n==1) {
					// 글쓰기 성공 시
					// 마이페이지에서 1:1 문의내역 페이지로 이동시킨다.
					super.setRedirect(true);
					super.setViewPage(request.getContextPath() + "/mypage/inquiryList.tea");
				}
				else {
					// 실패 시 오류 페이지로 리다이렉트
					super.setRedirect(true);
					super.setViewPage(request.getContextPath() + "/error.up");
				}
				
			}
			
		} else {
			// 로그인 안했으면

			String message = "로그인이 필요한 메뉴입니다.";
			String loc = request.getContextPath() + "/login/login.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
