package lye.member.controller;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class GoogleMail {

	public void sendmail(String recipient, String certificationCode, String userid) throws Exception {  // recipient : 수신자의 이메일주소  certificationCode : 인증코드
        
        // 1. 정보를 담기 위한 객체
        Properties prop = new Properties(); 
        
        // 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
        //    Google Gmail 과 연결할 경우 Gmail 의 email 주소를 지정 
        prop.put("mail.smtp.user", "eunee005@gmail.com");  // 본인 지메일 계정을 넣어줌.
            
        
        // 3. SMTP 서버 정보 설정
        //    Google Gmail 인 경우  smtp.gmail.com
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
        Session ses = Session.getInstance(prop, smtpAuth);  // javax.mail 로 import 하기
           
        // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
        ses.setDebug(true);
                
        // 메일의 내용을 담기 위한 객체생성
        MimeMessage msg = new MimeMessage(ses);  // javax.mail.internet 으로 import 하기

        // 제목 설정
        String subject = " [오!셜록] "+ userid +" 회원님 정보수정을 위한 이메일 인증코드 발송";
        msg.setSubject(subject);
                
        // 보내는 사람의 메일주소
        String sender = "eunee005@gmail.com";
        Address fromAddr = new InternetAddress(sender);  // javax.mail.internet 으로 import 하기
        msg.setFrom(fromAddr);
                
        // 받는 사람의 메일주소
        Address toAddr = new InternetAddress(recipient);     // 수신인의 메일주소
        msg.addRecipient(Message.RecipientType.TO, toAddr);  // javax.mail 로 import 하기
                
        // 메시지 본문의 내용과 형식, 캐릭터 셋 설정
        msg.setContent("발송된 인증코드 : <span style='font-size:14pt; color:red;'>"+certificationCode+"</span>", "text/html;charset=UTF-8");
                
        // 메일 발송하기
        Transport.send(msg);  // javax.mail 로 import 하기
        
     }// end of sendmail(String recipient, String certificationCode)-----------------
	
}