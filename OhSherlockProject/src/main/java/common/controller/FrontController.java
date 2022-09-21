package common.controller;

import java.io.*;
import java.lang.reflect.Constructor;
import java.util.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(
		description = "사용자가 웹에서 *.tea를 했을 경우 이 서블릿이 응답을 해준다.", 
		urlPatterns = { "*.tea" }, 
		initParams = { 
				@WebInitParam(name = "propertyConfig", value = "C:/Users/sist/git/OhSherlockProject/OhSherlockProject/src/main/webapp/WEB-INF/Command.properties", description = "*.tea에 대한 클래스의 매핑파일")
		})
public class FrontController extends HttpServlet {
	// 웹브라우저 주소창에서  *.tea라는 경로로 요청이 오면 FrontController 서블릿이 응답을 한다.
	
	private static final long serialVersionUID = 1L;

    private Map<String, Object> cmdMap = new HashMap<>(); // url과 그에 매핑될 컨트롤러를 저장	
	
    // WAS가 구동된 후 맨 처음에 딱 한 번 자동적으로 실행되는 메소드
	public void init(ServletConfig config) throws ServletException {
		
		String props = config.getInitParameter("propertyConfig");
		// Command.properties의 경로
		
		try {
			FileInputStream fis = new FileInputStream(props);
			// 특정 경로에 있는 파일을 읽어옴
			
			Properties pr = new Properties();
			// Properties 객체
			
			pr.load(fis);
			/*
				Command.properties 파일의 내용을 읽어 Properties 클래스의 객체인 pr에 로드시킴
				= 을 기준으로 왼쪽은 key, 오른쪽은 value
			*/
			
			Enumeration<Object> en = pr.keys();
			// pr의 모든 key == url경로

			while(en.hasMoreElements()) {
				
				String key = (String) en.nextElement(); // key(url) 한 개
				
				String className = pr.getProperty(key); // 이 key에 해당하는 value(클래스 이름)
				
				if( className != null ) { // url에 매핑된 클래스가 있을 경우
					className = className.trim();
					
					Class<?> cls = Class.forName(className);
					// className에 해당하는 클래스를 불러오는 것
					
					Constructor<?> constrt = cls.getDeclaredConstructor();
					// 불러온 클래스의 생성자
					
					Object obj = constrt.newInstance();
					// 생성자로 인스턴스를 생성
					
					cmdMap.put(key, obj);
					// key: url, obj: url에 해당하는 클래스의 인스턴스
				}
				
			}
			
		} catch (FileNotFoundException e) {
			System.out.println(">>> Command.properties 파일이 존재하지 않습니다. <<<");
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			System.out.println(">>> 문자열로 명명되어진 클래스가 존재하지 않습니다. <<<");
			e.printStackTrace();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		requestProcess(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		requestProcess(request, response);
	}
	
	// get 혹은 post 요청이 오면 이 메소드를 실행함
	private void requestProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { 
		
		String uri = request.getRequestURI();
		
		String key = uri.substring(request.getContextPath().length());
		// 컨텍스트 패스 이후의 url을 가져옴
		
		AbstractController action = (AbstractController) cmdMap.get(key);
		// url에 해당하는 클래스의 객체(인스턴스)
		
		if(action == null) {
			System.out.println(">>> " + key + "에 매핑된 클래스가 없습니다. <<<"); 
		}
		else {
			try {
				// request.setCharacterEncoding("UTF-8");
				// 필터에서 처리
				
				action.execute(request, response);
				
				boolean bool = action.isRedirect();
				String viewPage = action.getViewPage();
				
				if(!bool) { // forward하는 경우
					if(viewPage != null) {
						RequestDispatcher dispatcher = request.getRequestDispatcher(viewPage); 
						dispatcher.forward(request, response);
					}
				}
				else { // redirect하는 경우
					if(viewPage != null) {
						response.sendRedirect(viewPage);
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
	}
	
}
