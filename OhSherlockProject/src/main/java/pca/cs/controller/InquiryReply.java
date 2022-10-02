package pca.cs.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import common.controller.AbstractController;
import common.model.InquiryVO;
import common.model.MemberVO;
import my.util.MyUtil;
import pca.cs.model.InquiryDAO;
import pca.cs.model.InterInquiryDAO;
import pca.member.controller.GoogleMail;

public class InquiryReply extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		boolean isLogined = checkLogin(request);
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		InterInquiryDAO idao = new InquiryDAO();
		String message;
		String loc;
		
		// 관리자만 들어올 수 있음
		if(isLogined && loginuser.getUserid().equals("admin")) {
			
			// get방식의 경우 댓글쓰기 페이지 보여주기
			if("get".equalsIgnoreCase(method)) {
				
				// 선택한 글 가져오기
				String inquiry_no = request.getParameter("inquiry_no");
				
				InquiryVO ivo = idao.showInquiryDetail(inquiry_no);
				
				if (ivo != null) {
					request.setAttribute("ivo", ivo);
				} else {
					message = "해당하는 문의내역이 없습니다.";
					loc = request.getContextPath() + "/cs/inquiry.tea";

					request.setAttribute("message", message);
					request.setAttribute("loc", loc);

					super.setViewPage("/WEB-INF/msg.jsp");
				}
				
				super.setViewPage("/WEB-INF/admin/inquiryReply.jsp");
			}
			// post방식의 경우 댓글 쓰기
			else {
				// 문의글 번호
				String inquiry_no = request.getParameter("inquiry_no");
				
				// 댓글내용
				String inquiry_reply_content = request.getParameter("inquiry_reply_content");
				inquiry_reply_content = inquiry_reply_content.replace("\r\n","<br>");
				
				Map<String, String> paraMap = new HashMap<>();
				paraMap.put("inquiry_reply_content", inquiry_reply_content);
				paraMap.put("inquiry_no", inquiry_no);
				
				// 댓글작성
				int n = idao.writeReply(paraMap);
				
				if (n==1) {
					boolean success = true;
					
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("success", success);
					
					String json = jsonObj.toString();
					request.setAttribute("json", json);
					
					super.setViewPage("/WEB-INF/jsonview.jsp");
				}
				else {
					message = "1:1 문의 답변 등록을 실패하였습니다.";
					loc = request.getContextPath() + "/cs/inquiry.tea";
		
					request.setAttribute("message", message);
					request.setAttribute("loc", loc);
		
					super.setViewPage("/WEB-INF/msg.jsp");
				}
				
				String currentURL = MyUtil.getCurrentURL(request);
				request.setAttribute("goBackURL", currentURL);
			}
				
		}
		// 로그인 안 되었거나 일반회원이면
		else {
			message = "관리자만 접근 가능한 메뉴입니다.";
			loc = request.getContextPath() + "/index.tea";

			request.setAttribute("message", message);
			request.setAttribute("loc", loc);

			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
