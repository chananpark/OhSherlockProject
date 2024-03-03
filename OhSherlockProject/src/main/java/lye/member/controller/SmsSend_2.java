package lye.member.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import common.controller.AbstractController;
import net.nurigo.java_sdk.api.Message;

public class SmsSend_2 extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		//  >> SMS발송 <<
		//  HashMap 에 받는사람번호, 보내는사람번호, 문자내용 등 을 저장한뒤 Coolsms 클래스의 send를 이용해 보냅니다.
			      
		  //String api_key = "발급받은 본인의 API Key";  // 발급받은 본인 API Key
			String api_key = "";     // 발급받은 본인 API Key
		
		  //String api_secret = "발급받은 본인의 API Secret";  // 발급받은 본인 API Secret
			String api_secret = "";  // 발급받은 본인 API Secret
		
			Message coolsms = new Message(api_key, api_secret);  // net.nurigo.java_sdk.api.Message 로 import 하기
		    // net.nurigo.java_sdk.api.Message 임. 
		    // 먼저 다운 받은  javaSDK-2.2.jar 를 /MyMVC/src/main/webapp/WEB-INF/lib/ 안에 넣어서  build 시켜야 함.
			
			String mobile = request.getParameter("mobile");    // 파라미터로 받아온 수신번호
			
			// 인증키를 랜덤으로 생성하도록 한다.
			Random rnd = new Random(); // 객체생성

			String text = "오!셜록 본인확인 인증번호는 [";
			// 인증키는 숫자 6글자 로 만들겠습니다.
			// 예 : certificationCode ==> dngrn4745003

			int randnum = 0;
			String certificationCode = "";
			
			for (int i = 0; i < 6; i++) {
				randnum = rnd.nextInt(9 - 0 + 1) + 0;
				text += randnum;
				certificationCode += randnum;
			} // end of for---------------
			
			text += "] 입니다. 정확히 입력해주세요.";
			
			System.out.println("~~~ 확인용 certificationCode => " + certificationCode);
			
			
			// == 4개 파라미터(to, from, type, text)는 필수사항이다. == 
		    HashMap<String, String> paraMap = new HashMap<>();
		    paraMap.put("to", mobile);                  // 수신번호
		    paraMap.put("from", "010-3329-8922");       // 발신번호
		    // 2020년 10월 16일 이후로 발신번호 사전등록제로 인해 등록된 발신번호로만 문자를 보내실 수 있습니다
		    paraMap.put("type", "SMS");                 // Message type ( SMS(단문), LMS(장문), MMS, ATA )
		    paraMap.put("text", text);     // 문자내용  ==>  랜덤한 인증키를 넣어서 인증코드를 발송할 수 있다.
		    
		    paraMap.put("app_version", "JAVA SDK v2.2"); // application name and version
		    
		    //   ==  아래의 파라미터는 필요에 따라 사용하는 선택사항이다. == 
		    //   paraMap.put("mode", "test"); // 'test' 모드. 실제로 발송되지 않으며 전송내역에 60 오류코드로 뜹니다. 차감된 캐쉬는 다음날 새벽에 충전 됩니다.
		    //   paraMap.put("image", "desert.jpg"); // image for MMS. type must be set as "MMS"
		    //   paraMap.put("image_encoding", "binary"); // image encoding binary(default), base64 
		    //   paraMap.put("delay", "10"); // 0~20사이의 값으로 전송지연 시간을 줄 수 있습니다.
		    //   paraMap.put("force_sms", "true"); // 푸시 및 알림톡 이용시에도 강제로 SMS로 발송되도록 할 수 있습니다.
		    //   paraMap.put("refname", ""); // Reference name
		    //   paraMap.put("country", "KR"); // Korea(KR) Japan(JP) America(USA) China(CN) Default is Korea
		    //   paraMap.put("sender_key", "5554025sa8e61072frrrd5d4cc2rrrr65e15bb64"); // 알림톡 사용을 위해 필요합니다. 신청방법 : http://www.coolsms.co.kr/AboutAlimTalk
		    //   paraMap.put("template_code", "C004"); // 알림톡 template code 입니다. 자세한 설명은 http://www.coolsms.co.kr/AboutAlimTalk을 참조해주세요. 
		    //   paraMap.put("datetime", "20140106153000"); // Format must be(YYYYMMDDHHMISS) 2014 01 06 15 30 00 (2014 Jan 06th 3pm 30 00)
		    //   paraMap.put("mid", "mymsgid01"); // set message id. Server creates automatically if empty
		    //   paraMap.put("gid", "mymsg_group_id01"); // set group id. Server creates automatically if empty
		    //   paraMap.put("subject", "Message Title"); // set msg title for LMS and MMS
		    //   paraMap.put("charset", "euckr"); // For Korean language, set euckr or utf-8
		    //   paraMap.put("app_version", "Purplebook 4.1") // 어플리케이션 버전  
			
		    JSONObject jsonObj = (JSONObject) coolsms.send(paraMap);  // import 할 때 simple로 해야한다.
		    /*
		       org.json.JSONObject 이 아니라 
		       org.json.simple.JSONObject 이어야 한다.  
		    */
		    
		    jsonObj.put("certificationCode", certificationCode);
		    
		    String json = jsonObj.toString();
		    
		    System.out.println("~~~~ 확인용 json => " + json);
		    // ~~~~ 확인용 json => {"group_id":"R2GLXUuyhgtfliqt","success_count":1,"error_count":0,"certificationCode":"596150"}
		    
		    request.setAttribute("json", json);  // 키값 json 에 저장하여 memberInfo_edit.jsp 에 있는 $.ajax({ success:function(json) }) 에 넣어준다.
		    
		//  super.setRedirect(false);
		    super.setViewPage("/WEB-INF/jsonview.jsp");
		    
	}

}
