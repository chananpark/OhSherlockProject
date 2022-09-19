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

	#phoneCheck, 
	#emailCheck {
		color:#333333;
		height: 30px;
		border-style: none;
		border-radius: 5%;
	
	} 

	.btn-light {
		width: 85px; 
		margin: 15px; 
		border-style: none; 
		height: 33px;
	}
	
	.btn-light:hover {
		border: 2px none #1E7F15;
		background-color: #1E7F15;
    color: white;
	}
	
	.btn-secondary {
		width: 85px; 
		color: #1a1a1a; 
		border-style: none; 
		height: 33px;
	}
	
	.mustIn {
	color: red;
	font-weight: bold;
}
</style>    
    
    
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">회원정보수정</h2>
      <br>
      <hr style="background-color: black; height: 1.2px;"><br>
    </div>  

    <br><br>
    
  <div id="tblTitle">
	  <h5>회원정보</h5>
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
					</th>
					<td>
						leess
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
						size="50" placeholder="이순신"/></td>
				</tr>
				<tr>
			<th>성별</th>
			<td >
			   <input type="radio" id="male" name="gender" value="1" checked/><label for="male" style="margin-left: 1%;">남자</label>
			   <input type="radio" id="female" name="gender" value="2" style="margin-left: 5%;" /><label for="female" style="margin-left: 1%;">여자</label>
			</td>
		</tr>
		
		<tr>
			<th>생년월일</th>
			<td >
			   <input type="number" id="birthyyyy" name="birthyyyy" min="1950" max="2050" step="1" value="1995" style="width: 80px; padding: 5px;" required />
			   <select id="birthmm" name="birthmm" style="margin-left: 2%; width: 60px; padding: 5px;">
				</select> 
			   <select id="birthdd" name="birthdd" style="margin-left: 2%; width: 60px; padding: 5px;">
				</select> 
			</td>
		</tr>
				
				<tr>
					<th>휴대전화</th>
					<td>
				    <input type="text" id="hp1" name="hp1" size="6" maxlength="3" value="010" readonly />&nbsp;-&nbsp;
				    <input type="text" id="hp2" name="hp2" size="6" maxlength="4" placeholder="1234"/>&nbsp;-&nbsp;
				    <input type="text" id="hp3" name="hp3" size="6" maxlength="4" placeholder="5678"/>
						<button type="button" id="phoneCheck">수정</button>	
					</td>
						
				</tr>
				<tr>
					<th>이메일<span class="mustIn">*</span></th>
					<td>
						<input id="email" type="text" name="email" size="50" placeholder="leess@gmail.com"/>
						<button type="button" id="emailCheck">수정</button>
						<span id="emailCheckResult"></span>
						<span class="error" style="color: red">이메일 형식에 맞지 않습니다.</span>
					</td>
				</tr>
				
				<tr>
						<th style="vertical-align: middle">주소<span class="mustIn">*</span></th>
						<td class="border-0">
							<input class="addressInput mt-2"
							type="text" id="postcode" name="postcode" size="20"
							placeholder="01234" />
							<button type="button" id="addressBtn">우편번호찾기</button>
							<span class="error" style="color: red">우편번호 형식이 아닙니다.</span> <br> 
							<input
							class="addressInput mt-2" type="text" id="extraAddress"
							name="extraAddress" size="50" placeholder="서울 마포구 동교로 332 (동교동, 거북아파트)"/> <br> 
							<input
							class="addressInput mt-2" type="text" id="detailAddress"
							name="detailAddress" size="50" placeholder="101동 1107호" /> 
							<span class="error" style="color: red">주소를 입력하세요</span></td>
					</tr>
			</thead>
		</table>

   
    <br><br>
    
     	
    <div class="text-center" id="detail" style="display: block; margin-top: 40px;">
	  <input type="button" class="btn-light" value="수정" />
	  <input type="button" class="btn-secondary" value="취소" />
    </div>
    
  </div>
</div>
</div>
<%@ include file="../footer.jsp"%>
