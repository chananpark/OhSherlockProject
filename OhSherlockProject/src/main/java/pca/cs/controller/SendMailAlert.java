package pca.cs.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.MemberVO;
import pca.member.controller.GoogleMail;
import syj.member.model.InterMemberDAO;
import syj.member.model.MemberDAO;

public class SendMailAlert extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String userid = request.getParameter("userid");
		String inquiry_subject = request.getParameter("inquiry_subject");
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("userid", userid);
		
		// 사용자 이메일 가져오기
		InterMemberDAO mdao = new MemberDAO();
		paraMap.put("userid", userid);
		MemberVO mvo = mdao.member_list_detail(paraMap);

		// 이메일 발송
		GoogleMail mail = new GoogleMail();
		// 작성자 이메일
		String email = mvo.getEmail();

		try {
			mail.sendReplyAlert(userid, email, inquiry_subject);

		} catch (Exception e) { // 메일 전송이 실패한 경우 오류페이지로 간다.
			e.printStackTrace();
			super.setRedirect(true);
			super.setViewPage(request.getContextPath() + "/error.tea");
			return;
		}
		
		boolean success = true;
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("success", success);
		
		String json = jsonObj.toString();
		
		request.setAttribute("json", json);
		
		super.setViewPage("/WEB-INF/jsonview.jsp");
	}

}
