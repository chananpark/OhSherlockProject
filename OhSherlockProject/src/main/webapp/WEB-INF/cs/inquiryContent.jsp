<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
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

	<div class="titleZone row">
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
	<br>

	<div class="col text-left">
		<div style="font-weight: bold; font-size: 20px;">예치금 충전 문의</div>
		<br>
		<div
			style="font-weight: normal; font-size: 15.5px; margin-bottom: 10px;">2022.09.20</div>
	</div>


	<div class="col text-left inquiryContent jumbotron mt-4 pt-auto">
		<br>안녕하세요 저는 서울 마포구에 사는 김쌍용입니다.<br> 다름이 아니오라 예치금 충전하는 방법을
		알고싶습니다.<br> 친절한 답변 부탁드립니다.
	</div>

	<div class="col text-left jumbotron px-0 pt-0 mt-4">
		<table id="replyTitle">
			<tr>
				<td class="text-left">re: 예치금 충전 문의</td>
				<td class="text-right" style="border-left: solid 1px white">2022.09.21</td>
			</tr>
		</table>
		<div class="replyzone mx-5 mt-5">
			<span class="badge text-left" id="replyText">답변</span> <span><br>안녕하세요
				고객님, 오!셜록입니다.<br> 예치금 충전은 마이페이지의 예치금 충전 버튼을 클릭하세요.<br> 향긋한
				하루 되세요.<br> </span>
		</div>
	</div>

	<div class="text-right" style="display: block; margin-top: 30px;">
		<input type="button" class="btn-secondary listView" value="목록보기" />
	</div>


</div>

<%@ include file="../footer.jsp"%>