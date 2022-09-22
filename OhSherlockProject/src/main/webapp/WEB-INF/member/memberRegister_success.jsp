<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

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
	#btn_submit{
    height: 45px;
    border-radius: 90px;
    border-style: none;
    background-color: #1E7F15;
    color: white;
    cursor: pointer;
	}
	
	/* 버튼회원가입 */
	#btn_register {
	  height:45px;
	  border-radius: 90px;
	  border-style: none;
	  background-color: #c6c6c6;
	  border:none;
	  color: white;
	  cursor: pointer;
	}

</style>

<script>
	$(document).ready(function(){
	
	}
	
</script>

</head>


 <div class="container">
      회원가입 성공
      
      <table>
        <tbody>
	        <tr>
	          <td colspan="2">
	          오!셜록을 찾아주셔서 감사합니다.
	          </td>
	        </tr>
          <tr>
            <td>아이디</td>
            <td>userid</td>
          </tr>

          <tr>
            <td>이름</td>
            <td>name</td>
          </tr>

          <tr>
            <td>이메일</td>
            <td>email</td>
          </tr>
        </tbody>
      </table>

      <div class="my-3">
        <p class="text-center">
          <button type="button" class="btn btn-success" id="btnFind">
            확인
          </button>
        </p>
      </div>
    </div>

<%@ include file="../footer.jsp"%>
