<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%@ include file="../header.jsp"%>

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="../css/style_yeeun.css" />    <!-- /MyMVC/src/main/webapp/css/style.css 파일 경로 -->
    
<style type="text/css">

	div#tblTitle {
		display: flex;
		flex-direction: row;
		justify-content: space-between; 
	}
	
	#addressBtn {
		background-color: #1E7F15;
		color: white;
		height: 30px;
		border-style: none;
		border-radius: 5%;
}

	#idCheck, 
	#emailCheck {
		color:#333333;
		height: 30px;
		border-style: none;
		border-radius: 5%;
	
	} 
	#btnRegister {
    width: 126px;
    padding: 12px;
    border: 2px none #1E7F15;
		background-color: #1E7F15;
		opacity:0.8;
		color: white;
		font-size: 22px;
	}
	
	#btnRegister:hover {
		opacity:1;
	}
	
	.mustIn {
	color: red;
	font-weight: bold;
}
</style>    
    
    
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">회원가입</h2>
      <br>
      <hr style="background-color: black; height: 1.2px;"><br>
    </div>  

    <br><br>
    
  <div id="tblTitle">
	  <h5>회원정보입력</h5>
	  <div style="font-size: 14px; margin-top: 11px; padding-right: 10px;"><span class="mustIn">* </span>필수입력사항</div>
  </div>  
  
	<div class="collapse show">
		<table class="table table-bordered mt-2 orderInfo">
			<colgroup>
	          <col width="180px"/>
	          <col />
     	</colgroup>
			<thead class="thead-light">
				<tr>
					<th>아이디
						<span class="mustIn">*</span>
					</th>
					<td>
						<input id="useid" type="text" name="userid"
						size="50" placeholder="(영문소문자/숫자,4~16자)" />
						<button type="button" id="idCheck">중복확인</button>
						<span id="idcheckResult"></span>
						<span class="error" style="color: red">아이디는 필수입력 사항입니다.</span>
    	  	</td>
					 
				</tr>
				<tr>
					<th>비밀번호<span class="mustIn">*</span></th>
					<td><input id="password" type="text" name="password"
						size="50" placeholder="(영문 대소문자/숫자/특수문자 반드시 포함, 10자~16자)" />
					<span class="error" style="color: red">비밀번호는 대소문자/숫자/특수문자 포함 0자~16자로 입력하세요.</span>
					</td>
				</tr>
				<tr>
					<th></th>
					<td><input id="password2" type="text" name="password2"
						size="50" placeholder="(비밀번호 확인)" />
						<span class="error" style="color: red">암호가 일치하지 않습니다.</span>
					</td>
				</tr>
				<tr>
					<th>이름<span class="mustIn">*</span></th>
					<td><input id="username" type="text" name="username"
						size="50"/></td>
				</tr>
				
				<tr>
					<th style="vertical-align: middle">주소<span class="mustIn">*</span></th>
					<td class="border-0">
						<input class="addressInput mt-2"
						type="text" id="postcode" name="postcode" size="20"
						placeholder="우편번호" />
						<button type="button" id="addressBtn">우편번호찾기</button>
						<span class="error" style="color: red">우편번호 형식이 아닙니다.</span> <br> 
						<input
						class="addressInput mt-2" type="text" id="extraAddress"
						name="extraAddress" size="50" /> <br> 
						<input
						class="addressInput mt-2" type="text" id="detailAddress"
						name="detailAddress" size="50" placeholder="상세주소" /> 
						<span class="error" style="color: red">주소를 입력하세요</span></td>
					</tr>
					
				<tr>
					<th>휴대전화</th>
					<td>
				    <input type="text" id="hp1" name="hp1" size="6" maxlength="3" value="010" readonly />&nbsp;-&nbsp;
				    <input type="text" id="hp2" name="hp2" size="6" maxlength="4" />&nbsp;-&nbsp;
				    <input type="text" id="hp3" name="hp3" size="6" maxlength="4" />
				    <button type="button" id="phoneCheck">인증번호받기</button>
					</td>
				</tr>
				
				<tr>
					<th>이메일<span class="mustIn">*</span></th>
					<td>
						<input id="email" type="text" name="email" size="50" />
						<button type="button" id="emailCheck">중복확인</button>
						<span id="emailCheckResult"></span>
						<span class="error" style="color: red">이메일 형식에 맞지 않습니다.</span>
					</td>
				</tr>
			</thead>
		</table>
	</div>    
    
    <br><br>
    
    <h5>추가정보</h5>
    <div class="collapse show">
		<table class="table table-bordered mt-2 orderInfo">
			<colgroup>
	          <col width="180px"/>
	          <col />
     	</colgroup>
     	
			<thead class="thead-light">
			<tr>
			<th style="background-color: white;">성별</th>
			<td >
			   <input type="radio" id="male" name="gender" value="1" /><label for="male" style="margin-left: 1%;">남자</label>
			   <input type="radio" id="female" name="gender" value="2" style="margin-left: 5%;" /><label for="female" style="margin-left: 1%;">여자</label>
			</td>
		</tr>
		
		<tr>
			<th style="background-color: white;">생년월일</th>
			<td >
			   <input type="number" id="birthyyyy" name="birthyyyy" min="1950" max="2050" step="1" value="1995" style="width: 80px; padding: 5px;" required />년
			   <select id="birthmm" name="birthmm" style="margin-left: 2%; width: 60px; padding: 5px;">
				</select> 월
			   <select id="birthdd" name="birthdd" style="margin-left: 2%; width: 60px; padding: 5px;">
				</select> 일
			</td>
		</tr>

			</thead>
		</table>
	</div>
	  
	  
	  <br><br>
	  
		<h5>이용약관</h5>
    <div class="collapse show">
		<table class="table table-bordered mt-2 orderInfo">
			<colgroup>
	          <col width="180px"/>
	          <col />
     	</colgroup>
			<thead class="thead-light">
				<tr>
					<td colspan="2" style="text-align: center; vertical-align: middle;">
						<iframe src="../iframeAgree/registerAgree.html" width="85%" height="150px" class="box" ></iframe>
					</td>
				</tr>
				<tr>
					<td colspan="2">
					<div style="text-align:right;">					
						<label for="agree">이용약관에 동의하십니까?</label>&nbsp;&nbsp;
						<input type="checkbox" id="agree" /> 동의함
					</div>
					</td>
				</tr>
		
			</thead>
		</table>
	</div>


    <br><br>
    
    <div class="text-center" id="register" style="display: block;"> 
	  <input type="button" id="btnRegister" value="가입하기" />
    </div>
    
  </div>
</div>

<%@ include file="../footer.jsp"%>
