<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@ include file="../header.jsp"%>

<script type="text/javascript">

	$(document).ready(function(){
		
		$('i.heart').click(function() {
	        $(this).removeClass("text-secondary");
	        $(this).addClass("text-danger");
	    })
		
		
	}); // end of $(document).ready
	
	
</script>

<style>

.productListContainer .sidebar {
  margin: 0;
  padding: 0;
  width: 200px;
  background-color: #f1f1f1;
  position: fixed;
  height: 100%;
  overflow: auto;
}

.productListContainer .sidebar a {
  display: block;
  color: black;
  padding: 16px;
  text-decoration: none;
}
 
.productListContainer .sidebar a.active {
  background-color: #04AA6D;
  color: white;
}

.productListContainer .sidebar a:hover:not(.active) {
  background-color: #555;
  color: white;
}

.productListContainer div.content {
  margin-left: 200px;
  padding: 1px 16px;
  height: 1000px;
}

@media screen and (max-width: 700px) {
  .sidebar {
    width: 100%;
    height: auto;
    position: relative;
  }
  .sidebar a {float: left;}
  div.content {margin-left: 0;}
}

@media screen and (max-width: 400px) {
  .sidebar a {
    text-align: center;
    float: none;
  }
}

#order_list {
	display: flex;
  	justify-content: flex-end;
}

.productListContainer a:link, .productListContainer a:visited {
	color: black;
}

.productListContainer a:hover {
	cursor: pointer;
	text-decoration-line: none;
	color: #1E7F15;
}

.badges {
	display: inline-block;
}
</style>
	
	<div class="container productListContainer">
		<div><img src= "../images/tea_header_img.png" width=100%/></div>
      
		<div class="row">
	      	<%-- 사이드 메뉴 시작 --%>
	       	<div class="col-md-2" id="sideinfo" style="padding-left: 2%;  margin-top: 1.8%;">
				<div style="text-align: left; padding: 5%;">
	            	<span class="h4" style="font-weight:bold;">기프트세트</span>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a href="<%= ctxPath %>/shop/productGiftset.tea">전체 상품</a>
	         	</div>
	         	<c:forEach var="map" items="${giftsetCategoryList}">
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a href="<%= ctxPath %>/shop/productGiftset.tea?cnum=${map.cnum}">${map.cname}</a>
	         	</div>
	         	</c:forEach>
	       	</div>
    	    <%-- 사이드 메뉴 끝 --%>
    	    
	       	<div class="col-md-10" id="maininfo" style="padding: 2.5%;">
	       		<%-- 본문 시작 --%>
				<div id="maincontent">
		    	    <%-- 본문 내부 상단 바 시작 --%>
					<span class="text-dark h5" style="font-weight:bold;">전체상품</span>
					
					<%-- 정렬 선택 창 --%>
					<span id="order_list">
						<a href="#">신상품순</a>
						<span class="text-dark">&nbsp;|&nbsp;</span>
						<a href="#">높은가격순</a>
						<span class="text-dark">&nbsp;|&nbsp;</span>
						<a href="#">낮은가격순</a>
						<span class="text-dark">&nbsp;|&nbsp;</span>
						<a href="#">리뷰많은순</a>
						<span class="text-dark">&nbsp;|&nbsp;</span>
						<a href="#">판매순</a>
					</span>
		    	    <%-- 본문 내부 상단 바 끝 --%>
					
					<hr>
					
					<%-- 상품 목록 시작 --%>
					<div class="row"> 
						
						<%-- ★ 여기서부터 아래의 별까지 for문으로 반복해서 출력. 별 안쪽이 상품하나. --%>
						<c:if test="${not empty productList }">
						<c:forEach var="pvo" items="${productList }">
				  		<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">
				    		<a href="<%= ctxPath %>/product/product_view.jsp"><img src="../images/giftset/${pvo.pimage}" class="card-img-top"/></a>
			    			<div class="card-body">
			    				
			    				<c:if test="${not empty pvo.spvo.sname}">
			    					<c:if test="${pvo.spvo.sname eq 'BEST'}">
				    				<div class="badges rounded text-light text-center mb-2 badge-danger" style="width:70px; font-weight:bold;">
				    				${pvo.spvo.sname}
				    				</div>
				    				</c:if>
			    					<c:if test="${pvo.spvo.sname eq 'NEW'}">
				    				<div class="badges rounded text-light text-center mb-2" style="width:70px; font-weight:bold; background-color: #1E7F15;">
				    				${pvo.spvo.sname}
				    				</div>
				    				</c:if>
			    				</c:if>

									<c:if test="${pvo.pqty eq 0 }">
									<div class="badges rounded text-light text-center mb-2 badge-dark"style="width: 70px; font-weight: bold; ">품절</div>
									</c:if>
								
								<c:if test="${empty pvo.spvo.sname}">
			    				<div class="mb-2" ></div>
			    				</c:if>
			    				
			      				<h5 class="card-title" style="font-weight:bold;"><a href="#">${pvo.pname}</a></h5>
				      			<p class="card-text"><fmt:formatNumber value="${pvo.price}" pattern="#,###"/>원</p>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
				      			<a class="card-text text-secondary mr-5">찜하기</a>
				      							      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
				      			<a class="card-text text-secondary">담기</a>
				      			
				   			</div>
				  		</div>
				  		</c:forEach>
				  		</c:if>
				  		<c:if test="${empty productList }">
				  		상품 준비중입니다.
				  		</c:if>
				  		<%-- ★ 여기까지! --%>
				  		
						
					</div>
					<%-- 상품 목록 끝 --%>					
					
				</div>
	       		<%-- 본문 끝 --%>
				
			</div>
    	    
		</div>
	<nav aria-label="Page navigation example">
		<ul class="pagination justify-content-center">${pageBar}</ul>
	</nav>
	</div>
	
<%@ include file="../footer.jsp"%>

