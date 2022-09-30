<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    

<style>
	button {
		border-style: none;
	}
	
	input[type=button] {
		border-style: none;
	}
	
	#tbl_member_info td:nth-child(odd) {
	  background-color: #f2f2f2;
	  font-weight: bold;
	}
	
	textarea, input {
		vertical-align: middle;
	}
	
</style>

<script type="text/javascript">

	let goBackURL = ""; // 전역변수

	$(document).ready(function(){
		
		// 문자 발송을 클릭했을 경우
		$("input#btnSend").click(function(e){
			
		//	console.log($("input#reservedate").val() + " " + $("input#reservetime").val() ); // 2022-08-30 01:30
		
			let reservedate = $("input#reservedate").val();
			reservedate = reservedate.split("-").join(""); 
		
			let reservetime = $("input#reservetime").val();
			reservetime = reservetime.split(":").join("");
			
			const datetime = reservedate + reservetime;
			
		//	console.log(datetime); // 202209061039
		
			let dataObj;
		
			if( reservedate == "" || reservetime == "") { 
				// 예약일자가 없거나 예약시간이 없을 경우(둘 중 하나라도 없는 경우) 문자를 바로 보내기
				dataObj = {"mobile":"${requestScope.member_select_one.mobile}", // java에서 getParameter 해올 값  : 문자를 받는 번호의 값
						   "smsContent":$("textarea#smsContent").val()}; // java 에서 getParameter 해올 값 : 실제로 입력한 문자 내용 
			} else {
				// 둘 다 있는 경우 문자를 예약으로 보내기
				dataObj = {"mobile":"${requestScope.member_select_one.mobile}", // java에서 getParameter 해올 값  : 문자를 받는 번호의 값
						   "smsContent":$("textarea#smsContent").val(),  // java 에서 getParameter 해올 값 : 실제로 입력한 문자 내용 
						   "datetime":datetime}; // 위에서 -와 : 를 뺀 시간
			}
		
			$.ajax({
				url: "<%= request.getContextPath() %>/member/smsSend.tea",
				type: "POST",
				data: dataObj, // 지금 바로 문자를 보낼 때와 날짜를 지정할 때로 나눠진다.
				dataType: "json",
				success:function(json){
					// json 은 {"group_id":"R2GR4Gg10cYWguJf","success_count":1,"error_count":0} 처럼된다.
					
					if(json.success_count == 1) {
						alert("문자 전송이 완료되었습니다.");
					} else if(json.error_count != 0) {
						alert("문자 전송이 실패되었습니다.");
					}
					
					$("textarea#smsContent").val("");
					$("input#reservedate").val("");
					$("input#reservetime").val("");
				},
				error: function(request, status, error){
		               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	            }
			});
			
		}); // end of $("input#btnSend").click
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		goBackURL = "${requestScope.goBackURL}"; // MemberOneDetail에서 보내준 goBackURL 을 받아온다.
		
		// 변수 goBackURL 에 공백 " " 을 모두 "&" 로 변경하도록 한다.
		goBackURL = goBackURL.replace(/ /gi, "&"); 
		
	}); // end of $(document).ready
	
	
	// function declaration
	// 회원 상세조회에서 바로 직전에 보던 목록을 보여주기(검색된 목록이라면 검색된 회원목록 보여주기)
	function goMemberList() {
		location.href = "<%= request.getContextPath() %>" + goBackURL;
	} // end of function goMemberList()
	
</script>

<c:if test="${empty requestScope.member_select_one}">
	존재하지 않는 회원입니다. <br>
</c:if>

<c:if test="${not empty requestScope.member_select_one}">

<c:set var="mobile" value="${requestScope.member_select_one.mobile}"/>

<div class="container" >

	<h2 class="col text-left" style="font-weight:bold">회원정보 상세조회</h2><br>
   	<hr style="background-color: black; height: 1.2px;"><br>
  
  	<h5 style="font-weight:bold">회원정보</h5>
  	<div style="overflow-x:auto;" >
	  	<table class="table mt-4 mb-5 prodList text-left" id="tbl_member_info">
				<tbody>
					<tr>
						<td class="col-4">아이디</td>
						<td class="col-8">${requestScope.member_select_one.userid}</td>
					</tr>
					<tr>
						<td class="col-4">이름</td>
						<td class="col-8">${requestScope.member_select_one.name}</td>
					</tr>
					<tr>
						<td class="col-4">연락처</td>
						<td class="col-8">${fn:substring(mobile,0,3)}-${fn:substring(mobile,3,7)}-${fn:substring(mobile,7,11)}</td>
					</tr>
					<tr>
						<td class="col-4">이메일</td>
						<td class="col-8">${requestScope.member_select_one.email}</td>
					</tr>
					<tr>
						<td class="col-4">우편번호</td>
						<td class="col-8">${requestScope.member_select_one.postcode}</td>
					</tr>
					<tr>
						<td class="col-4">주소</td>
						<td class="col-8">${requestScope.member_select_one.address}</td>
					</tr>
					<tr>
						<td class="col-4">생년월일</td>
						<td class="col-8">${requestScope.member_select_one.birthday}</td>
					</tr>
					<tr>
						<td class="col-4">성별</td>
						<td class="col-8">
							<c:choose>
								<c:when test="${requestScope.member_select_one.gender eq '1'}">남</c:when>
								<c:otherwise>여</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<td class="col-4">예치금</td>
						<td class="col-8"><fmt:formatNumber value="${requestScope.member_select_one.coin}" pattern="###,###"/> 원</td>
					</tr>
					<tr>
						<td class="col-4">적립금</td>
						<td class="col-8"><fmt:formatNumber value="${requestScope.member_select_one.point}" pattern="###,###"/> 찻잎</td>
					</tr>
					<tr>
						<td class="col-4">가입일자</td>
						<td class="col-8">${requestScope.member_select_one.registerday}</td>
					</tr>
					
				</tbody>
			</table>
		</div>
  	
  	<%-- 문자발송 창 --%>
  	<h5 style="font-weight:bold" class="mb-4">문자발송</h5>
  	
  	<div style="border: 1px solid #ddd; "> <%-- text-align: center --%>
  		<%-- 문자발송 상단부 --%>
  		<div class="ml-5 mt-5">
		  	<span class="mr-3">발송예약일</span> 
		  	<input type="date" id="reservedate" />
		  	<input type="time" id="reservetime" />
	  	</div>
	  	<hr style="width:92%;">
	  	<%-- 문자발송 창 --%>
	  	<div class="ml-5 mt-3 mb-5" >
		  	<textarea rows="10" style="width: 83%;" id="smsContent"></textarea>
		  	<span><input id="btnSend" type="button" class="btn btn-light" style="height: 250px; width: 100px; background-color: #f2f2f2;" value="전송" /></span>
	  	</div>
  	</div>
 
 
	<div class="mt-4">
  		<button class="btn float-right" onclick="goMemberList()" style="background-color: #1E7F15; color:white; font-weight: bold;">
  			회원 목록으로 돌아가기
		</button>
  	</div>

</div>

</c:if>

<%@ include file="../footer.jsp"%>