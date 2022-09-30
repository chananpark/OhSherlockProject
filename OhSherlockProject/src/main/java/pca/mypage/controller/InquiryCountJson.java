package pca.mypage.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.MemberVO;
import pca.cs.model.InquiryDAO;
import pca.cs.model.InterInquiryDAO;

public class InquiryCountJson extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		InterInquiryDAO idao = new InquiryDAO();
		HttpSession session = request.getSession();
		Map<String, String> paraMap = new HashMap<>();
		
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String userid = loginuser.getUserid();
		
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		paraMap.put("userid", userid);
		paraMap.put("startDate", startDate);
		paraMap.put("endDate", endDate);
		
		int total = idao.countInquiry(paraMap); // 문의내역 개수 알아오기
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("total", total);

		String json = jsonObj.toString();
		request.setAttribute("json", json);
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}

}
