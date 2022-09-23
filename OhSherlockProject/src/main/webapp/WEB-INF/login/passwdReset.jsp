<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
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

<script>

	$(document).ready(function(){
		
		// console.log(${requestScope.userid});
		
		$("input#btnUpdate").click(function(){
			
			const password = $("input#password").val();
			const password2 = $("input#password2").val();
			
			const regExp = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
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
				frm.action = "<%=ctxPath%>/login/passwdReset.tea";
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
	       	<h5>비밀번호 변경 후 3개월 경과로 비밀번호 재설정이 필요합니다.</h5>
	
			<%-- 새 비밀번호 입력창 --%>
		   	<div id="input_pwd" class="d-flex flex-column">
		       	<input type="password" name="passwd" id="password" placeholder="새비밀번호" required />
		       	<input type="password" id="password2" placeholder="비밀번호 확인" required />
		    </div>
		
			<%-- hidden form을 이용해서 userid를 넘겨주기 --%>
	   		<input type="hidden" name="userid" value="${requestScope.userid}"/> 
		
			<%-- 확인 버튼 --%>
		    <div id="btn_update" class="d-flex flex-column">
		      	<input type="button" class="btn btn-dark" value="암호변경하기" id="btnUpdate"/>
		    </div>
	  	</div>

	   	
	</form>
</div>

 <%@ include file="../footer.jsp"%>