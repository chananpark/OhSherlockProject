<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>

.productListContainer div.content {
  margin-left: 200px;
  padding: 1px 16px;
  height: 1000px;
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

a, a:hover, a:link, a:visited {
	color: black;
	text-decoration: none;
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

button.order {
	background-color: transparent; 
  	border-style: none;
}
</style>

<div class="container">

	<div >
      <h2 style="font-weight: bold;">상품 검색</h2>
      <br>
      <hr style="background-color: black; height: 1.2px;"><br>
    </div> 
    
	
	<div id="maincontent">
   	    <%-- 본문 내부 상단 바 시작 --%>
		<span class="text-dark h6"><span class="font-weight-bold" style="color:#1E7F15">${searchWord}</span> 검색 결과 
		<span class="font-weight-bold" style="color:#1E7F15">0</span>건</span>
		
		<%-- 정렬 선택 창 --%>
		<div class="text-right" style="float: right;">
		<button type="button" class="order" id="pnum desc">신상품순</button>
		<span class="text-dark">&nbsp;|&nbsp;</span>
		<button type="button" class="order" id="price desc">높은가격순</button>
		<span class="text-dark">&nbsp;|&nbsp;</span>
		<button type="button" class="order" id="price asc">낮은가격순</button>
		<span class="text-dark">&nbsp;|&nbsp;</span>
		<button type="button" class="order" id="reviewCnt desc">리뷰많은순</button>
		<span class="text-dark">&nbsp;|&nbsp;</span>
		<button type="button" class="order" id="orederCnt desc">판매순</button>
		</div>
   	    <%-- 본문 내부 상단 바 끝 --%>
		
		<hr>
		
		<%-- 상품 목록 시작 --%>
		<div id="giftSetList" class="row col"> 
			
			<%-- ★ 여기서부터 아래의 별까지 for문으로 반복해서 출력. 별 안쪽이 상품하나. --%>
			<c:if test="${not empty productList}">
			<c:forEach var="pvo" items="${productList}">
	  		<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">
	    		<a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}"><img src="../images/${pvo.pimage}" class="card-img-top"/></a>
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
    				<div class="badges mb-2" >&nbsp;</div>
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
	  		<div class="text-center mt-4" style="width:100%">해당하는 상품이 없습니다.</div>
	  		</c:if>
	  		<%-- ★ 여기까지! --%>
		</div>
		<%-- 상품 목록 끝 --%>					
		
	</div>
	
</div>	
<%@ include file="../footer.jsp"%>