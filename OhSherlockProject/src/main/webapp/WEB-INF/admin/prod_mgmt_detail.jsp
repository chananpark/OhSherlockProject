<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    

<style>
	button {
		border-style: none;
	}
	
	input[type=button] {
		border-style: none;
	}
	
	#tbl_product_info td:nth-child(odd) {
	  background-color: #f2f2f2;
	  font-weight: bold;
	}
	
	textarea, input {
		vertical-align: middle;
	}
	
</style>

<script type="text/javascript">

	let goBackURL = ""; // 전역변수

	$(document).ready(function(){
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		goBackURL = "${requestScope.goBackURL}"; // MemberOneDetail에서 보내준 goBackURL 을 받아온다.
		
		// 변수 goBackURL 에 공백 " " 을 모두 "&" 로 변경하도록 한다.
		goBackURL = goBackURL.replace(/ /gi, "&"); 
		
		$("a.pname").click(function (e) {
			
			const $target = $(e.target);
			
			$target.parent().parent().find("")
		});
		
	}); // end of $(document).ready
	
	const pnum = ${requestScope.product_select_one.pnum};
	
	// function declaration
	// 상품 상세조회에서 바로 직전에 보던 목록을 보여주기(검색된 목록이라면 검색된 상품목록 보여주기)
	function goProductList() {
		location.href = "<%= request.getContextPath() %>" + goBackURL;
	} // end of function goMemberList()
	
	// 관리자 상세페이지에서 해당 상품 상세페이지를 보고 거기서 수정 버튼을 눌렸을 경우
	function goEdit() {
		location.href = "<%= request.getContextPath() %>/admin/prod_mgmt_edit.tea?pnum="+pnum+"&goBackURL=${requestScope.goBackURL}";
	} // end of function goEdit() ----
	
	// 삭제버튼을 눌렀을 경우
	function goDel() {
		
		const pnum = ${requestScope.product_select_one.pnum};
    // console.log(pnum);
    
		const bool = confirm("해당 상품을 삭제하시겠습니까?");
		   
		   if(bool) {
			   
			   $.ajax({
				   url:"<%=request.getContextPath()%>/admin/prod_mgmt_delete.tea",
				   type: "POST",
				   data:{"pnum": pnum},
				   dataType: "text",
				   success: function(json) {
					  
						  location.href = "prod_mgmt_list.tea"; 
					 
				   },
				   error: function(request, status, error){
		               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	         }
				   
			   });
			   
		   } 
		   
		   else {
			   alert("상품 삭제를 취소하셨습니다.");
			   
		   }
	}// end of function goDel()
</script>

<c:if test="${empty requestScope.product_select_one}">
	존재하지 않는 상품입니다. <br>
</c:if>

<c:if test="${not empty requestScope.product_select_one}">


<div class="container" >

	<h2 class="col text-left" style="font-weight:bold">상품정보 상세조회</h2><br>
   	<hr style="background-color: black; height: 1.2px;"><br>
  
  	<h5 style="font-weight:bold">상품정보</h5>
  	<div style="overflow-x:auto;" >
	  	<table class="table mt-4 mb-5 prodList text-left" id="tbl_product_info">
				<tbody>
					<tr>
						<td class="col-4">상품번호</td>
						<td class="col-8" class="pnum">${requestScope.product_select_one.pnum}</td>
					</tr>
					<tr>
						<td class="col-4">카테고리</td>
						<td class="col-8">${requestScope.product_select_one.categvo.cname}</td>
					</tr>
					<tr>
						<td class="col-4">상품스펙</td>
						<td class="col-8">${requestScope.product_select_one.spvo.sname}</td>
					</tr>
					<tr>
						<td class="col-4">상품명</td>
						<td class="col-8"><a class="pname">${requestScope.product_select_one.pname}</a></td>
					</tr>
					<tr>
						<td class="col-4">썸네일</td>
						<td class="col-8"><img src="<%=request.getContextPath() %>/images/${requestScope.product_select_one.pimage}" onerror="this.src='<%=request.getContextPath() %>/images/noImage.png'" style="width: 50%;"/></td>
					</tr>
					<tr>
						<td class="col-4" style="vertical-align: middle">상품한줄설명</td>
						<td class="col-8">${requestScope.product_select_one.psummary}</td>
					</tr>
					<tr>
						<td class="col-4">재고</td>
						<td class="col-8">${requestScope.product_select_one.pqty} 개</td>
					</tr>
					<tr>
						<td class="col-4">정가</td>
						<td class="col-8"><fmt:formatNumber value="${requestScope.product_select_one.price}" pattern="###,###"/> 원</td>
					</tr>
					<tr>
						<td class="col-4">판매가격</td>
						<td class="col-8"><fmt:formatNumber value="${requestScope.product_select_one.saleprice}" pattern="###,###"/> 원</td>
					</tr>
					<tr>
						<td class="col-4">적립금</td>
						<td class="col-8"><fmt:formatNumber value="${requestScope.product_select_one.point}" pattern="###,###"/> 찻잎</td>
					</tr>
					<tr>
						<td class="col-4">상품이미지</td>
						<td class="col-8">
						 <c:if test="${not empty requestScope.imgList }">
	 						<c:forEach var="map" items="${requestScope.imgList}">
								${map.imgfilename} <br>
	 							<%-- <img src="/MyMVC/images/${imgfilename}" class="img-fluid" style="width: 100%;'"/> --%>
	 						</c:forEach>
						 </c:if>
					 </td>
					</tr>
					
				</tbody>
			</table>
		</div>
  	
 
	<div class="mt-4">
  		<button class="btn float-left" onclick="goEdit()" style="background-color: #1E7F15; color:white; font-weight: bold;">
  			수정하기
		</button>
  		<button class="btn float-left ml-2" onclick="goDel()" style="background-color: #1E7F15; color:white; font-weight: bold;">
  			삭제하기
		</button>
  		<button class="btn float-right" onclick="goProductList()" style="background-color: #1E7F15; color:white; font-weight: bold;">
  			상품 목록으로 돌아가기
		</button>
  	</div>

</div>

</c:if>

<%@ include file="../footer.jsp"%>