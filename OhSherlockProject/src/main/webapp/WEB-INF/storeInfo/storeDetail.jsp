<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<script>

	
</script>

<div class="container">

	<h2 style="font-weight:bold">매장안내</h2>
	<hr>
	
	<div class="row">
		<div class="col">
		<h4>매장 정보</h4>
		
		<table class="table table-bordered mt-4" style="font-size: 13pt;">
			<thead class="thead-light">
				<tr>
					<th class="col-3" style="height:100px; vertical-align: middle;">매장유형</th>
					<td style="height:100px; vertical-align: middle;">${requestScope.type}</td>
				</tr>
				<tr>
					<th style="height:100px; vertical-align: middle;">지점이름</th>
					<td style="height:100px; vertical-align: middle;">${name}</td>
				</tr>
				<tr>
					<th style="height:100px; vertical-align: middle;">상세주소</th>
					<td style="height:100px; vertical-align: middle;">${address}</td>
				</tr>
				<tr>
					<th style="height:100px; vertical-align: middle;">전화번호</th>
					<td style="height:100px; vertical-align: middle;">${call}</td>
				</tr>
			</thead>
		</table>
		
		</div>
		<div class="col">
			<h4 class="mb-4">지도</h4>
			<c:if test="${requestScope.no == '1'}">
				<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3162.9391721116262!2d126.91732551516753!3d37.55649687979979!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x357c98dc8ca7c5ff%3A0x77b69120db604d0e!2z7ISc7Jq47Yq567OE7IucIOuniO2PrOq1rCDshJzqtZDrj5kgNDQ3LTU!5e0!3m2!1sko!2skr!4v1665592062438!5m2!1sko!2skr" width="500" height="400" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
			</c:if>
			<c:if test="${requestScope.no == '2'}">
				<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3336.4334651082986!2d126.3661718150426!3d33.255142580830324!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x350c5b4bce8deb33%3A0xe55b20e4311ac5bd!2z7KCc7KO87Yq567OE7J6Q7LmY64-EIOyEnOq3gO2PrOyLnCDslYjrjZXrqbQg7LC97LKc66asIDU2NA!5e0!3m2!1sko!2skr!4v1665592236674!5m2!1sko!2skr" width="500" height="400" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
			</c:if>
			<c:if test="${requestScope.no == '3'}">
				<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2624.9916256937618!2d2.292292615555007!3d48.858370079287425!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47e66e2964e34e2d%3A0x8ddca9ee380ef7e0!2z7JeQ7Y6g7YOR!5e0!3m2!1sko!2skr!4v1665592446941!5m2!1sko!2skr" width="500" height="400" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
			</c:if>
			<c:if test="${requestScope.no == '4'}">
				<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d16364.819737771506!2d-73.99249022952792!3d40.784034310613336!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c2589a018531e3%3A0xb9df1f7387a94119!2z7IS87Yq465-0IO2MjO2BrA!5e0!3m2!1sko!2skr!4v1665592530240!5m2!1sko!2skr" width="500" height="400" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
			</c:if>
		</div>
	</div>

</div>

<%@ include file="../footer.jsp"%>