<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>    

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

#inquiryText, #replyText {
	display: inline-block;
	background-color: #1E7F15;
	color: white;
}

#replyTitle td {
	/* border: 1px solid black; */
	padding: 10px 30px;
	width: 100%;
	background-color: #999999;
	color: white
}
</style>

<div class="container">

	<%-- 사용자가 자신의 문의 내용과 그에 달린 댓글을 확인하는 페이지입니다.--%>

<%-- 	<div class="titleZone row">
		<h2 class="col text-left" style="font-weight: bold">1:1 문의</h2>
		<br>
		<div class="col text-right">
			<span style="font-weight: bold; font-size: 20px;">02-336-8546</span><br>
			<span style="font-weight: normal; font-size: 15.5px;">평일 09:30
				~ 18:00 (점심시간 12:30 ~ 13:30)<br>주말 및 공휴일 휴무
			</span>
		</div>
	</div> 
	<hr style="background-color: black; height: 1.2px;">
	<br>--%>

	<div class="col text-left">
		<div style="font-weight: bold; font-size: 20px;">${ivo.inquiry_subject}</div>
		<br>
		<div
			style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;">${ivo.inquiry_date}</div>
	</div>


	<div class="col text-left inquiryContent jumbotron mt-4 pt-auto">${ivo.inquiry_content}
	</div>

	<div class="col text-left jumbotron px-0 pt-0 mt-4">
		<table id="replyTitle">
			<tr>
				<td class="text-left"><span class="badge text-left" id="replyText">답변</span></td>
				<td class="text-right" style="border-left: solid 1px white">2022.09.21</td>
			</tr>
		</table>
		<div class="replyzone mx-5 mt-5">
			 <div>답변내용 </div>
		</div>
	</div>


</div>

