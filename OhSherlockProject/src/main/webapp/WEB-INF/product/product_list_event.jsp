<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@ include file="../header.jsp"%>


<style>

#order_list {
	display: flex;
  	justify-content: flex-end;
}

a {
	color: black;
	text-decoration: none;
}

a:link {
	color: black; 
	text-decoration: none;
}

a:visited {
	color: black; 
	text-decoration: none;
}

.productListContainer a:hover {
	cursor: pointer;
	text-decoration-line: none;
	color: #1E7F15;
}

.productListContainer .add_button_color {
	color: #1E7F15;
}

.productListContainer .remove_button_color {
	color: black;	
}

.page-link {
  color: #666666; 
  background-color: #fff;
  border: 1px solid #ccc; 
}

.page-item.active .page-link {
 z-index: 1;
 color: white;
 border-color: #1E7F15;
 background-color: #1E7F15; 
 
}

.page-link:focus, .page-link:hover {
  color: #1E7F15;
  background-color: #fafafa; 
  border-color: #1E7F15;
}
	
.order {
	background-color: transparent; 
    border-style: none;
    padding: 0;
}


.selected {
	color: #1E7F15 !important;
	font-weight: bold;
}

</style>


<script type="text/javascript">

	$(document).ready(function(){
		
		$('i.heart').click(function() {
	        $(this).removeClass("text-secondary");
	        $(this).addClass("text-danger");
	    });
	    

		
		snum = "${snum}";
		cnum = "${cnum}";
		order = "${order}";

		// 상품정렬 색 변경
		document.getElementById(order).classList.add("selected");
		
		// 카테고리 색 변경
		if (snum == "2") {
			// 베스트
			$("#bestProd").addClass("selected");
		} else if(snum == "1") {
			// 신상품
			$("#newProd").addClass("selected");
		} else if(cnum == "1") {
			// 녹차
			$("#greentea").addClass("selected");
		} else if(cnum == "2") {
			// 홍차
			$("#blacktea").addClass("selected");
		} else if(cnum == "3") {
			// 허브차
			$("#herbtea").addClass("selected");
		} else {
			// 전체
			$("#allProd").addClass("selected");
		} 
		
		// 이벤트 상품 글자 바꾸기
		if (snum == "2") {
			// 베스트
			$("#eventTitle").text("베스트");
		} else if(snum == "1") {
			// 신상품
			$("#eventTitle").text("신상품");
		} else if(cnum == "1") {
			// 녹차
			$("#eventTitle").text("녹차/말차");
		} else if(cnum == "2") {
			// 홍차
			$("#eventTitle").text("홍차");
		} else if(cnum == "3") {
			// 허브차
			$("#eventTitle").text("허브차");
		} else {
			// 전체
			$("#eventTitle").text("전체 상품");
		} 
		
	}); // end of $(document).ready
	
	// 장바구니 담기
	function clickCart(obj) {
		
		let $target = $(event.target);
		let pnum = $target.next().val();
		
		let frm = document.eventClickFrm;
		let hidden = frm.hidden_pnum${pvo.pnum}.value;
		
		frm.method = "POST"; 
		frm.action = "<%=request.getContextPath()%>/cart/cartAdd.tea";
		frm.submit();
		
	} // end of function goCart()
	
	
</script>



<form name="eventClickFrm">

<div class="container productListContainer">
	<div><img src= "../images/이벤트배너.png" width=100%/></div>
     
	<div class="row">
      	<%-- 사이드 메뉴 시작 --%>
       	<div class="col-md-2" id="sideinfo" class="sidebar" style="padding-left: 2%;  margin-top: 1.8%;">
			<div style="text-align: left; padding: 5%;" >
            	<span class="h4" style="font-weight:bold;">이벤트상품</span>
         	</div>
         	
         	<div style="padding: 4%; margin-left:10%; ">
        		<a id="allProd" href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=&cnum=&order=pinputdate desc">전체 상품</a>
       		</div>
         	<div style="padding: 4%; margin-left:10%;">
         		<a id="bestProd" href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=2&cnum=&order=pinputdate desc" >베스트</a>
       		</div>
         	<div style="padding: 4%; margin-left:10%;">
         		<a id="newProd" href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=1&cnum=&order=pinputdate desc">신상품</a>
    		</div>
    		<div style="padding: 4%; margin-left:10%;">
         		<a id="greentea" href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=&cnum=1&order=pinputdate desc">녹차/말차</a>
    		</div>
    		<div style="padding: 4%; margin-left:10%;">
         		<a id="blacktea" href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=&cnum=2&order=pinputdate desc">홍차</a>
    		</div>
    		<div style="padding: 4%; margin-left:10%;">
         		<a id="herbtea" href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=&cnum=3&order=pinputdate desc">허브차</a>
    		</div>
         	

       	</div>
   	    <%-- 사이드 메뉴 끝 --%>
   	    
       	<div class="col-md-10" id="maininfo" style="padding: 2.5%;">
       		<%-- 본문 시작 --%>
			<div id="maincontent">
	    	    <%-- 본문 내부 상단 바 시작 --%>
				<span id="eventTitle" class="text-dark h5" style="font-weight:bold;"></span>
				
				<%-- 정렬 선택 창 --%>
				<span id="order_list" >
					<a id="pinputdate desc" class="order"  href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=${snum}&cnum=${cnum}&order=pinputdate desc">신상품순</a>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<a id="saleprice desc" class="order"  href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=${snum}&cnum=${cnum}&order=saleprice desc">높은가격순</a>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<a id="saleprice asc" class="order"  href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=${snum}&cnum=${cnum}&order=saleprice asc">낮은가격순</a>
					<span class="text-dark" >&nbsp;|&nbsp;</span>
					<a id="reviewCnt desc" class="order"  href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=${snum}&cnum=${cnum}&order=reviewCnt desc">리뷰많은순</a>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<a id="orederCnt desc" class="order" href="<%= ctxPath %>/shop/eventOrderList.tea?currentShowPageNo=${currentShowPageNo}&snum=${snum}&cnum=${cnum}&order=orederCnt desc">판매순</a>
				</span>
	    	    <%-- 본문 내부 상단 바 끝 --%>
		
				<hr>
				
				<%-- 상품 목록 시작 --%>
				<div class="row" id="eventProdList"> 
					
					<c:forEach var="pvo" items="${requestScope.productList}" varStatus="status">
				  		<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">
				    		<a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}"><img src="<%= ctxPath %>/images/${pvo.pimage}" class="card-img-top"/></a>
			    			<div class="card-body">
			    			
			    				<%-- 상품 상태 뱃지 --%>
			    				<c:if test="${not empty pvo.spvo.sname}">
		                            <c:if test="${pvo.spvo.sname eq 'BEST'}">
			                            <div class="rounded text-light text-center mb-2 badge-danger" style="width:70px; font-weight:bold; display:inline-block;">
			                            ${pvo.spvo.sname}
			                            </div>
		                            </c:if>
		                            <c:if test="${pvo.spvo.sname eq 'NEW'}">
			                            <div class="rounded text-light text-center mb-2" style="width:70px; font-weight:bold; background-color: #1E7F15; display:inline-block;">
			                            ${pvo.spvo.sname}
			                            </div>
		                            </c:if>
		                        </c:if>
		                        <c:if test="${empty pvo.spvo.sname}">
		                        <div class="mb-2" >&nbsp;</div>
	                         	</c:if>
	                         	 <c:if test="${pvo.pqty eq 0}">
	                            	<div class="rounded text-light text-center mb-2 badge-dark" style="width:70px; font-weight:bold; display:inline-block;">
		                            품절
		                            </div>
	                            </c:if>
	                         	
			    			
			      				<h5 class="card-title" style="font-weight:bold;"><a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}">${pvo.pname}</a></h5>
				      			
				      			<%-- 세일 상품 금액 표시 --%>
				      			<c:choose>
				      				<c:when test="${pvo.price != pvo.saleprice}">
				      					<p>
							      			<span class="card-text" style="text-decoration-line: line-through;"><fmt:formatNumber value="${pvo.price}" pattern="###,###"/>원</span>
						      				<span class="card-text" style="color: #1E7F15; font-weight:bold;"><fmt:formatNumber value="${pvo.saleprice}" pattern="###,###"/>원</span>
					      				</p>
				      				</c:when>
				      				<c:otherwise>
				      				
				      				</c:otherwise>
				      			</c:choose>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
				      			<a class="card-text text-secondary mr-5">찜하기</a>
				      			<a class="card-text mr-2 clickCart" onClick="clickCart(this);"><i class="fas fa-shopping-basket text-secondary " ></i></a>
				      			<a class="card-text text-secondary clickCart" onClick="clickCart(this);">담기</a>
				      			<input type="text" name="hidden_pnum" id="hidden_pnum${pvo.pnum}" value="${pvo.pnum}" />
				   			</div>
			  			</div>
			  		</c:forEach>
			  		
				</div>
				<%-- 상품 목록 끝 --%>					
				
				<%-- 페이징 --%>
				<div id="div_pagebar">
				 	<nav aria-label="Page navigation example" id="nav_pagebar" style="margin-top : 100px;">
						<ul class="pagination justify-content-center" style="margin:auto;">${requestScope.pageBar}</ul>
					</nav>
				</div>
			</div>
       		<%-- 본문 끝 --%>
			
		</div>

	</div>
	
</div>

</form>			
	
<%@ include file="../footer.jsp"%>