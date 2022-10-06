<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>

#pdReg input[type="text"], #pdReg input[type="number"], #pdReg select, #pdReg textarea{
	width: 100%;
	padding: 12px;
	border: 1px solid #ccc;
	border-radius: 4px;
	box-sizing: border-box;
	margin-top: 6px;
	margin-bottom: 16px;
	resize: vertical;
}

input[type="reset"], input[type="button"] {
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

<script type="text/javascript">

	$(document).ready(function(){
		
		// 판매가격 입력하면 적립금 자동 계산 
		$("input[name='saleprice']").bind("change", function(){
			
			let saleprice = $("input[name='saleprice']").val();
			
			$("input[name='point']").val( Math.ceil(saleprice * 0.01));
		});
		
		
		
		// 재고에 스피너 달아주기
		$("input#spinnerPqty").spinner({
			spin:function(event,ui){
           if(ui.value > 100) {
              $(this).spinner("value", 100);
              return false;
           }
           else if(ui.value < 1) {
              $(this).spinner("value", 1);
              return false;
           }
      	}
		}); // end of $("input#spinnerPqty").spinner--------
		
		
		// 추가이미지파일에 스피너 달아주기
		$("input#spinnerImgQty").spinner({
			spin:function(event,ui){
           if(ui.value > 10) {
              $(this).spinner("value", 10);
              return false;
           }
           else if(ui.value < 1) {
              $(this).spinner("value", 0);
              return false;
           }
      	}
		}); // end of $("input#spinnerImgQty").spinner--------
		
		// ### 스피너의 이벤트는 click 도 아니고 change 도 아니고 "spinstop" 이다. ### // 
		$("input#spinnerImgQty").bind("spinstop", function() {
			
			let html = "";
			const cnt = $(this).val();
			
			// console.log("확인용 cnt : " + cnt);
			// console.log("확인용 typeof cnt : " + typeof cnt);
			// 확인용 typeof cnt : string
			
			for(let i=0; i<Number(cnt); i++) {
				html += "<br>";
				html += "<input type='file' name='attach"+i+"' class='btn btn-default'>";
			}// end of for ---------- 
			
			$("div#divfileattach").html(html);
			
			$("input#attachCount").val(cnt);
			
		});
		
		
		// 등록 버튼을 클릭하면
		$("input#btnRegister").click(function() {
			// "등록" 버튼을 클릭시 호출되는 함수 
			
				goRegister();
			
		});
		
	}); // end of $(document).ready(function(){});-------------------------
	
	
	// "등록" 버튼을 클릭시 호출되는 함수 
	function goRegister() {
		

		  // **** 필수입력사항에 모두 입력이 되었는지 검사한다. **** //
		  let b_Flag_required = false;
		
		  $(".required").each(function(){
			  const val = $(this).val().trim();
				if(val == "") {
					$(this).next().show();
					b_Flag_required = true;
					return false; // break 와 똑같은거다.
				}
			});
		  
		  if(!b_Flag_required) { // 필수 입력을 다 채웠을때
				const frm = document.pdRegFrm;
				frm.submit();
			}
	}
	 
</script>

<div class="container prodRegisterContainer">

	<h2 class="col text-left" style="font-weight: bold">상품관리</h2>
	<br>
	<hr style="background-color: black; height: 1.2px;">
	<br>

	<h5 style="font-weight: bold;">신규 상품 등록</h5>
	<hr>

		<form name="pdRegFrm" id="pdReg" action="<%=request.getContextPath()%>/admin/prod_mgmt_register.tea"
			  method="post" 
			  enctype="multipart/form-data">
			<label for="fk_cnum">카테고리<span class="text-danger">*</span></label> 
			<select id="fk_cnum" name="fk_cnum" class="required">
				<option value="">선택하세요</option>
					<%-- 
						<option value="녹차/말차">녹차/말차</option>
						<option value="홍차">홍차</option>
						<option value="허브차">허브차</option>
						<option value="기프트세트">기프트세트</option> 
					--%>
					<c:forEach var="map" items="${requestScope.categoryList}">
		       	<option value="${map.cnum}">${map.cname}</option>
		      </c:forEach>
			</select> 
				
				
			<label for="fk_snum">상품스펙<span class="text-danger">*</span></label> 
			<select id="fk_snum" name="fk_snum" class="required">
				<option value="">선택하세요</option>
			 	<%-- 
	             <option value="1">HIT</option>
	             <option value="2">NEW</option>
	             <option value="3">BEST</option> 
	       --%>
				<c:forEach var="spvo" items="${requestScope.specList}">
	       	<option value="${spvo.snum}">${spvo.sname}</option>
	      </c:forEach>
			</select> 	
			
			<label for="title">상품명<span class="text-danger">*</span></label> 
			<input type="text" id="pname" name="pname" placeholder="상품명을 입력하세요." class="required">
			
			<label for="psummary">상품한줄소개<span class="text-danger">*</span></label> 
			<textarea name="psummary" rows="2" cols="60" class="required"></textarea>
			
			<label for="stock">재고<span class="text-danger">*</span></label><br>
			<input type="number" style="width: 150px;" name="pqty" value="0"  class="required"> 개<br>
			
			<label for="price" style="margin-top: 16px;">정가<span class="text-danger">*</span></label><br>
		  <input type="number" style="width: 150px;" name="price" min="0" class="required" > 원<br>
	
			<label for="salePrice">판매가격<span class="text-danger">*</span></label><br>
			<input type="number" style="width: 150px;" name="saleprice" class="required" > 원<br>
	
			<label for="point" style="margin: 6px 20px 16px 0;">적립금<span class="text-danger">*</span></label><br>
			<input type="number" style="width: 150px;" name="point" class="required" > 찻잎<br>
			
			<label for="pcontent">상품설명<span class="text-danger">*</span></label> 
			<textarea name="pcontent" rows="5" cols="60" class="required"></textarea>
	
			<label for="pimage" style="margin: 6px 20px 16px 0;">썸네일<span class="text-danger">*</span></label><br>
			<input type="file" name="pimage" class="required" /><br>
	
			<label for="prdmanual_systemfilename" style="margin: 27px 20px 10px 0;">상품이미지</label>
			<label for="spinnerImgQty">파일갯수 : </label>
	    <input id="spinnerImgQty" value="0" style="width: 30px; ">
	    <div id="divfileattach"></div>
	    <input type="hidden" name="attachCount" id="attachCount" />
		<hr>

		<div class="text-right" style="margin-top: 30px;">
		 <input type="button" id="btnRegister" class="btn-secondary" value="등록" style="margin-left: 5px;" /> 
          &nbsp;
     <input type="reset" value="취소" 	style="margin-right: 0" />&nbsp;
		</div>
	</form>

</div>

<%@ include file="../footer.jsp"%>