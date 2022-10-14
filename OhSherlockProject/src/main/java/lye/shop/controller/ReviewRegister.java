package lye.shop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.ReviewVO;
import lye.shop.model.InterProductDAO;
import lye.shop.model.ProductDAO;
import my.util.MyUtil;

public class ReviewRegister extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String subject = request.getParameter("review_subject");
		String content = request.getParameter("review_content");
		String score = request.getParameter("review_score");
		String userid = request.getParameter("userid");
		String pnum = request.getParameter("pnum");
		
		// 입력한 내용에서 엔터는 <br>로 변환시키기
		content = content.replaceAll("\r\n","<br>");
		content = content.replaceAll("<", "&lt;");
		content = content.replaceAll(">", "&gt;");
		
		ReviewVO rvo = new ReviewVO();
		rvo.setRsubject(subject);   // rvo 로부터 제목 불러오기
		rvo.setRcontent(content);   // rvo 로부터 내용 불러오기
		rvo.setScore(Integer.parseInt(score)); // rvo 로부터 평점 불러오기
		rvo.setUserid(userid);                 // rvo 로부터 사용자id 불러오기
		rvo.setPnum(Integer.parseInt(pnum));   // rvo 로부터 제품번호 불러오기
		
		InterProductDAO pdao = new ProductDAO();
		
		int n = pdao.addProductReview(rvo);
		
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("n", n);  // 키값 n 은 0(실패) 또는 1(성공)
		//System.out.println("n :" +n);
		
		String json = jsonObj.toString();  // "{"n":1}" 또는 "{"n":0}"
		
		request.setAttribute("json", json);
		
	//  super.setRedirect(false);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		
	
	}

}
