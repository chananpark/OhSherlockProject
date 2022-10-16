<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
#addressBtn {
	background-color: #1E7F15;
	color: white;
	height: 30px;
	border-style: none;
}

#payBtn {
  padding: 10px 20px;
  font-size: 20px;
  text-align: center;
  cursor: pointer;
  outline: none;
  color: white;
  background-color: #1E7F15;
  border: none;
  border-radius: 15px;
  box-shadow: 0 9px #999;
}

#payBtn:hover {background-color: #3e8e41}

#payBtn:active {
  background-color: #3e8e41;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
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

.mustIn {
	color: red;
	font-weight: bold;
}

</style>

<script type="text/javascript" src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script>

	let b_flag_zipcodeSearch_click = true;
	// "우편번호찾기" 을 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도.

	$(document).ready(() => {

		$(".error").hide();
		
		const inputList = $("#recipientInfo > thead td input");
		inputList[0].value = "${loginuser.name}";
		inputList[1].value = "${loginuser.mobile}";
		inputList[2].value = "${loginuser.postcode}";
		inputList[3].value = "${loginuser.address}";
		inputList[4].value = "${loginuser.extra_address}";
		inputList[5].value = "${loginuser.detail_address}";
		
		// 부트스트랩 일일히 주기 귀찮아서..
		$("#accordion .collapse").addClass("row");
		$("#accordion .collapse").addClass("container");
		$("#accordion .collapse").addClass("mt-0");
		$(".orderPayment table.orderInfo > thead > tr > th").addClass("col col-2");
		$(".orderPayment table.orderInfo > thead > tr > td").addClass("col col-10");

		$(".saleNpoint").addClass("row");
		$("#saleNpoint > table > tbody > tr.saleNpointInfo > td:first-child").addClass("col col-9");
		$("#saleNpoint > table > tbody > tr.saleNpointInfo > td:last-child").addClass("col col-3");
		//////////////////////////

		$("#td_paymentMethod").text("예치금");
		
		// 예치금 결제 선택시 현재 예치금 알려주기
		$("input[name='paymentMethod']").change((e)=>{
			if($(e.target).val() == "coin") {
				$("#currentCoin").show();
				$("#td_paymentMethod").text("예치금");
			}	else {
				$("#currentCoin").hide();
				$("#td_paymentMethod").text("신용카드");
			}	
			
		});
		
		// 할인금액 넣어주기
		let s_saleAmount = '${saleAmount}'.toLocaleString('en');
		$("#saleAmount").val(s_saleAmount);
		
		// 주문자와 같음 체크시
		$("#samePerson").change((e) => {
			const inputList = $("#recipientInfo > thead td input");
			if ($(e.target).prop('checked')) {
				b_flag_zipcodeSearch_click = true;
				inputList[0].value = "${loginuser.name}";
				inputList[1].value = "${loginuser.mobile}";
				inputList[2].value = "${loginuser.postcode}";
				inputList[3].value = "${loginuser.address}";
				inputList[4].value = "${loginuser.extra_address}";
				inputList[5].value = "${loginuser.detail_address}";
			} else {
				b_flag_zipcodeSearch_click = false;
				for (let item of inputList) {
					item.value = "";
				}
			}
		});
						
		// 적립금 모두 사용 클릭시
		$("#spendPointAll").click(()=>{
			$("#odrusedpoint").val('${loginuser.point}');
			changePoint();
		});
		
		// 우편번호 클릭시 이벤트
		$('button#addressBtn').click(function () {

			b_flag_zipcodeSearch_click = true;

			new daum.Postcode({
				oncomplete: function (data) {
					// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

					// 각 주소의 노출 규칙에 따라 주소를 조합한다.
					// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					let addr = ''; // 주소 변수
					let extraAddr = ''; // 참고항목 변수

					//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
					if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
						addr = data.roadAddress;
					} else { // 사용자가 지번 주소를 선택했을 경우(J)
						addr = data.jibunAddress;
					}

					// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
					if (data.userSelectedType === 'R') {
						// 법정동명이 있을 경우 추가한다. (법정리는 제외)
						// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
						if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
							extraAddr += data.bname;
						}
						// 건물명이 있고, 공동주택일 경우 추가한다.
						if (data.buildingName !== '' && data.apartment === 'Y') {
							extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
						}
						// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
						if (extraAddr !== '') {
							extraAddr = ' (' + extraAddr + ')';
						}
						// 조합된 참고항목을 해당 필드에 넣는다.
						document.getElementById("extra_address").value = extraAddr;

					} else {
						document.getElementById("extra_address").value = '';
					}

					// 우편번호와 주소 정보를 해당 필드에 넣는다.
					document.getElementById('postcode').value = data.zonecode;
					document.getElementById("address").value = addr;
					// 커서를 상세주소 필드로 이동한다.
					document.getElementById("detail_address").focus();
				}
			}).open();
		});

		// 수령자이름 유효성검사
		$('input#recipient_name').blur((e) => {
			const $target = $(e.target);

			const recipient_name = $target.val().trim();
			if (recipient_name == '') {
				// 입력하지 않거나 공백만 입력했을 경우
				$('table#recipientInfo :input').prop('disabled', true);
				$target.prop('disabled', false);

				$target.parent().find('span.error').show();

				$target.focus();
			} else {
				// 공백이 아닌 글자를 입력했을 경우
				$('table#recipientInfo :input').prop('disabled', false);

				$target.parent().find('span.error').hide();
			}
		});

		// 상세주소 유효성검사
		$('input#detail_address').blur((e) => {
			const $target = $(e.target);

			const detail_address = $target.val().trim();
			if (detail_address == '') {
				// 입력하지 않거나 공백만 입력했을 경우
				$('table#recipientInfo :input').prop('disabled', true);
				$target.prop('disabled', false);

				$target.parent().find('span.error').show();

				$target.focus();
			} else {
				// 공백이 아닌 글자를 입력했을 경우
				$('table#recipientInfo :input').prop('disabled', false);

				$target.parent().find('span.error').hide();
			}
		});

		// 핸드폰번호 유효성검사
		$('input#recipient_mobile').blur((e) => {
			const $target = $(e.target);

			const regExp = new RegExp(/^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/);

			const bool = regExp.test($target.val());

			if (!bool) {
				$('table#recipientInfo :input').prop('disabled', true);
				$target.prop('disabled', false);

				$target.parent().find('span.error').show();

				$target.focus();
			} else {
				$('table#recipientInfo :input').prop('disabled', false);

				$target.parent().find('span.error').hide();
			}
		});
		
		// 적립금 사용 유효성 검사
		$("#odrusedpoint").keyup((e)=>{
			const usedPoint = Number($(e.target).val());
			if (usedPoint > Number('${loginuser.point}')){
				$(e.target).val(Number('${loginuser.point}'));
			}
			if ($(e.target).val()==""){
				$(e.target).val(0);
			}
		});
		
		// 적립금 사용시 결제정보 변화
		$("#odrusedpoint").change((e)=>{
			changePoint();
		});

		
	});

function changePoint() {
	
	const usedPoint = Number($("#odrusedpoint").val());
	$("#td_point").text(usedPoint.toLocaleString('en') + " 원");
	
	$("#span_totalPaymentAmount").text((Number(${sumtotalPrice})+Number(${delivery_cost})-usedPoint).toLocaleString('en'));
	
	$("#h4_totalPrice").text((Number(${sumtotalPrice})+Number(${delivery_cost})-usedPoint).toLocaleString('en') +" 원");
	
	$("input[name='odrusedpoint']").val(usedPoint);
}

function pay() {
	
	// "우편번호찾기" 을 클릭했는지 여부 알아오기
	if (!b_flag_zipcodeSearch_click) {
		// "우편번호찾기" 을 클릭 안 했을 경우
		alert('우편번호찿기를 클릭하셔서 우편번호를 입력하셔야 합니다.');
		return; // 종료
	} else {
		// "우편번호찾기" 을 클릭을 했을 경우

		const regExp = new RegExp(/^\d{5}$/g);
		//  숫자 5자리만 들어오도록 검사해주는 정규표현식 객체 생성

		const postcode = $("input:text[id='postcode']").val();

		const bool = regExp.test(postcode);

		if (!bool) {
			alert('우편번호 형식에 맞지 않습니다.');
			$("input:text[id='postcode']").val('');
			b_flag_zipcodeSearch_click = false;
			return; // 종료
		}
	} 
	// 필수 입력사항 입력여부
	const inputList = $("#recipientInfo > thead td input");
	let isAllFull = true;
	for (let item of inputList) {
		 if(item.name != 'recipient_memo' && item.value == "") {
			 alert('필수 입력사항은 모두 입력하셔야 합니다.');
			 isAllFull = false;
			 return false;
		 }
	}
	
	// 약관 동의여부
	if(!$("#purchaseAgree").prop('checked')){
		alert("구매약관에 동의하셔야 합니다.");
		return;
	}
	
	const totalOrderPrice = Number(${sumtotalPrice})-Number($("#odrusedpoint").val());
	if($('input[name=paymentMethod]:checked').val() == "card") {
		cardPayment(totalOrderPrice);
	}
	else{
		if(Number(${loginuser.coin}) > totalOrderPrice){
			frmSubmit();
		}
		else {
			alert("보유하신 예치금이 부족합니다.");
			return;
		}
	}
}

function cardPayment(totalOrderPrice) {
	const url = "<%=ctxPath%>/shop/cardPayment.tea?pnamejoin=${pnamejoin}&totalOrderPrice="+totalOrderPrice;

    window.open(url, "cardPayment", "left=350px, top=100px, width=800px, height=570px");
}

function frmSubmit() {
	const frm = document.orderFrm;
	frm.method = "POST"; 
	frm.action = "<%=ctxPath%>/shop/completeOrder.tea";
	frm.submit();
}
</script>

<div class="container orderPayment">

	<h2 style="font-weight: bold">주문하기</h2><br>
	<hr style="background-color: black; height: 1.2px;"><br>

	<div id="accordion">
	
		<h5><a class="collapsed card-link" data-toggle="collapse"href="#customerInfo">주문고객정보</a>
		</h5>
		<div id="customerInfo" class="collapse">
			<table class="table table-bordered mt-4 orderInfo">
				<thead class="thead-light">
					<tr>
						<th>성함</th>
						<td>${loginuser.name }</td>
					</tr>
					<tr>
						<th>연락처</th>
						<td>${loginuser.mobile }</td>
					</tr>
					<tr>
						<th style="vertical-align: middle">주소</th>

						<td>${loginuser.postcode }<br>
						${loginuser.address } ${loginuser.extra_address }<br>
						${loginuser.detail_address }</td>
					</tr>
				</thead>
			</table>
		</div>
		<hr>
		<%-- 배송지 정보 input태그 value에는 기본적으로 구매자 정보가 입력되어 있도록 한다. --%>
		<h5>
			<a class="collapsed card-link" data-toggle="collapse" href="#deliveryAddr">배송지정보</a>
		</h5>
		<form name="orderFrm">
		<div id="deliveryAddr" class="collapse show">
			<input type="checkbox" id="samePerson" checked/><label for="samePerson" class="mt-2">&nbsp;주문자 정보와 같음</label>
			<table class="table table-bordered mt-2 orderInfo" id="recipientInfo">
				<thead class="thead-light">
					<tr>
						<th>받는 분<span class="mustIn">*</span></th>
               			<td><input id="recipient_name" name="recipient_name" type="text" required/>
               			<span class="error" style="color: red">이름을 입력하세요.</span></td>
					</tr>
					<tr>
						<th>연락처<span class="mustIn">*</span></th>
               			<td>
               			<input id="recipient_mobile" name="recipient_mobile" type="text" placeholder="-을 제외한 숫자만 입력하세요." size="30" maxlength="11" required/>
               			<span class="error" style="color: red">핸드폰 번호 형식에 맞지 않습니다.</span>
               			</td>
					</tr>
					<tr>
						<th style="vertical-align: middle">주소<span class="mustIn">*</span></th>

						<td class="border-0">
						<input class="addressInput mt-2 required" type="text" id="postcode" name="recipient_postcode" size="20" placeholder="우편번호" />
						<button type="button" id="addressBtn">우편번호찾기</button>
						<br> 
						<input class="addressInput mt-2 " type="text" id="address" name="recipient_address" size="50" placeholder="주소"/><br>
						<input class="addressInput mt-2 " type="text" id="extra_address" name="recipient_extra_address" size="50" /><br>
						<input class="addressInput mt-2 " type="text" id="detail_address" name="recipient_detail_address" size="50" placeholder="상세주소" /> 
						<span class="error" style="color: red">상세 주소를 입력하세요.</span></td>
					</tr>
					<tr>
						<th>배송메모</th>
						<td><input id="recipient_memo" type="text" name="recipient_memo"
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
						<th>상품사진</th>
						<th>상품명</th>
						<th>수량</th>
						<th>가격</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${odList}" var="odvo">
					<tr>
						<td><img src="../images/${odvo.pvo.pimage }" width="100" /></td>
						<td>${odvo.pvo.pname }</td>
						<td><fmt:formatNumber value="${odvo.oqty }" pattern="###,###" /></td>
						<td><fmt:formatNumber value="${odvo.oprice }" pattern="###,###" /> 원</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
		<hr>
		
		<h5><a class="collapsed card-link" data-toggle="collapse" href="#saleNpoint">할인/적립</a></h5>
		<div id="saleNpoint" class="collapse show mt-4">
			<table class="table table-active table-borderless">
				<tbody>
					<tr>
						<td class="mt-2">상품 할인</td>
					</tr>
					<tr class="saleNpointInfo">
						<td><input class="text-right pr-3" id="saleAmount" type="text" disabled/></td>
						<td><input class="rounded" type="button" value="할인 적용" disabled/></td>
					</tr>
					<tr>
						<td class="mt-2">적립금 | 보유적립금 <fmt:formatNumber value="${loginuser.point}" pattern="###,###" />점</td>
					</tr>
					<tr class="saleNpointInfo">
						<td><input name="odrusedpoint" id="odrusedpoint" type="number" max="${loginuser.point}" value="0" class="text-right"/></td>
						<td><input class="rounded" id="spendPointAll" type="button" value="모두 사용" style="border-style:none; background-color: #1E7F15; color: white;"/></td>
					</tr>
				</tbody>
			</table>
		</div>
		<hr>

		<h5><a class="collapsed card-link" data-toggle="collapse" href="#paymentMethod">결제수단</a></h5>
		<div id="paymentMethod" class="collapse show my-4">
			
			<label class="mr-3"><input type="radio" checked="checked" name="paymentMethod" value="coin"> &nbsp;예치금 사용</label>
			<label><input type="radio" name="paymentMethod" value="card"> &nbsp;신용카드</label>
		</div>
		<div class="mb-4" id="currentCoin">
			현재 보유 예치금: <span style="color: #1E7F15; font-weight:bold"><fmt:formatNumber value="${loginuser.coin}" pattern="###,###" /></span> 원
			&nbsp;&nbsp;
			결제 금액: <span id="span_totalPaymentAmount" style="color: #1E7F15; font-weight:bold"><fmt:formatNumber value="${totalPaymentAmount}" pattern="###,###" /></span> 원
			
		</div>		
		<hr>		
		
		<h5><a class="collapsed card-link" data-toggle="collapse" href="#purchaseTerms">구매약관</a></h5>
		<div id="purchaseTerms" class="collapse show my-4">
			<table class="table table-active table-borderless mt-3">
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
							style="padding-top: 20px; padding-bottom: 0.7px;">
							<fmt:formatNumber value="${sumtotalPrice}" pattern="###,###" /> 원</td>
					</tr>
					<tr>
						<td class="col col-9 text-left" style="padding-bottom: 0.7px;">총
							할인금액</td>
						<td class="col col-3 text-right" style="padding-bottom: 0.7px;">
						<fmt:formatNumber value="${saleAmount}" pattern="###,###" /> 원</td>
					</tr>
					<tr>
						<td class="col col-9 text-left" style="padding-bottom: 0.7px;">└&nbsp;적립금 사용</td>
						<td id="td_point" class="col col-3 text-right" style="padding-bottom: 0.7px;">0 원
						</td>
					</tr>
					<tr>
						<td class="col col-9 text-left">배송비</td>
						<td class="col col-3 text-right" style="padding-bottom: 20px;">
						<fmt:formatNumber value="${delivery_cost}" pattern="###,###" /> 원</td>
					</tr>
					<tr style="border-top: 1px solid #d9d9d9;">
						<td class="col col-9"
							style="color: #1E7F15; font-weight: bolder; padding-bottom: 0.7px;"><h4>총
								결제금액</h4></td>
						<td class="col col-3 text-right"
							style="color: #1E7F15; font-weight: bolder; padding-bottom: 0.7px;">
							<h4 id="h4_totalPrice"><fmt:formatNumber value="${totalPaymentAmount }" pattern="###,###" /> 원</h4></td>
					</tr>
					<tr>
						<td class="col col-9 text-left"
							style="padding-top: 0; padding-bottom: 0;">결제수단</td>
						<td id="td_paymentMethod" class="col col-3 text-right"
							style="padding-top: 0;" class="pb-2"></td>
					</tr>
				</tbody>
			</table>
		</div>
			<input type="hidden" id="delivery_cost" name="delivery_cost" value="${delivery_cost}" />
			<input type="hidden" name="pnumjoin" value="${pnumjoin}" />
			<input type="hidden" name="oqtyjoin" value="${oqtyjoin}" />
			<input type="hidden" name="totalPricejoin" value="${totalPricejoin}" />
			<input type="hidden" name="cartnojoin" value="${cartnojoin}" />
			<input type="hidden" name="sumtotalPrice" value="${sumtotalPrice}" />
			<input type="hidden" name="totalPaymentAmount" value="${totalPaymentAmount}" />
			<input type="hidden" name="odrusedpoint" />
		</form>
			<div class="text-center mt-3">
			<button id="payBtn" type="button" onclick="pay()">결제하기</button>
			</div> 
	</div>
</div>
<%@ include file="../footer.jsp"%>