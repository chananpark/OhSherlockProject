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
	
	// 정렬하기 클릭했을 때의 이벤트
	function order_list(selectid) {
		let html = "";
		
		$.ajax({
			url: "<%= request.getContextPath()%>/shop/eventOrderListJSON.tea",
			type: "GET",
			data: {"selectid":selectid},
			dataType: "JSON",
			success: function(json){
				
				if( json.length == 0 ) { 
					html += " "; // 나중에 적어줘야하는데 여기 적어주면 에러나니까 그냥 자주묻는 질문은 무조건 다 나오는 걸로 하는 건 어떤지..?
	                
	                $("div#eventProdList").html(html);
	                
				} else if( json.length > 0 ) {	
				
					 
					
				} // end of if( json.length == 0 ) - else
			},
			error: function(request, status, error){
	        	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		}); // end of $.ajax
		
		
	} // end of function order_list(selectid)
	
	
	
</script>



<div class="container productListContainer">
	<div><img src= "../images/이벤트배너.png" width=100%/></div>
     
	<div class="row">
      	<%-- 사이드 메뉴 시작 --%>
       	<div class="col-md-2" id="sideinfo" class="sidebar" style="padding-left: 2%;  margin-top: 1.8%;">
			<div style="text-align: left; padding: 5%; margin-bottom: 20px;" >
            	<span class="h4" style="font-weight:bold;">이벤트상품</span>
         	</div>
         	<div style="padding: 3%; font-weight:bold;"><a id="allProd" href="<%= ctxPath %>/shop/productEvent.tea">전체 상품</a></div>
         	<div style="padding: 3%; font-weight:bold;"><a id="bestProd" href="<%= ctxPath %>/shop/productEvent_spec.tea?snum=2">베스트</a></div>
         	<div style="padding: 3%; font-weight:bold;"><a id="newProd" href="<%= ctxPath %>/shop/productEvent_spec.tea?snum=1">신상품</a></div>
         	<hr>
         	<div style="padding: 5%; font-weight:bold;">단품</div>
         	<div style="text-align: left; padding: 4%; margin-left:10%;">
            	<a id="bestProd" href="<%=ctxPath%>/shop/productEvent_category.tea?cnum=1">녹차/말차</a>
         	</div>
         	<div style="text-align: left; padding: 4%; margin-left:10%;">
            	<a id="bestProd" href="<%=ctxPath%>/shop/productEvent_category.tea?cnum=2">홍차</a>
         	</div>
         	<div style="text-align: left; padding: 4%; margin-left:10%;">
            	<a id="bestProd" href="<%=ctxPath%>/shop/productEvent_category.tea?cnum=3">허브차</a>
         	</div>

         	<hr>
         	<div style="padding: 5%; font-weight:bold;">세트</div>
         	<div style="text-align: left; padding: 4%; margin-left:10%;">
            	<a id="herbProd" href="<%=ctxPath%>/shop/productEvent_category.tea?cnum=4">기프트세트</a>
         	</div>
       	</div>
   	    <%-- 사이드 메뉴 끝 --%>
   	    
       	<div class="col-md-10" id="maininfo" style="padding: 2.5%;">
       		<%-- 본문 시작 --%>
			<div id="maincontent">
	    	    <%-- 본문 내부 상단 바 시작 --%>
				<span class="text-dark h5" style="font-weight:bold;">전체상품</span>
				
				<%-- 정렬 선택 창 --%>
				<span id="order_list" >
					<button id="order_new" class="order" onclick="order_list('order_new')">신상품순</button>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<button id="order_highPrice" class="order" onclick="order_list('order_highPrice')">높은가격순</button>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<button id="order_rowPrice" class="order" onclick="order_list('order_rowPrice')">낮은가격순</button>
					<span class="text-dark" >&nbsp;|&nbsp;</span>
					<button id="order_review" class="order" onclick="order_list('order_review')">리뷰많은순</button>
					<span class="text-dark">&nbsp;|&nbsp;</span>
					<button id="order_sell" class="order" onclick="order_list('order_sell')">판매순</button>
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
<<<<<<< HEAD
   	    
=======
		

	      
>>>>>>> branch 'main' of https://github.com/Chanan-Park/OhSherlockProject.git
	</div>
	
</div>

	<%-- 페이징 --%>
 	<nav aria-label="Page navigation example" >
		<ul class="pagination justify-content-center" style="margin:auto;">${requestScope.pageBar}</ul>
	</nav>
	
<%@ include file="../footer.jsp"%>