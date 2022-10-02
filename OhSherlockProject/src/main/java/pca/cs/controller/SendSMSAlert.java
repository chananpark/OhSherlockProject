package pca.cs.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import common.model.MemberVO;
import net.nurigo.java_sdk.api.Message;
import syj.member.model.InterMemberDAO;
import syj.member.model.MemberDAO;

public class SendSMSAlert extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String userid = request.getParameter("userid");
		Map<String, String> paraMap1 = new HashMap<>();
		paraMap1.put("userid", userid);
		
		// 사용자 핸드폰번호 가져오기
		InterMemberDAO mdao = new MemberDAO();
		paraMap1.put("userid", userid);
		MemberVO mvo = mdao.member_list_detail(paraMap1);
		
		// >> SMS발송 <<
		// HashMap 에 받는사람번호, 보내는사람번호, 문자내용 등 을 저장한뒤 Coolsms 클래스의 send를 이용해 보냅니다.

		String api_key = "NCSQZ1VITT9JTKAT"; // 발급받은 본인 API Key
		String api_secret = "SCFGI3WYFDDR8I9WEU1VS6U6DN3YBELC";  // 발급받은 본인 API Secret
		
		Message coolsms = new Message(api_key, api_secret);
		// net.nurigo.java_sdk.api.Message 임. 
		// 먼저 다운 받은  javaSDK-2.2.jar 를 /MyMVC/src/main/webapp/WEB-INF/lib/ 안에 넣어서 build 시켜야 함.
		
		String mobile = mvo.getMobile();
		String smsContent =request.getParameter("smsContent");
		
		// == 4개 파라미터(to, from, type, text)는 필수사항이다. == 
		
	    HashMap<String, String> paraMap = new HashMap<>();
		paraMap.put("to", mobile); // 수신번호
		paraMap.put("from", "01022511907"); // 발신번호
		// 2020년 10월 16일 이후로 발신번호 사전등록제로 인해 등록된 발신번호로만 문자를 보내실 수 있습니다
		paraMap.put("type", "SMS"); // Message type ( SMS(단문), LMS(장문), MMS, ATA )
		paraMap.put("text", smsContent); // Message type ( SMS(단문), LMS(장문), MMS, ATA )
		
		paraMap.put("app_version", "JAVA SDK v2.2"); // application name and version
	
		JSONObject jsonObj = (JSONObject)coolsms.send(paraMap);
		String json = jsonObj.toString();

		request.setAttribute("json", json);
		super.setViewPage("/WEB-INF/jsonview.jsp");
		
	}

}
