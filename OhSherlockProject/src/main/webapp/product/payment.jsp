<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
	#addressBtn {
		background-color: #1E7F15;
		color: white;
		height: 30px;
		border-style: none;
		border-radius: 5%;
	}
</style>

<div class="container">

	<h2 style="font-weight:bold">주문하기</h2>
	<hr>
	<h5>주문고객정보</h5>
	
	<hr>
	<h5>배송지정보</h5>
	<table class="table table-bordered mt-4">
			<thead class="thead-light">
				<tr>
					<td style="display:none" class="storeNo">1</td>
					<th>받는 분</th><td>이순신</td>
				</tr>
				<tr>
					<th>연락처</th><td>010-1111-2222</td>
				</tr>
				<tr>
					<th style="vertical-align:middle">주소</th>
				
					<td class="border-0">
						<input class="addressInput mt-2" type="text" id="address" name="address" size="20" placeholder="주소" />
						<button type="button" id="addressBtn">우편번호찾기</button>
						<br>
			   			<input class="addressInput mt-2" type="text" id="extraAddress" name="extraAddress" size="40"/> 
						<br>	
				   		<input class="addressInput mt-2" type="text" id="detailAddress" name="detailAddress" size="40" placeholder="상세주소" />
				   		<span class="error" style="color:red">주소를 입력하세요</span>
			   		</td>
				</tr>
				<tr>
					<th>배송메모</th>
					<td><input id="deliveryMemo" type="text" name="deliveryMemo" size="40" placeholder="예: 부재시 경비실에 맡겨주세요" /></td>
				</tr>
			</thead>
		</table>
		
	<hr>
	<h5>주문상품</h5>
	
	<hr>
	<h5>할인/포인트</h5>
	
	<hr>
	<h5>결제수단</h5>
	
	<hr>
	<h5>결제정보</h5>
	<div class="paymentTotal mt-4" >
		<table class="table table-active table-borderless">
		    <tbody>
		      <tr>
		        <td class="col col-9 text-left">상품금액</td>
		        <td class="col col-3 text-right">18,000</td>
		      </tr>
		      <tr>
		        <td class="col col-9 text-left">배송비</td>
		        <td class="col col-3 text-right">2,500</td>
		      </tr>
		      <tr>
		        <td class="col col-9" style="color:#1E7F15; font-weight:bolder;"><h4>결제예정금액</h4></td>
		        <td class="col col-3 text-right" style="color:#1E7F15; font-weight:bolder;"><h4>20,500</h4></td>
		      </tr>
		    </tbody>
		  </table>
	</div>
</div>

<%@ include file="../footer.jsp"%>