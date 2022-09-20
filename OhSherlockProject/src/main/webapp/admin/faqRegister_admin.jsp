<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../header.jsp"%>
<style>
* {
	box-sizing: border-box;
}

/* 문의 입력 css 외부에서 받아온 것 */
.faqContainer input[type=text], .faqContainer select, .faqContainer textarea {
	width: 100%;
	padding: 12px;
	border: 1px solid #ccc;
	border-radius: 4px;
	box-sizing: border-box;
	margin-top: 6px;
	margin-bottom: 16px;
	resize: vertical;
}

.writeBtns {
	width: 80px;
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

.faqContainer input[type=submit]:hover {
	background-color: #45a049;
}

.faqContainer .container {
	border-radius: 5px;
	padding: 20px;
}

.faqContainer #qnaFrm {
	padding: 3%;
}
</style>
<div class="container faqContainer">

	<h2 class="col text-left" style="font-weight: bold">자주묻는질문</h2>
	<br>
	<hr style="background-color: black; height: 1.2px;">

	<form action="" name="qnaFrm" id="qnaFrm">
		<label for="qnatype">질문유형<span class="text-danger">*</span></label>
		<select id="qnatype" name="qnatype">
			<option value="operation">운영</option>
			<option value="product">상품</option>
			<option value="order">주문</option>
			<option value="delivery">배송</option>
			<option value="member">회원</option>
			<option value="else">기타</option>
		</select>
	
		<label for="title">질문<span class="text-danger">*</span></label> <input
			type="text" id="title" name="title" placeholder="자주묻는질문을 입력하세요.">

		<label for="content">답변<span class="text-danger">*</span></label>
		<textarea id="content" name="content" placeholder="답변을 입력하세요."
			style="height: 200px"></textarea>

		<div class="text-right" style="margin-top: 30px;">
			<input type="button" class="writeBtns" value="취소"
				style="margin-right: 0" />&nbsp; <input type="button"
				class="btn-secondary writeBtns" value="등록" style="margin-left: 5px;" />
		</div>
	</form>
</div>

<%@ include file="../../footer.jsp"%>