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
						<td class="col-8">leess</td>
					</tr>
					<tr>
						<td class="col-4">이름</td>
						<td class="col-8">이순신</td>
					</tr>
					<tr>
						<td class="col-4">연락처</td>
						<td class="col-8">01012341234</td>
					</tr>
					<tr>
						<td class="col-4">이메일</td>
						<td class="col-8">leess@naver.com</td>
					</tr>
					<tr>
						<td class="col-4">생년월일</td>
						<td class="col-8">1997.02.01</td>
					</tr>
					<tr>
						<td class="col-4">예치금</td>
						<td class="col-8">500,000원</td>
					</tr>
					<tr>
						<td class="col-4">적립금</td>
						<td class="col-8">3,000</td>
					</tr>
					<tr>
						<td class="col-4">가입일자</td>
						<td class="col-8">2022.01.12</td>
					</tr>
					<tr>
						<td class="col-4">휴면계정 여부</td>
						<td class="col-8">휴면</td>
					</tr>
					<tr>
						<td class="col-4">휴면 해제</td>
						<td class="col-8">
							<div class="adminOnlyBtns mb-1">
								<input type="button" value="휴면 회원 해제" /> 
							</div>
						</td>
					</tr>
					
					
				</tbody>
			</table>
		</div>
  	
  	
  	<h5 style="font-weight:bold">구매정보</h5>
  	
  	<div style="overflow-x:auto;">
	  	<table class="table mt-4 prodList text-center" id="order_list">
				<thead style="background-color:#f2f2f2;">
					<tr>
						<th class="col-3">주문일자</th>
						<th class="col-3">주문번호</th>
						<th class="col-3">주문금액</th>
						<th class="col-3">주문상세</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>2022.09.20</td>
						<td>20220913-0023355</td>
						<td>35,000원</td>
						<td><input type="button" value="조회" id="orderDetailBtn" onclick="goOrderDetailPop();"/> </td>
					</tr>
					<tr>
						<td>2022.09.20</td>
						<td>20220913-0023355</td>
						<td>35,000원</td>
						<td><input type="button" value="조회" id="orderDetailBtn"/> </td>
					</tr>
					<tr>
						<td>2022.09.20</td>
						<td>20220913-0023355</td>
						<td>35,000원</td>
						<td><input type="button" value="조회" id="orderDetailBtn"/> </td>
					</tr>
					<tr>
						<td>2022.09.20</td>
						<td>20220913-0023355</td>
						<td>35,000원</td>
						<td><input type="button" value="조회" id="orderDetailBtn"/> </td>
					</tr>
					<tr>
						<td>2022.09.20</td>
						<td>20220913-0023355</td>
						<td>35,000원</td>
						<td><input type="button" value="조회" id="orderDetailBtn"/> </td>
					</tr>
					<tr>
						<td>2022.09.20</td>
						<td>20220913-0023355</td>
						<td>35,000원</td>
						<td><input type="button" value="조회" id="orderDetailBtn"/> </td>
					</tr>
					
				</tbody>
			</table>
		</div>
  	
 
  	

</div>

<%@ include file="../footer.jsp"%>