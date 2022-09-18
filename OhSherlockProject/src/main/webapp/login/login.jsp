<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style type="text/css">
	
	form#login_frm {
  	padding: 48px 0;
    margin: 0 auto;
    margin-top: 40px;
    margin-bottom: 40px;
    border-top: 0;
	}
	
	/* 로그인폼 내용 전체 */
	div#login_box{
		width:380px;
	}
	
	/* 아이디, 비밀번호 박스랑 로그인, 회원가입 버튼 */
	div#input_login > input,
	div#btn_loginbox > input {
		width: 100%;
	  padding: 12px;
	  border: 1px solid gray;
	  margin: 5px 0;
	  opacity: 0.85;
	  font-size: 17px;
	  line-height: 20px;
	}
	
	div#input_login > input:hover,
	div#btn_loginbox > input:hover {
	  opacity: 1;
	}
	
	/* 아이디, 비밀번호 박스 */
	div#input_login > input {
		border-radius: 4px;
	}

	/* 버튼로그인 */
	div#btn_loginbox > input[type='submit']{
		height:45px;
		border-radius: 90px;
	  background-color: #003300;
	  color: white;
	  cursor: pointer;
	}
	
	/* 버튼회원가입 */
	div#btn_loginbox > input[type='button']{
		height:45px;
		border-radius: 90px;
	  background-color: #c6c6c6;
	  color: white;
	  cursor: pointer;
	}

</style>
</head>

<%@ include file="../header.jsp"%>

<div class="container">

	  <form id="login_frm">
	  	<div id="login_box" class="d-flex flex-column m-auto">
				<div id="login_title">
		   		<h2 style="text-align:center; font-size: 30px; line-height: 40px; font-weight:bold">LOGIN</h2>
				</div>
		      
				<div id="input_login" class="d-flex flex-column">
		      <input type="text" name="userid" placeholder="아이디" required>
		      <input type="password" name="password" placeholder="비밀번호" required>
				</div>
				
		     <div id="id_save_find" class="w-98 d-flex justify-content-between">
		     
		      <div id="idPwdSave">
		       	<input type="checkbox" id="chk" title="아이디 저장 선택" checked="checked" />
		       	<label for="chk">아이디 저장</label>
		     	</div>
		     	
		      <div id="idFind">
		       	<a class="" href="">아이디 찾기 |</a>
		       	<a href="">비밀번호 찾기</a>
		      </div>
		      
		     </div>
		     
		     <div id="btn_loginbox" class="d-flex flex-column">
		      <input type="submit" value="로그인">
		      <input type="button" value="회원가입">
		     </div>
	  	</div>
	  </form>

</div>

<%@ include file="../footer.jsp"%>
