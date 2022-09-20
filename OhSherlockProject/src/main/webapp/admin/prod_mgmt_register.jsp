<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>

#pdReg input[type="text"], #pdReg input[type="number"], #pdReg select, #pdReg textarea {
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

}
</style>
<div class="container prodRegisterContainer">

	<h2 class="col text-left" style="font-weight: bold">상품관리</h2>
	<br>
	<hr style="background-color: black; height: 1.2px;">
	<br>

	<h5 style="font-weight: bold;">신규 상품 등록</h5>
	<hr>


	<form action="" name="pdReg" id="pdReg">
		<label for="qnatype">카테고리<span class="text-danger">*</span></label> <select
			id="qnatype" name="qnatype">
			<option value="operation">녹차/말차</option>
			<option value="product">홍차</option>
			<option value="order">허브차</option>
			<option value="delivery">기프트세트</option>
		</select> 
			
		<label for="title">상품명<span class="text-danger">*</span></label> 
		<input type="text" id="title" name="title" placeholder="상품명을 입력하세요.">
			
		<label for="title">상품한줄소개<span class="text-danger">*</span></label> 
		<input type="text" id="title" name="title" placeholder="상품한줄소개를 입력하세요.">

		<label for="price">가격<span class="text-danger">*</span></label>
		<input type="number" id="price" name="price" placeholder="숫자만 입력하세요."/>

		<label for="stock">재고<span class="text-danger">*</span></label>
		<input type="number" id="stock" name="stock" placeholder="숫자만 입력하세요."/>

		<label for="salePrice">할인율</label>
		<input type="number" id="salePrice" name="salePrice" placeholder="숫자만 입력하세요."/>

		<label for="thumbnail" style="margin: 6px 20px 16px 0;">대표이미지<span class="text-danger">*</span></label><br>
		<input type="file" id="thumbnail" name="thumbnail"><br>

		<label class="mt-4" for="content">내용<span class="text-danger">*</span></label><br>
		<textarea id="content" name="content" placeholder="상품 설명을 입력하세요." style="height:200px"></textarea>
		<span>파일첨부</span>&nbsp;<input type="file" id="thumbnail" name="thumbnail"> <br>
		
		<hr>

		<div class="text-right" style="margin-top: 30px;">
			<input type="button" class="writeBtns" value="취소"
				style="margin-right: 0" />&nbsp; <input type="button"
				class="btn-secondary writeBtns" value="등록" style="margin-left: 5px;" />
		</div>
	</form>


</div>

<%@ include file="../footer.jsp"%>