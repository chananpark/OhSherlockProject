<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
	
	.loginContainer form {
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
	
	/* 아이디, 비밀번호 박스 */
	div#input_login > input {
		border-radius: 4px;
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
	
	/* 버튼로그인 */
	.loginContainer input[type='submit']{
		width:80px;
		height:45px;
		border-radius: 90px;
	  background-color: #003300;
	  color: white;
	  cursor: pointer;
	}
	
	/* 버튼회원가입 */
	.loginContainer input[type='button']{
		width:80px;
		height:45px;
		border-radius: 90px;
	  background-color: #c6c6c6;
	  color: white;
	  cursor: pointer;
	}

</style>
</head>

<%@ include file="../header.jsp"%>

<div class="container loginContainer">

	  <form>
	  	<div id="login_box" class="d-flex flex-column m-auto">
				<div id="Login_title">
		   		<h2 style="text-align:center; font-size: 30px; line-height: 40px;">Login</h2>
				</div>
		      
				<div id="input_login" class="d-flex flex-column">
		      <input type="text" name="username" placeholder="아이디" required>
		      <input type="password" name="password" placeholder="비밀번호" required>
				</div>
				
		     <div id="id_save_find" class="w-98 d-flex justify-content-between">
		     
		      <div id="idPwdSave">
		       	<input type="checkbox" id="chk" title="아이디 저장 선택" checked="checked" />
		       	<label for="chk">아이디 저장</label>
		     	</div>
		     	
		      <div id="idFind">
		       	<a class="" href="/">아이디 찾기</a>
		       	<a href="/">비밀번호 찾기</a>
		      </div>
		      
		     </div>
		     
		     <div id="btn_loginbox"  class="d-flex flex-column">
		      <input type="submit" class="btn btn-dark" value="로그인">
		      <input type="button" class="btn btn-dark" value="회원가입">
		     </div>
	  	</div>
	  </form>

</div>

<%@ include file="../footer.jsp"%>
