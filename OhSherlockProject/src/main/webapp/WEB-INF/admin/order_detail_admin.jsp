<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% String ctxPath = request.getContextPath(); %>    

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OH!Sherlock</title>
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

<!-- jQueryUI CSS 및 JS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<script type="text/javascript">

</script>

<style type="text/css">
	
	* {
		font-family: 'Gowun Dodum', sans-serif;
	}
	
	#order_member_info td:nth-child(odd) {
	  background-color: #f2f2f2;
	  font-weight: bold;
	}
	
</style>

</head>

<body>
	
	<h2 class="text-left" style="font-weight:bold; margin: 10px 0 0 10px;">주문 상세 내역</h2>
	<hr>
    
    <h5 class="text-left" style="font-weight:bold; width:90%; margin: 0 auto;">주문자정보</h5>
	<table class="table mt-4 mb-5 prodList text-left" id="order_member_info" style="width:90%; margin: 0 auto;">
		<tbody>
			<tr>
				<td class="col-4">주문번호</td>
				<td class="col-8">20220913-0023355</td>
			</tr>
			<tr>
				<td class="col-4">주문일자</td>
				<td class="col-8">2022.09.13</td>
			</tr>
			<tr>
				<td class="col-4">이름</td>
				<td class="col-8">이순신</td>
			</tr>
			<tr>
				<td class="col-4">연락처</td>
				<td class="col-8">010-1234-1234</td>
			</tr>
			<tr>
				<td class="col-4">이메일</td>
				<td class="col-8">leess@naver.com</td>
			</tr>
			<tr>
				<td class="col-4">우편번호</td>
				<td class="col-8">12345</td>
			</tr>
			<tr>
				<td class="col-4">주소</td>
				<td class="col-8">서울시 서대문구 쌍용빌딩 123호</td>
			</tr>
			<tr>
				<td class="col-4">결제상태</td>
				<td class="col-8">결제완료</td>
			</tr>
		</tbody>
	</table>

	<h5 class="text-left" style="font-weight:bold; width:90%; margin: 0 auto;">주문상품정보</h5>
	<table class="table mt-4 mb-5 prodList text-left" id="order_prod_info" style="width:90%; margin: 0 auto;">
		<thead style="background-color:#f2f2f2;">
			<tr>
				<th class="col-2">상품명</th>
				<th class="col-2">상품코드</th>
				<th class="col-2">수량</th>
				<th class="col-2">가격</th>
				<th class="col-2">적립금</th>
				<th class="col-2">환불/교환 여부</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>프리미엄티 컬렉션</td>
				<td>20220913-0023355</td>
				<td>3</td>
				<td>35,000원</td>
				<td>찻잎 350개</td>
				<td>정상처리</td>
			</tr>
			<tr>
				<td>그린티 웨하스</td>
				<td>20220913-0023355</td>
				<td>1</td>
				<td>10,000원</td>
				<td>찻잎 100개</td>
				<td>정상처리</td> <%-- 환불/교환 시 여기 테이블 내용 변경 --%>
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="6" style="text-align:right;" class="bg-light">45,000(상품결제금액)+3,000(배송비)=48,000원</td>
			</tr>
		</tfoot>
	</table>
	
</body>
</html>
    
