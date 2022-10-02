<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

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
* {
		font-family: 'Gowun Dodum', sans-serif;
	  }

.listView {
	width: 90px;
	margin: 15px;
	border-style: none;
	height: 30px;
	font-size: 14px;
}

.btn-secondary:hover {
	border: 2px none #1E7F15;
	background-color: #1E7F15;
	color: white;
}

.inquiryContent {
	border: 1px solid gray;
	border-radius: 1%;
	min-height: 150px;
	max-height: 250;
	overflow: auto;
	background-color: white;
}

#replyTbl{
	width: 100%;
}

#replyTbl thead {
	background-color: #1E7F15;
	color: white
}
</style>

<div class="container">

	<%-- 사용자가 자신의 문의 내용과 그에 달린 댓글을 확인하는 페이지입니다.--%>

	<div class=" text-left">
		<div style="font-weight: bold; font-size: 20px;">${ivo.inquiry_subject}</div>
		<br>
		<div
			style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;">${ivo.inquiry_date}</div>
	</div>


	<div class="text-left inquiryContent jumbotron mt-4 pt-auto">${ivo.inquiry_content}
	</div>

	<table id="replyTbl">
		<thead>
			<tr>
				<td class="p-2 pl-3">답변</td>
				<td class="text-right p-2 pr-3">
					<c:if test="${not empty ivo.irevo}">
						${ivo.irevo.inquiry_reply_date }
					</c:if>
					<c:if test="${empty ivo.irevo}">
					-
					</c:if>
				</td>
			</tr>
		</thead>
		<tbody class="bg-light">
			<tr>
				<td colspan='2' class="p-3">
					<c:if test="${not empty ivo.irevo}">
					 ${ivo.irevo.inquiry_reply_content}
					 </c:if>
					 <c:if test="${empty ivo.irevo}">
					 답변 준비중입니다.
					 </c:if>
				</td>
			</tr>
		</tbody>
	</table>


</div>

