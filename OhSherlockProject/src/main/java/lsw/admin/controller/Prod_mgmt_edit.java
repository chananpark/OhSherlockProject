package lsw.admin.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.ProductVO;
import common.model.SpecVO;
import lsw.admin.model.InterProductDAO;
import lsw.admin.model.ProductDAO;

public class Prod_mgmt_edit extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		if( !super.checkLogin(request) ) {
			// == 로그인을 안한 상태로 들어왔을 때는 접근을 못하게 막는다. == //
			String message = "상품 수정을 위해서는 로그인을 해주세요.";
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
				
				String pnum = request.getParameter("pnum");

				InterProductDAO pdao = new ProductDAO();
				ProductVO product_select_one = pdao.product_list_detail(pnum);
				
				request.setAttribute("product_select_one", product_select_one);
				
				// 카테고리 목록을 조회해오기 
				List<HashMap<String, String>> categoryList = pdao.getCategoryList();
				request.setAttribute("categoryList", categoryList);
				
				// spec 목록을 보여주고자 한다.
				List<SpecVO> specList = pdao.selectSpecList();
				request.setAttribute("specList", specList);
				
			    //  *** 현재 페이지를 돌아갈 페이지(goBackURL)로 주소 지정하기 *** //
				String goBackURL = request.getParameter("goBackURL");
		//		System.out.println("확인용 : " + goBackURL); 

				request.setAttribute("goBackURL", goBackURL); // 공백이 있는 상태 그대로 전달해준다.
				
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/admin/prod_mgmt_edit.jsp");
				
			}
		}
	}

}
