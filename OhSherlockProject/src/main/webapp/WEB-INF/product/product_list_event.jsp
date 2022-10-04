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
	

</style>


<script type="text/javascript">

	$(document).ready(function(){
		
		$('i.heart').click(function() {
	        $(this).removeClass("text-secondary");
	        $(this).addClass("text-danger");
	    });
	    
		
	    <%-- 클릭이벤트 바인딩 --%>
		$(".productListContainer #sideinfo a").click(function(e){
			$(".productListContainer #sideinfo a").removeClass("add_button_color");
			$(e.target).addClass("add_button_color");
			
			//$(".productListContainer #sideinfo a").css({'background-color':'', 'color':''});
	      //  $(e.target).css({'background-color':'blue', 'color':'white'});
		});
		
		
		$(".productListContainer #allProd").click();  
		
	}); // end of $(document).ready
	
	
</script>



<div class="container productListContainer">
	<div><img src= "../images/이벤트배너.png" width=100%/></div>
     
	<div class="row">
      	<%-- 사이드 메뉴 시작 --%>
       	<div class="col-md-2" id="sideinfo" class="sidebar" style="padding-left: 2%;  margin-top: 1.8%;">
			<div style="text-align: left; padding: 5%;">
            	<span class="h4" style="font-weight:bold;">이벤트상품</span>
         	</div>
         	<a style="padding: 5%; font-weight:bold;" id="allProd" href="<%= ctxPath %>/shop/productEvent.tea">전체 상품</a>
         	<hr>
         	<div style="padding: 5%; font-weight:bold;">단품</div>
         	<div style="text-align: left; padding: 4%; margin-left:10%;">
            	<a id="bestProd" href="<%=ctxPath%>/shop/productEvent_best.tea">베스트</a>
         	</div>
         	<c:forEach var="map" items="${requestScope.prodCategoryList}">
         	<div style="text-align: left; padding: 4%; margin-left:10%;">
            	<a id="greenProd" href="<%=ctxPath%>/shop/productEvent_category.tea?cnum=${map.cnum}">
	            	<c:if test="${map.cname eq 'greentea'}">녹차/말차</c:if>
	            	<c:if test="${map.cname eq 'blacktea'}">홍차</c:if>
	            	<c:if test="${map.cname eq 'herbtea'}">허브차</c:if>
            	</a>
         	</div>
         	</c:forEach>
         	
         	<hr>
         	<div style="padding: 5%; font-weight:bold;">세트</div>
         	<div style="text-align: left; padding: 4%; margin-left:10%;">
            	<a id="herbProd">기프트세트</a>
         	</div>
       	</div>
   	    <%-- 사이드 메뉴 끝 --%>
   	    
       	<div class="col-md-10" id="maininfo" style="padding: 2.5%;">
       		<%-- 본문 시작 --%>
			<div id="maincontent">
	    	    <%-- 본문 내부 상단 바 시작 --%>
				<span class="text-dark h5" style="font-weight:bold;">전체상품</span>
				
				<%-- 정렬 선택 창 --%>
				<span id="order_list">
					<span id="newProd">신상품순</span>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<span id="highPrice">높은가격순</span>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<span id="rowPrice">낮은가격순</span>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<span id="review">리뷰많은순</span>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<span id="sellList">판매순</span>
				</span>
	    	    <%-- 본문 내부 상단 바 끝 --%>
				
				<hr>
				
				<%-- 상품 목록 시작 --%>
				<div class="row" id="eventProdList"> 
					
					<c:forEach var="pvo" items="${requestScope.productList}" varStatus="status">
				  		<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">
			    		<a href="<%= ctxPath %>/product/product_view.jsp"><img src="<%= ctxPath %>/images/${pvo.pimage}" class="card-img-top"/></a>
		    			<div class="card-body">
		    			
		    				<%-- 상품 상태 뱃지 --%>
		    				<c:if test="${not empty pvo.spvo.sname}">
	                            <c:if test="${pvo.spvo.sname eq 'BEST'}">
		                            <div class="rounded text-light text-center mb-2 badge-danger" style="width:70px; font-weight:bold;">
		                            ${pvo.spvo.sname}
		                            </div>
	                            </c:if>
	                            <c:if test="${pvo.spvo.sname eq 'NEW'}">
		                            <div class="rounded text-light text-center mb-2" style="width:70px; font-weight:bold; background-color: #1E7F15;">
		                            ${pvo.spvo.sname}
		                            </div>
	                            </c:if>
	                        </c:if>
	                        <c:if test="${empty pvo.spvo.sname}">
	                        <div class="mb-2" >&nbsp;</div>
                         	</c:if>
		    			
		      				<h5 class="card-title" style="font-weight:bold;"><a href="#">${pvo.pname}</a></h5>
			      			
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
			      							      			
			      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
			      			<a class="card-text text-secondary">담기</a>
			      			
			   			</div>
			  		</div>
			  		</c:forEach>
			  		
				</div>
				<%-- 상품 목록 끝 --%>					
				
			</div>
       		<%-- 본문 끝 --%>
			
		</div>
   	    
	</div>
	
</div>

	<%-- 페이징 --%>
 	<nav aria-label="Page navigation example" >
		<ul class="pagination justify-content-center" style="margin:auto;">${requestScope.pageBar}</ul>
	</nav>
	
<%@ include file="../footer.jsp"%>