<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css">

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- 폰트 목록 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js"></script>

<style>

.accordion {
	font-family: 'Gowun Dodum', sans-serif;
}

#faqAccordion button {
	color: black;
	text-decoration: none;
}

#faqAccordion button:hover {
	cursor: pointer;
	color: #1E7F15;
}

.btn:focus,.btn:active {
   outline: none !important;
   box-shadow: none;
}
</style> 

<script>
	
	$(function() {
		
		<%-- 세션에 저장된 userid가 admin(관리자)일 때만 수정/삭제 버튼을 노출시킨다.--%>
		$(".adminOnlyBtns").hide();
		
		if ("${sessionScope.userid}" == 'admin') {
			$(".adminOnlyBtns").show();
		}
		
	});
</script>
    
<div class="accordion" id="faqAccordion">
	<div class="card">
		<div class="card-header" id="headingOne">
			<h2 class="mb-0">
				<button class="btn btn-link" type="button" data-toggle="collapse"
					data-target="#collapseOne" aria-expanded="true"
					aria-controls="collapseOne">고객센터 운영 시간이 궁금해요.</button>
			</h2>
		</div>

		<div id="collapseOne" class="collapse show"
			aria-labelledby="headingOne" data-parent="#faqAccordion">
			<!-- .collapse show 는 맨 처음에는  내용물을 보여주도록 하는 것임. -->
			<div class="card-body">
				상담 가능한 시간은 AM 09:30-PM 6:00 이며 점심시간은 PM 12:30-PM 1:30 입니다. (주말 및 공휴일
				휴무)<br> 상담 시간 외의 문의는 게시판이나 메일, 채팅 문의 주시면 가능한 빠른 시간에 답변을 드릴 수
				있도록 하겠습니다.
				<div class="text-right adminOnlyBtns mb-1">
					<input type="button" value="수정"/>
					<input class="btn-dark" type="button" value="삭제"/>
				</div>
			</div>
		</div>
	</div>

	<div class="card">
		<div class="card-header" id="headingTwo">
			<h2 class="mb-0">
				<button class="btn btn-link" type="button" data-toggle="collapse"
					data-target="#collapseTwo" aria-expanded="false"
					aria-controls="collapseTwo">환불 규정을 알려주세요.</button>
			</h2>
		</div>

		<div id="collapseTwo" class="collapse" aria-labelledby="headingTwo"
			data-parent="#faqAccordion">
			<div class="card-body">
				결제수단에 관계 없이 환불 금액은 예치금으로 반환됩니다.<br> 결제 시 사용된 포인트가 있다면 반환되며, 구매로
				인해 적립되었던 포인트는 차감됩니다.
				<div class="text-right adminOnlyBtns mb-1">
					<input type="button" value="수정" /> <input class="btn-dark"
						type="button" value="삭제" />
				</div>
			</div>
		</div>
	</div>

	<div class="card">
		<div class="card-header" id="headingThree">
			<h2 class="mb-0">
				<button class="btn btn-link" type="button" data-toggle="collapse"
					data-target="#collapseThree" aria-expanded="false"
					aria-controls="collapseThree">배송비는 얼마인가요?</button>
			</h2>
		</div>

		<div id="collapseThree" class="collapse"
			aria-labelledby="headingThree" data-parent="#faqAccordion">
			<div class="card-body">
				고객님의 실제 결제 금액(쿠폰 사용 등 할인 후 최종 결제 금액, 배송비 제외)이 3만원 이상일 경우에 무료로 배송해
				드립니다.<br> 그러나 총 결제금액이 3만원 미만이라면 고객님께서 배송비 2,500원을 부담해주셔야 합니다.
				<div class="text-right adminOnlyBtns mb-1">
					<input type="button" value="수정" /> <input class="btn-dark"
						type="button" value="삭제" />
				</div>
			</div>
		</div>
	</div>
</div>