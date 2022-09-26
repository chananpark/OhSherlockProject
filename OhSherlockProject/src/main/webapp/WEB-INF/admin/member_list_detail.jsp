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

	$(document).ready(function(){
		
		
	}); // end of $(document).ready
	
	// 주문 상세 조회 팝업창
	// 이거 만드는 사람이 파라미터로 클릭한 주문번호 아이디? 받아와야 해요~~~
	function goOrderDetailPop() {
		
		// 코인 구매 금액 선택 팝업창 띄우기
		const url = "<%= request.getContextPath() %>/admin/member_list_order_detail.jsp"; 
		// 마지막의 userid 는 변수
		
		// coinPurchaseTypeChoice 이거도 이름 바꿔주셔야 해요~~
		window.open(url, "coinPurchaseTypeChoice", 
					"left=350px, top=100px, width=700px, height=700px");
		
	} // end of function goCoinPurchaseTypeChoice()
		
</script>

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
						<td class="col-8">${requestScope.member_select_one.mobile}</td>
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
						<td class="col-8">${requestScope.member_select_one.coin} 원</td>
					</tr>
					<tr>
						<td class="col-4">적립금</td>
						<td class="col-8">${requestScope.member_select_one.point} 찻잎</td>
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
		  	<span>발송예약일</span> 
		  	<input type="date" >
		  	<input type="time" >
	  	</div>
	  	<hr style="width:92%;">
	  	<%-- 문자발송 창 --%>
	  	<div class="ml-5 mt-3 mb-5" >
		  	<textarea rows="10" style="width: 83%;"></textarea>
		  	<span><input id="submit_btn" type="button" class="btn btn-light" style="height: 250px; width: 100px; background-color: #f2f2f2;" value="전송" /></span>
	  	</div>
  	</div>
  	
	<div class="mt-4">  <%--text-center --%>
  		<button class="btn float-right" style="background-color: #1E7F15; color:white; font-weight: bold;">
  			회원 목록으로 돌아가기
		</button> <%-- float-right --%>
  	</div>


</div>

<%@ include file="../footer.jsp"%>