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
</style>
	
	<div class="container productListContainer">
		<div><img src= "../images/tea_header_img.png" width=100%/></div>
      
		<div class="row">
	      	<%-- 사이드 메뉴 시작 --%>
	       	<div class="col-md-2" id="sideinfo" style="padding-left: 2%;  margin-top: 1.8%;">
				<div style="text-align: left; padding: 5%;">
	            	<span class="h4" style="font-weight:bold;">티 제품</span>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a href="#">전체 상품</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a href="#">베스트</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a href="#">녹차/말차</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a href="#">홍차</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:10%;">
	            	<a href="#">허브차</a>
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
				  		<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">
				    		<a href="<%= ctxPath %>/product/product_view.jsp"><img src="../images/tea_set.png" class="card-img-top"/></a>
			    			<div class="card-body">
			    				<%-- 여기는 c:if문 사용하여 경우의 수에 따라 다르게 div 출력 --%>
			    				<%-- 베스트, 품절, 공백으로 if 문 3개 사용. 카드 하나당 높이 동일하게 사용하기 위해서 &nbsp;(공백) 사용 --%>
			    				<div class="rounded text-light text-center mb-2" style="width:70px; font-weight:bold; background-color: #1E7F15;">베스트</div>
			    			
			      				<h5 class="card-title" style="font-weight:bold;"><a href="#">프리미엄 티 세트</a></h5>
				      			<p class="card-text">25,000원</p>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
				      			<a class="card-text text-secondary mr-5">25</a>
				      							      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
				      			<a class="card-text text-secondary">담기</a>
				      			
				   			</div>
				  		</div>
				  		<%-- ★ 여기까지! --%>
				  		
				  		<div class="card border-0 col-lg-4 col-md-6 ">
				    		<a href="#"><img src="../images/tea_set.png" class="card-img-top"/></a>
			    			<div class="card-body">
			    				<%-- 여기는 c:if문 사용하여 경우의 수에 따라 다르게 div 출력 --%>
			    				<div class="bg-dark text-light rounded text-center mb-2" style="width:70px; font-weight:bold;">품절</div>
			    			
			      				<h5 class="card-title" style="font-weight:bold;"><a href="#">프리미엄 티 세트</a></h5>
			      				<p class="card-text">
			      					<%-- if 문으로 세일일 경우만 표시해 주기 --%>
				      				<span class="card-text" style="text-decoration-line: line-through;">25,000원</span>
				      				<span class="card-text" style="color: #1E7F15; font-weight:bold;">25,000원</span>
				      			</p>
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
				      			<a class="card-text text-secondary mr-5">25</a>
				      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
				      			<a class="card-text text-secondary">담기</a>
				   			</div>
				  		</div>
				  		<div class="card border-0 col-lg-4 col-md-6 ">
				    		<a href="#"><img src="../images/tea_set.png" class="card-img-top"/></a>
			    			<div class="card-body">
			    				<%-- 여기는 c:if문 사용하여 경우의 수에 따라 다르게 div 출력 --%>
			    				<div class=" rounded text-center mb-2" style="width:70px; font-weight:bold;">&nbsp;</div>
			    				
			      				<h5 class="card-title" style="font-weight:bold;"><a href="#">프리미엄 티 세트</a></h5>
				      			<p class="card-text">25,000원</p>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
				      			<a class="card-text text-secondary mr-5">25</a>
				      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
				      			<a class="card-text text-secondary">담기</a>
				   			</div>
				  		</div>
					
					
						<div class="card border-0 col-lg-4 col-md-6 ">
				    		<a href="#"><img src="../images/tea_set.png" class="card-img-top"/></a>
			    			<div class="card-body">
			    				<%-- 여기는 c:if문 사용하여 경우의 수에 따라 다르게 div 출력 --%>
			    				<div class=" rounded text-center mb-2" style="width:70px; font-weight:bold;">&nbsp;</div>
			    				
			      				<h5 class="card-title" style="font-weight:bold;"><a href="#">프리미엄 티 세트</a></h5>
				      			<p class="card-text">25,000원</p>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
				      			<a class="card-text text-secondary mr-5">25</a>
				      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
				      			<a class="card-text text-secondary">담기</a>
				   			</div>
				  		</div>
				  		<div class="card border-0 col-lg-4 col-md-6 ">
				    		<a href="#"><img src="../images/tea_set.png" class="card-img-top"/></a>
			    			<div class="card-body">
			    				<%-- 여기는 c:if문 사용하여 경우의 수에 따라 다르게 div 출력 --%>
			    				<div class=" rounded text-center mb-2" style="width:70px; font-weight:bold;">&nbsp;</div>
			    				
			      				<h5 class="card-title" style="font-weight:bold;"><a href="#">프리미엄 티 세트</a></h5>
				      			<p class="card-text">25,000원</p>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
				      			<a class="card-text text-secondary mr-5">25</a>
				      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
				      			<a class="card-text text-secondary">담기</a>
				   			</div>
				  		</div>
				  		<div class="card border-0 col-lg-4 col-md-6 ">
				    		<a href="#"><img src="../images/tea_set.png" class="card-img-top"/></a>
			    			<div class="card-body">
			    				<%-- 여기는 c:if문 사용하여 경우의 수에 따라 다르게 div 출력 --%>
			    				<div class=" rounded text-center mb-2" style="width:70px; font-weight:bold;">&nbsp;</div>
			    				
			      				<h5 class="card-title" style="font-weight:bold;"><a href="#">프리미엄 티 세트</a></h5>
				      			<p class="card-text">25,000원</p>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
				      			<a class="card-text text-secondary mr-5">25</a>
				      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
				      			<a class="card-text text-secondary">담기</a>
				   			</div>
				  		</div>
						
					</div>
					<%-- 상품 목록 끝 --%>					
					
				</div>
	       		<%-- 본문 끝 --%>
				
			</div>
    	    
		</div>
		

	      
	</div>
	

<%@ include file="../footer.jsp"%>