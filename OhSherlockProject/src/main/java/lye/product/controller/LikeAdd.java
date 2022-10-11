package lye.product.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import lye.product.model.InterProductDAO;
import lye.product.model.ProductDAO;

public class LikeAdd extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 로그인 유무 검사하기
		boolean isLogin = super.checkLogin(request);  // 부모클래스인 AbstractController 클래스에서 로그인 했는지 여부 알아오기.
		
		if(!isLogin) { // 로그인을 하지 않은 상태이라면
			
			/*
	            사용자가 로그인을 하지 않은 상태에서 특정제품을 찜목록에 담고자 하는 경우 
	            사용자가 로그인을 하면 찜목록에 담고자 했던 그 특정제품 페이지로 이동하도록 해야 한다.
	            이와 같이 하려고 ProdView 클래스에서 super.goBackURL(request); 을 해두었음.   
	        */
				
			request.setAttribute("message", "찜목록은 로그인 후 이용 가능합니다.");
			request.setAttribute("loc", request.getContextPath() + "/login/login.tea");
			
		//	super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
			return; // 종료
		}
		
		else {  // 로그인을 한 상태이라면
			// 찜목록 테이블(tbl_Like)에 해당 제품을 담아야 한다.
		    // 찜목록 테이블에 해당 제품이 존재하지 않는 경우에는 tbl_Like 테이블에 insert 를 해야하고, 
		    // 찜목록 테이블에 해당 제품이 존재하는 경우에 또 찜목록을 누르는 경우 tbl_Like 테이블에 delete 를 해야한다. 
			
			String method = request.getMethod();
		    
		   if("POST".equals(method)) {
				// POST 방식이라면
				String pnum = request.getParameter("pnum");  // 제품번호
				
				HttpSession session = request.getSession();  // 세션 객체생성
				MemberVO loginuser = (MemberVO) session.getAttribute("loginuser"); 
				   
				InterProductDAO pdao = new ProductDAO();  // ProductDAO 객체생성
				
				int n = pdao.addLike(loginuser.getUserid(), pnum);  // 어떤 회원의 아이디가 어떤제품을 가져왔는지 조회한다.
				
				if(n == 1) {  // insert 및 update 가 성공되어진다면
					request.setAttribute("message", "상품을 찜하였습니다. 찜목록으로 이동하시겠습니까?");
					request.setAttribute("loc", "likeList.tea");  // 
					// 찜목록은 마이페이지 통해서만 조회가능함.
					
				}
				else {
				    request.setAttribute("message", "상품 찜하기를 실패하였습니다.");
				    request.setAttribute("loc", "javascript:history.back()");  // 이전페이지로 이동
				}
				
			    // super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg_confirm.jsp");
				
				
			}
			else {
				// GET 방식이라면
				String message = "비정상적인 접근입니다.";
				String loc = "javascript:history.back()";  // 이전페이지로 이동
		         
		        request.setAttribute("message", message);
		        request.setAttribute("loc", loc);
		         
		        // super.setRedirect(false);
		        super.setViewPage("/WEB-INF/msg.jsp");
				
			}
			
		}
		
	}

}
