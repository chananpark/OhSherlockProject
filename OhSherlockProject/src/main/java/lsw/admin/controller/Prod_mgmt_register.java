package lsw.admin.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import common.controller.AbstractController;
import common.model.MemberVO;
import common.model.ProductVO;
import common.model.SpecVO;
import lsw.admin.model.InterProductDAO;
import lsw.admin.model.ProductDAO;

public class Prod_mgmt_register extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// === 로그인을 하지 않은 상태라면 조회가 불가능하도록 한다. === //
		if( !super.checkLogin(request) ) {
			
			String message = "먼저 로그인을 하세요!!";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
			
		}
		else {
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			if( !"admin".equals(loginuser.getUserid()) ) {
			   // === 관리자(admin)가 아닌 일반사용자로 로그인 했을 때는 조회가 불가능하도록 한다. === //
			   
				String message = "관리자 이외는 접근이 불가합니다.";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				
			//	super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			else {	
				   // === 관리자(admin)로 로그인 했을 때만 제품등록이 가능하도록 한다. === //
					
					String method = request.getMethod(); // "GET" 또는 "POST"
					
					if(!"POST".equalsIgnoreCase(method)) { // GET 방식이라면
						
						InterProductDAO pdao = new ProductDAO();
						// 카테고리 목록을 조회해오기 
						List<HashMap<String, String>> categoryList = pdao.getCategoryList();
						request.setAttribute("categoryList", categoryList);
						
						// spec 목록을 보여주고자 한다.
						List<SpecVO> specList = pdao.selectSpecList();
						request.setAttribute("specList", specList);
						
						super.setRedirect(false);
						super.setViewPage("/WEB-INF/admin/prod_mgmt_register.jsp");
					}
					else { // POST 방식이라면
						MultipartRequest mtrequest = null;// request기능에 더해서 파일 업로드 다운로드 기능을 할 수 있다.
						
						ServletContext svlCtx = session.getServletContext();
						String uploadFileDir = svlCtx.getRealPath("/images");
						System.out.println("=== 첨부되어지는 이미지 파일이 올라가는 절대경로 uploadFileDir ==> " + uploadFileDir); 
						
						// === 파일을 업로드 해준다. ===
						
						try {
							mtrequest = new MultipartRequest(request, uploadFileDir, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy()); // 같은 파일 이름을 가졌을경우 중복 방지를 위해서 숫자를 생성해줌. 
						}catch (IOException e) {
							request.setAttribute("message", "업로드 되어질 경로가 잘못되었거나 또는 최대용량 10MB를 초과했으므로 파일업로드 실패함!!");
				            request.setAttribute("loc", request.getContextPath()+"/admin/prod_mgmt_register.tea"); 
				              
				            super.setViewPage("/WEB-INF/msg.jsp");
				            return; // 종료
						}
							
						String fk_cnum = mtrequest.getParameter("fk_cnum");
						String pname = mtrequest.getParameter("pname");
						
						String pimage = mtrequest.getFilesystemName("pimage");
					
					   String pqty = mtrequest.getParameter("pqty");
			           String price = mtrequest.getParameter("price");
			           String saleprice = mtrequest.getParameter("saleprice");
			           String fk_snum = mtrequest.getParameter("fk_snum");
						
			           
			           // !!!! 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어코드) 작성하기 !!!! // 
			           String psummary = mtrequest.getParameter("psummary");
			           psummary = psummary.replaceAll("<", "&lt;");
			           psummary = psummary.replaceAll(">", "&gt;");
			           psummary = psummary.replaceAll("\r\n", "<br>");
			           
			           // !!!! 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어코드) 작성하기 !!!! // 
			           String pcontent = mtrequest.getParameter("pcontent");
			           pcontent = pcontent.replaceAll("<", "&lt;");
			           pcontent = pcontent.replaceAll(">", "&gt;");
			           pcontent = pcontent.replaceAll("\r\n", "<br>");
			           
			           String point = mtrequest.getParameter("point");
			           
			           InterProductDAO pdao = new ProductDAO();
			           
			           int pnum = pdao.getPnumOfProduct();// 제품번호 채번 해오기
			           
			           ProductVO pvo = new ProductVO(); 
			           pvo.setFk_cnum(Integer.parseInt(fk_cnum));
			           pvo.setFk_snum(Integer.parseInt(fk_snum));
			           pvo.setPnum(pnum);
			           pvo.setPname(pname);
			           pvo.setPsummary(psummary);
			           pvo.setPcontent(pcontent);
			           pvo.setPqty(Integer.parseInt(pqty));
			           pvo.setPrice(Integer.parseInt(price));
			           pvo.setSaleprice(Integer.parseInt(saleprice));
			           pvo.setPoint(Integer.parseInt(point));
			           pvo.setPimage(pimage);
			           
			           String message = "";
			           String loc = "";
			           
			           try {
				           // tbl_product 테이블에 제품정보 insert 하기
				           pdao.productInsert(pvo);
				           
				           String str_attachCount = mtrequest.getParameter("attachCount");
				           
				           int attachCount = 0;
				           
				           if(!"".equals(str_attachCount)) {
				        	   attachCount = Integer.parseInt(str_attachCount);
				           }
				           
				           for(int i=0; i<attachCount; i++) {
				        	   String attachFileName = mtrequest.getFilesystemName("attach"+i);
				        	   
				        	   pdao.product_imagefile_Insert(pnum, attachFileName);
			
				           }// end of for -----------
				           
				           message = "제품등록 성공!!";
				           loc = request.getContextPath()+"/admin/prod_mgmt_list.tea";
				           
			           }catch(SQLException e) {
			        	   e.printStackTrace();
			        	   message = "제품등록 실패!!";
				           loc = request.getContextPath()+"/admin/prod_mgmt_register.jsp";
			           }
			           request.setAttribute("message", message);
			           request.setAttribute("loc", loc);
			           
			           // super.setRedirect(false);
			           super.setViewPage("/WEB-INF/msg.jsp");
					}
				}
			}
		}
}
