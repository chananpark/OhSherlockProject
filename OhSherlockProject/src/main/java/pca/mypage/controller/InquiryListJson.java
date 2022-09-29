package pca.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.InquiryVO;
import common.model.MemberVO;
import pca.cs.model.InquiryDAO;
import pca.cs.model.InterInquiryDAO;

public class InquiryListJson extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		InterInquiryDAO idao = new InquiryDAO();
		HttpSession session = request.getSession();
		Map<String, String> paraMap = new HashMap<>();
		
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String userid = loginuser.getUserid();
		paraMap.put("userid", userid);
		
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		paraMap.put("startDate", startDate);
		paraMap.put("endDate", endDate);

		String lead = request.getParameter("lead");
		String lenInquiry = request.getParameter("lenInquiry");
		paraMap.put("lead", lead);
		
		String last = String.valueOf(Integer.parseInt(lead)+Integer.parseInt(lenInquiry));
		paraMap.put("last", last);
		
		List<InquiryVO> inquiryList = idao.showMyInquiryList(paraMap);

		// json객체 배열로 넘긴다.
		JSONArray jsonArr = new JSONArray();

		if (inquiryList.size() > 0) {

			for (InquiryVO ivo : inquiryList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("inquiry_no", ivo.getInquiry_no());
				jsonObj.put("inquiry_type", ivo.getInquiry_type());
				jsonObj.put("inquiry_subject", ivo.getInquiry_subject());
				jsonObj.put("inquiry_content", ivo.getInquiry_content());
				jsonObj.put("inquiry_date", ivo.getInquiry_date());
				if(ivo.getInquiry_answered() == 1)
					jsonObj.put("inquiry_answered", "답변완료");
				else
					jsonObj.put("inquiry_answered", "미답변");
				
				jsonArr.put(jsonObj);
			}
		}
		String json = jsonArr.toString();
		request.setAttribute("json", json);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		
	}

}
