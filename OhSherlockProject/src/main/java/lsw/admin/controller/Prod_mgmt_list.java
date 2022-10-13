package lsw.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.ProductVO;
import lsw.admin.model.InterProductDAO;
import lsw.admin.model.ProductDAO;
import my.util.MyUtil;


public class Prod_mgmt_list extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

			if( !super.checkLogin(request) ) {
				// == 로그인을 안한 상태로 들어왔을 때는 접근을 못하게 막는다. == //
				String message = "상품 조회를 위해서는 로그인을 해주세요.";
		        String loc = "javascript:history.back()";
		        
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		        
		        super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
		        
			}
			else {

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
					
					InterProductDAO pdao = new ProductDAO();
					Map<String, String> paraMap = new HashMap<>();
					
					String searchWord = request.getParameter("searchWord"); 
					
					paraMap.put("searchWord", searchWord); 
					
					String sizePerPage = request.getParameter("sizePerPage");
					
					if( sizePerPage == null  ||  
						!("10".equals(sizePerPage) || "30".equals(sizePerPage) || "50".equals(sizePerPage) ) ) { 
						sizePerPage = "10";
					}
					
					String currentShowPageNo = request.getParameter("currentShowPageNo");
					if(currentShowPageNo == null) {
						currentShowPageNo = "1";
					}
					
					try {
						if(Integer.parseInt(currentShowPageNo) < 1) {
							currentShowPageNo = "1";  
						}
					} catch (NumberFormatException e) {
						currentShowPageNo = "1"; 
					}
					
					paraMap.put("sizePerPage", sizePerPage); 
					paraMap.put("currentShowPageNo", currentShowPageNo); 
					
					// 페이징 처리를 위한 검색이 있는 또는 검색이 없는 전체 회원에 대한 총 페이지 알아오기
					int totalPage = pdao.getTotalPage(paraMap); 
					
					if( Integer.parseInt(currentShowPageNo) > totalPage ) {
						currentShowPageNo = "1"; 
						paraMap.put("currentShowPageNo", currentShowPageNo); 
						
					}
					
					List<ProductVO> productList = pdao.selectPagingProduct(paraMap);
					
					// 한페이지에 출력할 회원명 수
					request.setAttribute("sizePerPage", sizePerPage); 
					request.setAttribute("productList", productList);
					
					// *** 페이지바 만들기 시작 *** //
					
					String pageBar = "";
					
					int blockSize = 5; 
					
					int loop = 1; 
					
					int pageNo = ( (Integer.parseInt(currentShowPageNo)- 1) / blockSize ) * blockSize + 1; 
					
					if( searchWord == null) {
					searchWord = "";
					}
					request.setAttribute("searchWord", searchWord);
					
					// ***** 맨처음/이전 만들기 ***** //
					if( pageNo != 1 ) {  
						pageBar += "<li class='page-item'><a class='page-link' href='prod_mgmt_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo=1&searchWord="+searchWord+"'><<</a></li>";
						pageBar += "<li class='page-item'><a class='page-link' href='prod_mgmt_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+(pageNo-1)+"&searchWord="+searchWord+"'><</a></li>";
					} 
					
					while( !(loop > blockSize || pageNo > totalPage) ) { 
						
						if( pageNo == Integer.parseInt(currentShowPageNo) ) { 
							pageBar += "<li class='page-item active'><a class='page-link' href='#'>"+pageNo+"</a></li>"; 
						} else {
							pageBar += "<li class='page-item'><a class='page-link' href='prod_mgmt_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"&searchWord="+searchWord+"'>"+pageNo+"</a></li>";
						}
						
						loop++;   
						
						pageNo++; 
						
					} // end of while( loop > blockSize )
					
					// ***** 다음/마지막 만들기 ***** //
					if( pageNo <= totalPage ) {  
						pageBar += "<li class='page-item'><a class='page-link' href='prod_mgmt_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+pageNo+"&searchWord="+searchWord+"'>></a></li>";
						pageBar += "<li class='page-item'><a class='page-link' href='prod_mgmt_list.tea?sizePerPage="+sizePerPage+"&currentShowPageNo="+totalPage+"&searchWord="+searchWord+"'>>></a></li>";
					}
					
					request.setAttribute("pageBar", pageBar);
					
					// *** 페이지바 만들기 끝 *** //
					
					// *** 현재 페이지를 돌아갈 페이지(goBackURL) 로 주소 지정하기 *** //
					String currentURL = MyUtil.getCurrentURL(request);
					currentURL = currentURL.replaceAll("&", " ");
					request.setAttribute("goBackURL", currentURL);

					super.setRedirect(false);
					super.setViewPage("/WEB-INF/admin/prod_mgmt_list.jsp");
				}
			}
		}
}