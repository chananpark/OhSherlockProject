<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<style>
#ntWrite input[type=text], #ntWrite select, #ntWrite textarea {
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
</style>
<div class="container">

	<h2 class="col text-left" style="font-weight: bold">상품관리</h2>
	<br>
	<hr style="background-color: black; height: 1.2px;">
	<br>

	<h5 style="font-weight: bold;">신규 상품 등록</h5>
	<hr>


	<form action="" name="ntWrite" id="ntWrite">
		<label for="qnatype">질문유형<span class="text-danger">*</span></label> <select
			id="qnatype" name="qnatype">
			<option value="operation">운영</option>
			<option value="product">상품</option>
			<option value="order">주문</option>
			<option value="delivery">배송</option>
			<option value="member">회원</option>
			<option value="else">기타</option>
		</select> 
			
		<label for="title">제목<span class="text-danger">*</span></label> <input
			type="text" id="title" name="title" placeholder="제목을 입력하세요.">

		<label for="content">내용<span class="text-danger">*</span></label>
		<textarea id="content" name="content" placeholder="문의 내용을 입력하세요."
			style="height: 200px"></textarea>

		<label for="photo" style="margin: 6px 20px 16px 0;">사진 첨부</label><input
			type="file" id="photo" name="photo"> <br>

		<hr>

		<div class="text-right" style="margin-top: 30px;">
			<input type="button" class="writeBtns" value="취소"
				style="margin-right: 0" />&nbsp; <input type="button"
				class="btn-secondary writeBtns" value="등록" style="margin-left: 5px;" />
		</div>
	</form>


</div>

<%@ include file="../footer.jsp"%>