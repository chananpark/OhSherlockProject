package pca.member.controller;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.Session;

import java.util.Properties;

public class GoogleMail {

	// 휴면해제 인증코드 메일로 보내기
	public void sendmail(String userid, String recipient, String certificationCode) throws Exception {
        
        // 1. 정보를 담기 위한 객체
        Properties prop = new Properties(); 
         
        // 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
        prop.put("mail.smtp.user", "ssherlock.oh@gmail.com");
        
        // 3. SMTP 서버 정보 설정
        prop.put("mail.smtp.host", "smtp.gmail.com");
        
        prop.put("mail.smtp.port", "465");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.debug", "true");
        prop.put("mail.smtp.socketFactory.port", "465");
        prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        prop.put("mail.smtp.socketFactory.fallback", "false");
        
        prop.put("mail.smtp.ssl.enable", "true");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
          
        
        Authenticator smtpAuth = new MySMTPAuthenticator();
        Session ses = Session.getInstance(prop, smtpAuth);
           
        // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
        ses.setDebug(true);
                
        // 메일의 내용을 담기 위한 객체생성
        MimeMessage msg = new MimeMessage(ses);

        // 제목 설정
        String subject = "[오!셜록] " + userid + " 회원님 휴면해제 인증코드 발송";
        msg.setSubject(subject);
                
        // 보내는 사람의 메일주소
        String sender = "ssherlock.oh@gmail.com";
        Address fromAddr = new InternetAddress(sender);
        msg.setFrom(fromAddr);
                
        // 받는 사람의 메일주소
        Address toAddr = new InternetAddress(recipient);
        msg.addRecipient(Message.RecipientType.TO, toAddr);
                
        // 메시지 본문의 내용과 형식, 캐릭터 셋 설정
        msg.setContent("발송된 인증코드 : <span style='font-size:14pt; color:red;'>"+certificationCode+"</span>", "text/html;charset=UTF-8");
                
        // 메일 발송하기
        Transport.send(msg);
        
     }
	
	// 1:1 문의 답변알림 메일로 보내기
	public void sendReplyAlert(String userid, String recipient, String inquiry_subject) throws Exception {
		
		// 1. 정보를 담기 위한 객체
		Properties prop = new Properties(); 
		
		// 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
		prop.put("mail.smtp.user", "ssherlock.oh@gmail.com");
		
		// 3. SMTP 서버 정보 설정
		prop.put("mail.smtp.host", "smtp.gmail.com");
		
		prop.put("mail.smtp.port", "465");
		prop.put("mail.smtp.starttls.enable", "true");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.debug", "true");
		prop.put("mail.smtp.socketFactory.port", "465");
		prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		prop.put("mail.smtp.socketFactory.fallback", "false");
		
		prop.put("mail.smtp.ssl.enable", "true");
		prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		
		
		Authenticator smtpAuth = new MySMTPAuthenticator();
		Session ses = Session.getInstance(prop, smtpAuth);
		
		// 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
		ses.setDebug(true);
		
		// 메일의 내용을 담기 위한 객체생성
		MimeMessage msg = new MimeMessage(ses);
		
		// 제목 설정
		String subject = "[오!셜록] " + userid + " 회원님 1:1 문의에 답변이 등록되었습니다.";
		msg.setSubject(subject);
		
		// 보내는 사람의 메일주소
		String sender = "ssherlock.oh@gmail.com";
		Address fromAddr = new InternetAddress(sender);
		msg.setFrom(fromAddr);
		
		// 받는 사람의 메일주소
		Address toAddr = new InternetAddress(recipient);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		
		// 메시지 본문의 내용과 형식, 캐릭터 셋 설정
		msg.setContent("안녕하세요 " + userid + "고객님, 일상에 향긋함을 선사하는 오!셜록입니다.<br><br> 고객님께서 작성하신 1:1 문의 ["+inquiry_subject+"]에 답변이 등록되었습니다.<br><br> 기다려주셔서 감사합니다.<br><br><br>오!셜록 OH!Sherlock corp.", "text/html;charset=UTF-8");
		
		// 메일 발송하기
		Transport.send(msg);
		
	}
	
	
}
