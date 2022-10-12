package lye.shop.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import lye.shop.model.InterProductDAO;
import lye.shop.model.ProductDAO;

public class PageBarTeaJSON extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		InterProductDAO pdao = new ProductDAO();
	      
	      String currentShowPageNo = request.getParameter("currentShowPageNo");
	      String cnum = request.getParameter("cnum");
	      String snum = request.getParameter("snum");
	      
	      Map<String, String> paraMap = new HashMap<>();
	      
	      paraMap.put("cnum", cnum); // 카테고리번호
	      paraMap.put("snum", snum); // 스펙
	      
	      // 페이징처리를 위한 특정 카테고리 총페이지 알아오기
	      int totalPage = pdao.getTotalPage(paraMap);
	      
	      String pageBar = "";

	      int blockSize = 10;
	      // blockSize 블럭당 페이지 번호 개수

	      int loop = 1;

	      // 페이지블럭의 첫 페이지 구하기 공식
	      int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;
	      
	      // [맨처음][이전] 만들기
	      if (pageNo > 1) {
	         pageBar += "<li class='page-item'><button id='1' class='page-link ajaxPage move'><<</button></li>";            
	         pageBar += "<li class='page-item'><button id='"+(pageNo - 1)+"' class='page-link ajaxPage move'><</button></li>";
	      }
	      
	      //while( !(loop > blockSize || pageNo > totalPage)) {
	      while(loop <= blockSize && pageNo <= totalPage) {
	         
	         /*
	          * // 현재 페이지에 active 클래스 넣기 if (pageNo == Integer.parseInt(currentShowPageNo)) {
	          * pageBar += "<li class='page-item active'><button id='"
	          * +pageNo+"'class='page-link ajaxPage'>" + pageNo + "</button></li>"; } else
	          */
	            pageBar += "<li class='page-item'><button id='"+pageNo+"' class='page-link ajaxPage'>" + pageNo + "</button></li>";
	         
	         loop++;
	         pageNo++;
	      }
	      
	      // [다음][마지막] 만들기
	      if (pageNo <= totalPage) {
	         pageBar += "<li class='page-item'><button id='"+pageNo+"' class='page-link ajaxPage move'>></button></li>";
	         pageBar += "<li class='page-item'><button id='"+totalPage+"' class='page-link ajaxPage move'>>></button></li>";            
	      }
	      
	      JSONObject jsonObj = new JSONObject();
	      jsonObj.put("pageBar", pageBar);   
	      
	      String json = jsonObj.toString();
	      
	      request.setAttribute("json", json);
	      super.setViewPage("/WEB-INF/jsonview.jsp");
		
	}

}
