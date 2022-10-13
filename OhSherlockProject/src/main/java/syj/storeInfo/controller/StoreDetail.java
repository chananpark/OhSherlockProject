package syj.storeInfo.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class StoreDetail extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 로그인 또는 로그아웃을 하면 시작페이지로 가는 것이 아니라 방금 보았던 그 페이지로 그대로 가기 위한 것임. 
		super.goBackURL(request);
		
		String no = request.getParameter("no");
		
		if("1".equals(no)) {
			request.setAttribute("no", no);
			request.setAttribute("type", "티하우스");
			request.setAttribute("name", "서울 서교동 쌍용본점");
			request.setAttribute("address", "서울특별시 마포구 서교동 447-5");
			request.setAttribute("call", "02-336-8546");
		} else if("2".equals(no)) {
			request.setAttribute("no", no);
			request.setAttribute("type", "티뮤지엄");
			request.setAttribute("name", "제주도 한라산 오름점");
			request.setAttribute("address", "제주특별자치도 서귀포시 안덕면 창천리 564 제주특별자치도");
			request.setAttribute("call", "064-794-5312");
		} else if("3".equals(no)) {
			request.setAttribute("no", no);
			request.setAttribute("type", "면세점");
			request.setAttribute("name", "프랑스 파리 에펠탑점");
			request.setAttribute("address", "Champ de Mars, 5 Av. Anatole France, 75007 Paris");
			request.setAttribute("call", "+ 33 7 66 89 27 49");
		} else if("4".equals(no)) {
			request.setAttribute("no", no);
			request.setAttribute("type", "백화점");
			request.setAttribute("name", "미국 뉴욕 센트럴파크점");
			request.setAttribute("address", "Manhattan, New York City, United States");
			request.setAttribute("call", "+1 212-310-6600");
		}
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/storeInfo/storeDetail.jsp");
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
