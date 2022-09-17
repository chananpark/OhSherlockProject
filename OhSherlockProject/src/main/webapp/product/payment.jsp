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

#accordion a:link, #accordion a:visited {
	color: black;
}

#accordion a:hover {
	cursor: pointer;
	color: #1E7F15;
}

#orderList th, #orderList td {
	text-align: center;
	vertical-align: middle;
}

#saleNpoint input {
	width: 100%;
	height: 35px;
}

</style>

<script>

$(document).ready(()=>{
	$("#accordion .collapse").addClass("row");
	$("#accordion .collapse").addClass("container");
	$("#accordion .collapse").addClass("mt-0");
	$(".orderPayment table.orderInfo > thead > tr > th").addClass("col col-2");
	$(".orderPayment table.orderInfo > thead > tr > td").addClass("col col-10");

	$(".saleNpoint").addClass("row");
	$("#saleNpoint > table > tbody > tr.saleNpointInfo > td:first-child").addClass("col col-9");
	$("#saleNpoint > table > tbody > tr.saleNpointInfo > td:last-child").addClass("col col-3");
});

</script>

<div class="container orderPayment">

	<h2 style="font-weight: bold">주문하기</h2>
	<hr>

	<div id="accordion">

		<h5><a class="collapsed card-link" data-toggle="collapse"href="#customerInfo">주문고객정보</a>
		</h5>
		<div id="customerInfo" class="collapse">
			<table class="table table-bordered mt-4 orderInfo">
				<thead class="thead-light">
					<tr>
						<th>받는 분</th>
						<td>이순신</td>
					</tr>
					<tr>
						<th>연락처</th>
						<td>010-1111-2222</td>
					</tr>
				</thead>
			</table>
		</div>
		<hr>

		<h5>
			<a class="collapsed card-link" data-toggle="collapse" href="#deliveryAddr">배송지정보</a>
		</h5>
		<div id="deliveryAddr" class="collapse show">
			<input type="checkbox" id="samePerson"/><label for="samePerson" class="mt-2">&nbsp;주문자 정보와 같음</label>
			<table class="table table-bordered mt-2 orderInfo">
				<thead class="thead-light">
					<tr>
						<th>받는 분</th>
						<td>이순신</td>
					</tr>
					<tr>
						<th>연락처</th>
						<td>010-1111-2222</td>
					</tr>
					<tr>
						<th style="vertical-align: middle">주소</th>

						<td class="border-0"><input class="addressInput mt-2"
							type="text" id="address" name="address" size="20"
							placeholder="우편번호" />
							<button type="button" id="addressBtn">우편번호찾기</button> <br> <input
							class="addressInput mt-2" type="text" id="extraAddress"
							name="extraAddress" size="40" /> <br> <input
							class="addressInput mt-2" type="text" id="detailAddress"
							name="detailAddress" size="40" placeholder="상세주소" /> <span
							class="error" style="color: red">주소를 입력하세요</span></td>
					</tr>
					<tr>
						<th>배송메모</th>
						<td><input id="deliveryMemo" type="text" name="deliveryMemo"
							size="40" placeholder="예: 부재시 경비실에 맡겨주세요" /></td>
					</tr>
				</thead>
			</table>
		</div>
		<hr>
		
		<h5><a class="collapsed card-link" data-toggle="collapse" href="#orderList">주문상품</a></h5>
		<div id="orderList" class="collapse show">
			<table class="table mt-4">
				<thead class="thead-light">
					<tr>
						<th colspan="2">제품정보</th>
						<th>수량</th>
						<th>가격</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><img
							src="https://www.osulloc.com/upload/kr/ko/adminImage/GL/SU/304_20211015203853590OP.png?quality=80"
							width="100" /></td>
						<td>스윗 베리 루이보스티</td>
						<td>1</td>
						<td>9,500원</td>
					</tr>
					<tr>
						<td><img
							src="https://www.osulloc.com/upload/kr/ko/adminImage/HB/XA/304_20211026141423508CU.png?quality=80"
							width="100" /></td>
						<td>러블리 티 박스</td>
						<td>1</td>
						<td>20,000원</td>
					</tr>
					<tr>
						<td><img
							src="https://www.osulloc.com/upload/kr/ko/adminImage/KR/TP/304_20191213162107079MN.png?quality=80"
							width="100" /></td>
						<td>웨딩 그린티 20입</td>
						<td>1</td>
						<td>18,400원</td>
					</tr>
				</tbody>
			</table>
		</div>
		<hr>
		
		<h5><a class="collapsed card-link" data-toggle="collapse" href="#saleNpoint">할인/포인트</a></h5>
		<div id="saleNpoint" class="collapse show mt-4">
			<table class="table table-active table-borderless">
				<tbody>
					<tr>
						<td class="mt-2">상품 할인</td>
					</tr>
					<tr class="saleNpointInfo">
						<td><input type="text" value="0개 상품 할인 적용" disabled /></td>
						<td><input type="button" value="할인 적용" disabled /></td>
					</tr>
					<tr>
						<td class="mt-2">포인트 | 보유포인트 1,000점</td>
					</tr>
					<tr class="saleNpointInfo">
						<td><input type="number" value="0" class="text-right"/></td>
						<td><input type="button" value="모두 사용" style="border-style:none; background-color: #1E7F15; color: white;"/></td>
					</tr>
				</tbody>
			</table>
		</div>
		<hr>

		<h5><a class="collapsed card-link" data-toggle="collapse" href="#paymentMethod">결제수단</a></h5>
		<div id="paymentMethod" class="collapse show mt-4">
			결제 배우고 나서 넣겠음...

			<table class="table table-active table-borderless">
				<tbody>
					<tr>
						<td colspan="2" style="text-align: center; vertical-align: middle;"><iframe src="../iframeAgree/agree.html" width="85%" height="150px" class="box" ></iframe></td>
					</tr>
					<tr>
					<td><input type="checkbox" id="purchaseAgree"/><label for="purchaseAgree" class="mt-2">&nbsp;위 구매 약관에 동의합니다.</label></td>
					</tr>
				</tbody>
			</table>
		</div>
		<hr>
		
		<h5><a class="collapsed card-link" data-toggle="collapse" href="#paymentInfo">결제정보</a></h5>
		<div id="paymentInfo" class="paymentTotal collapse show mt-4">
			<table class="table table-active table-borderless">
				<tbody>
					<tr>
						<td class="col col-9 text-left"
							style="padding-top: 20px; padding-bottom: 0.7px;">총 상품금액</td>
						<td class="col col-3 text-right"
							style="padding-top: 20px; padding-bottom: 0.7px;">12,000원</td>
					</tr>
					<tr>
						<td class="col col-9 text-left" style="padding-bottom: 0.7px;">총
							할인금액</td>
						<td class="col col-3 text-right" style="padding-bottom: 0.7px;">0원</td>
					</tr>
					<tr>
						<td class="col col-9 text-left" style="padding-bottom: 0.7px;">└&nbsp;적립금
							및 예치금 결제</td>
						<td class="col col-3 text-right" style="padding-bottom: 0.7px;">0원</td>
					</tr>
					<tr>
						<td class="col col-9 text-left">배송비</td>
						<td class="col col-3 text-right" style="padding-bottom: 20px;">2,500원</td>
					</tr>
					<tr style="border-top: 1px solid #d9d9d9;">
						<td class="col col-9"
							style="color: #1E7F15; font-weight: bolder; padding-bottom: 0.7px;"><h4>총
								결제금액</h4></td>
						<td class="col col-3 text-right"
							style="color: #1E7F15; font-weight: bolder; padding-bottom: 0.7px;"><h4>20,500</h4></td>
					</tr>
					<tr>
						<td class="col col-9 text-left"
							style="padding-top: 0; padding-bottom: 0;">결제수단</td>
						<td class="col col-3 text-right"
							style="padding-top: 0;" class="pb-2">신용카드</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<%@ include file="../footer.jsp"%>