<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>



<style type="text/css">

	#img {
		text-align: center;
		padding-bottom: 20px;
	}


	table {
		margin: 30px 406px;
		border: 1px solid #e9ecef;
    width: 301px;
    height: 156px;
	}
	
	td {
    padding: 5px 20px 5px 5px;
    font-weight: bold;
    font-size: 18px; 
    
	}
	
</style>

</head>

 <div class="container">
     
    <div class="col-md-15">
      <h2 style="font-weight: bold;">회원가입</h2>
      <br>
      <hr style="background-color: black; height: 1.2px;"><br>
    </div>  
    
    <div id="img"><img src="../images/correct.png" width="130" style ="margin: auto"/></div>
      <h2 style="text-align: center; font-size: 30px; line-height: 40px; font-weight: bold">회원가입이 완료되었습니다.</h2>
      <h5 style="text-align: center; font-size: 18px; ">오!셜록을 찾아주셔서 감사합니다.</h5>
      <table>
        <tbody>
	        <tr>
	        	<td colspan="2" style="background-color: #e9ecef">
	        		가입된 정보
        		</td>
       		</tr>
          <tr>
            <td>아이디</td>
            <td>${requestScope.userid}</td>
          </tr>

          <tr>
            <td>이름</td>
            <td>${requestScope.name}</td>
          </tr>

          <tr>
            <td>이메일</td>
            <td>${requestScope.email}</td>
          </tr>
        </tbody>
      </table>

      <div class="my-3">
        <p class="text-center">
          <a href="<%=ctxPath%>/login/login.tea"><button type="button" class="btn btn-success" id="btnLoginPage">
            로그인 페이지로 이동
          </button></a>
        </p>
      </div>
    </div>
<%@ include file="../footer.jsp"%>
