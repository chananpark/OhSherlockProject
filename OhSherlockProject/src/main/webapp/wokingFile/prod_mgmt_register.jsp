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

<script type="text/javascript">

	$(document).ready(function(){
		
		
		
		
		
		
		
		
		
	}); // end of $(document).ready(function(){});-------------------------
	
	
	// "등록" 버튼을 클릭시 호출되는 함수 
	function goRegister() {
	  // 최종적으로 폼을 보내어 준다.
	  const frm = document.pdRegFrm;
	  frm.action = '<%=ctxPath%>/myshop/prodRegister.tea';
	  frm.method = 'post';
	  frm.submit();
	}
	
</script>




<div class="container prodRegisterContainer">

	<h2 class="col text-left" style="font-weight: bold">상품관리</h2>
	<br>
	<hr style="background-color: black; height: 1.2px;">
	<br>

	<h5 style="font-weight: bold;">신규 상품 등록</h5>
	<hr>


	<form action="" name="pdRegFrm" id="pdReg">
		<label for="qnatype">카테고리<span class="text-danger">*</span></label> <select
			id="qnatype" name="p_category">
			<option value="녹차/말차">녹차/말차</option>
			<option value="홍차">홍차</option>
			<option value="허브차">허브차</option>
			<option value="기프트세트">기프트세트</option>
		</select> 
			
		<label for="title">상품명<span class="text-danger">*</span></label> 
		<input type="text" id="title" name="p_name" placeholder="상품명을 입력하세요.">
			
		<label for="title">상품한줄소개<span class="text-danger">*</span></label> 
		<input type="text" id="title" name="p_info" placeholder="상품한줄소개를 입력하세요.">

		<label for="price">가격<span class="text-danger">*</span></label>
		<input type="number" id="price" name="p_price" placeholder="숫자만 입력하세요."/>

		<label for="stock">재고<span class="text-danger">*</span></label>
		<input type="number" id="stock" name="p_stock" placeholder="숫자만 입력하세요."/>

		<label for="salePrice">할인금액</label>
		<input type="number" id="salePrice" name="p_discount_rate" placeholder="숫자만 입력하세요."/>

		<label for="thumbnail" style="margin: 6px 20px 16px 0;">대표이미지<span class="text-danger">*</span></label><br>
		<input type="file" id="thumbnail" name="p_thumbnail"><br>

		<label class="mt-4" for="content">내용<span class="text-danger">*</span></label><br>
		<textarea id="content" name="p_desc" placeholder="상품 설명을 입력하세요." style="height:200px"></textarea>
		<span>파일첨부</span>&nbsp;<input type="file" id="p_image" name="p_image"> <br>
		
		<hr>

		<div class="text-right" style="margin-top: 30px;">
			<input type="button" class="writeBtns" value="취소" 	style="margin-right: 0" />&nbsp; 
				<input type="button" class="btn-secondary writeBtns" value="등록"  onclick="goRegister()" style="margin-left: 5px;" />
		</div>
	</form>


</div>

<%@ include file="../footer.jsp"%>