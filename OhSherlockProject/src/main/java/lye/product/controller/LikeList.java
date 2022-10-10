package lye.product.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import common.model.LikeVO;
import common.model.MemberVO;
import lye.product.model.InterProductDAO;
import lye.product.model.ProductDAO;

public class LikeList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		// 카테고리 목록을 조회해오기
		super.getCategoryList(request);
		
		// 찜목록은 반드시 해당사용자가 로그인을 해야만 볼 수 있다. 부모클래스에서 로그인 유무 알아오기.
		boolean isLogin = super.checkLogin(request);
		
		if(!isLogin) { // 로그인을 하지 않은 상태이라면
			
			request.setAttribute("message", "찜목록은 로그인 후 이용 가능합니다.");
			request.setAttribute("loc", request.getContextPath() + "/login/login.tea");
			
			// super.setRedirect(false);
	        super.setViewPage("/WEB-INF/msg.jsp");
			
			return; // 종료
		}
		else {  // 로그인한 상태라면
			// 찜목록은 페이징처리 안함.
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			InterProductDAO pdao = new ProductDAO();
			List<LikeVO> likeList = pdao.selectProductLike(loginuser.getUserid()); 
			
			request.setAttribute("likeList", likeList); // 찜목록(pdao 에서 넘겨준 것)
			
		    // super.setRedirect(false);
			super.setViewPage("/WEB-INF/mypage/like_list.jsp"); // likeList 를 담아서 LikeList.jsp 에 넘겨준다.
			
		}
		
	}

}
