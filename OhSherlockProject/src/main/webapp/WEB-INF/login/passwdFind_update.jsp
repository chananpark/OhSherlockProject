<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<% String ctxPath = request.getContextPath(); %>    

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css">

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- 폰트 목록 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js"></script>

<!-- jQueryUI CSS 및 JS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />

 <style type="text/css">
      
      * {
		font-family: 'Gowun Dodum', sans-serif;
	  }
      
      /* 아이디찾기 내용 전체 */
      div#passwd_box {
        width: 380px;
      }

      /* 이름, 이메일 박스랑 확인 버튼 */
      div#input_pwd > input,
      div#btn_update > input {
        width: 100%;
        padding: 12px;
        border: 1px solid gray;
        margin: 5px 0;
        opacity: 0.85;
        font-size: 17px;
        line-height: 20px;
      }

      div#input_pwd > input:hover,
      div#btn_update > input:hover {
        opacity: 1;
      }

      /* 이름, 이메일 박스 */
      div#input_pwd > input {
        border-radius: 4px;
      }

      /* 확인 버튼 */
      div#btn_update > input[type='button'] {
        height: 45px;
        border-radius: 90px;
        background-color: #1E7F15;
        color: white;
        cursor: pointer;
      }
    </style>


<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
<script>

	$(document).ready(function(){
		
		$("input#btnUpdate").click(function(){
			
			const password = $("input#password").val();
			const password2 = $("input#password2").val();
			
			const regExp = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
			// 또는
//			const regExp = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g); 
			// 숫자, 문자, 특수문자 포함 형태의 8~15자리 이내의 암호 정규 표현식 객체 생성
			
			const bool = regExp.test(password); // passwd(타켓) 에 대한 암호의 값을 정규표현식에 넣는다. 
			
			if(!bool) {
				alert("암호는 8글자 이상 15글자 이하에 영문자,숫자,특수기호가 혼합되어야만 합니다.");
				$("input#password").val(""); // 잘못 입력해주면 싹 비우고 종료
				$("input#password2").val("");
				 
				 return; // 종료
			} else if(bool && password != password2) {
				// pwd와 pwd2가 다를 경우
				alert("암호가 일치하지 않습니다.");
				$("input#password").val(""); // 잘못 입력해주면 싹 비우고 종료
				$("input#password2").val("");
				 
				 return; // 종료
			} else {
				// 전부 올바르게 입력한 경우
				const frm = document.passwdFind_update_frm;
				frm.action = "<%=ctxPath%>/login/passwdUpdateEnd.tea";
				frm.method = "POST";
				frm.submit();
			}
			
		}); // end of $("button#btnUpdate").click
		
		
	}); // end of $(document).ready(function()

</script>
    
    

<%-- html --%>
<div class="container">
	<form name="passwdFind_update_frm">
		<div id="passwd_box" class="d-flex flex-column m-auto">
			
			<%-- 비밀번호 변경 타이틀 --%>
	    	<div id="passwdFind_title">
	      	<h2 style="text-align: center; font-size: 30px; line-height: 40px; font-weight: bold; " >
	        	비밀번호 변경
	       	</h2>
	    	</div>
	
			<%-- 새 비밀번호 입력창 --%>
		   	<div id="input_pwd" class="d-flex flex-column">
		       	<input type="password" name="passwd" id="password" placeholder="새비밀번호" required />
		       	<input type="password" id="password2" placeholder="비밀번호 확인" required />
		    </div>
		
			<%-- hidden form을 이용해서 userid를 넘겨주기 --%>
	   		<input type="hidden" name="userid" value="${requestScope.userid}"/> 
		
			<%-- 확인 버튼 --%>
			<%-- 이 버튼은 get 방식일 때만 보이고 post 방식이면 클릭해서 다시 자기 자신에게로 간다. --%>
	   		<c:if test="${requestScope.method eq 'GET'}">
			    <div id="btn_update" class="d-flex flex-column">
			      	<input type="button" class="btn btn-dark" value="암호변경하기" id="btnUpdate"/>
			    </div>
	    	</c:if>
	  	</div>
	  	
	   	<%-- post 방식으로 들어오면 위의 버튼은 사라지고 아래와 같은 메시지가 나온다.  --%>
	   	<c:if test="${requestScope.method eq 'POST' && requestScope.n == 1}"> 
	   	<%-- post 방식으로 들어왔는데 결과물이 1(정상변경) 이라면 암호 변경 완료 --%>
		   	<div id="div_updateResult" align="center">
		    	사용자 ID ${requestScope.userid}님의 암호가 정상적으로 변경되었습니다.<br>
		    	로그인 화면으로 이동하여 로그인 해주세요.
		    </div>
	   	</c:if>
	   	
	</form>
</div>

 