<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>

<style type="text/css">

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

button.order {
	background-color: transparent; 
  	border-style: none;
}

.badges {
	display: inline-block;
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

let snum;
let cnum;
let currentShowPageNo;
let currentCatePage;

$(function(){
	
	snum = "${requestScope.snum}";
	cnum = "${requestScope.cnum}";
	currentCatePage = "${requestScope.currentCatePage}";
	currentShowPageNo = "${currentShowPageNo}";
	
	// 정렬 버튼 클릭시 이벤트
	 $(".order").click((e)=>{
		 order = $(e.target).attr('id'); // 정렬기준
		// 목록 가져오기
		orderProduct(order);
		
		// 페이지바 가져오기
		PageBar();
	}); 
	
});
	
	
// 상품 목록 가져오기
function orderProduct(order) {
	 //console.log("${requestScope.currentCatePage}");
	
	 $.ajax({
           url: "<%= ctxPath%>/shop/productTeaJSON.tea",
           type: "get",
           data: {"cnum":cnum, "snum":snum, 
        	      "order":order,
			      "currentCatePage":currentCatePage,
			      "currentShowPageNo":currentShowPageNo},
           dataType: "json",
           success:function(json){
           	let html = "";
         	
        		$.each(json, function(index, item){
      				
      			html += 
   	  		'<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">'+
   	    	'<a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}">'+
   	    	'<img src="../images/'+item.pimage+'"class="card-img-top"/></a>'+
       		'<div class="card-body">';
       			
       		if(item.sname=='BEST'){
   				html +=
      				' <div class="badges rounded text-light text-center mb-2 badge-danger" style="width:70px; font-weight:bold;">'+
      				item.sname+'</div>';
       		}
  				else if(item.sname=='NEW'){
  					html +=
     				' <div class="badges rounded text-light text-center mb-2" style="width:70px; font-weight:bold; background-color: #1E7F15;">'+
     				item.sname+'</div>';
  				}
  				else if(item.sname==null){
  					html += ' <div class="badges mb-2">&nbsp;</div>';
  				}
   				
   				if(item.pqty==0) {
  						html += ' <div class="badges rounded text-light text-center mb-2 badge-dark"style="width: 70px; font-weight: bold; ">품절</div>';
   				}
       				
       				html += ' <h5 class="card-title" style="font-weight:bold;"><a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}">'+item.pname+'</a></h5>'+
       						' <p class="card-text">'+item.saleprice+'원</p>'+
	    	      			
	    	      			
	    	      			' <a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>'+
	    	      			' <a class="card-text text-secondary mr-5">찜하기</a>'+
	    	      							      			
	    	      			' <a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>'+
	    	      			' <a class="card-text text-secondary">담기</a>'+
   	      			
   	   			'</div> </div>';
            		}); 
   	         	
   	         	$("#teaProductList").html(html);
   	         	//페이지 구간 하나 정해주고 $("#페이지").html(pageinfo);
   	         	
   	    		$('i.heart').click(function() {
   	    	        $(this).removeClass("text-secondary");
   	    	        $(this).addClass("text-danger");
   	    	    })
           },
           
           error: function(request, status, error){
           	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
           }
    });
	
}// end of function orderProduct(order) {}--------------------


	
//페이지바 가져오기	
function PageBar() {
	
	
	
}// end of function PageBar() {}--------------------
	
	


</script>


<div class="container productListContainer">
<div><img src= "../images/tea_header_img.png" width=100%/></div>
    
   <div class="row">
     	<%-- 사이드 메뉴 시작 --%>
      	<div class="col-md-2" id="sideinfo" style="padding-left: 2%;  margin-top: 1.8%;">
		<div style="text-align: left; padding: 5%;">
           	<span class="h4" style="font-weight:bold;">티 제품</span>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a href="<%= ctxPath %>/shop/productAll.tea">전체 상품</a>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a href="<%= ctxPath %>/shop/productBest.tea?snum=2">베스트</a>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a href="<%= ctxPath %>/shop/productCategory.tea?cnum=1">녹차/말차</a>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a href="<%= ctxPath %>/shop/productCategory.tea?cnum=2">홍차</a>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a href="<%= ctxPath %>/shop/productCategory.tea?cnum=3">허브차</a>
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
				<button type="button" class="order" onclick="orderProduct('pnum desc')">신상품순</button>
				<span class="text-dark">|</span>
				<button type="button" class="order" onclick="orderProduct('saleprice desc')">높은가격순</button>
				<span class="text-dark">|</span>
				<button type="button" class="order" onclick="orderProduct('saleprice asc')">낮은가격순</button>
				<span class="text-dark">|</span>
				<button type="button" class="order" onclick="orderProduct('reviewCnt desc')">리뷰많은순</button>
				<span class="text-dark">|</span>
				<button type="button" class="order" onclick="orderProduct('orederCnt desc')">판매순</button>
			</span>
    	    <%-- 본문 내부 상단 바 끝 --%>
			
			<hr>

			<%-- === 특정 카테고리에 속하는 제품들을 페이지바를 사용한 페이징 처리하여 조회(select) 해온 결과 === --%>
			<div>
			  <c:if test="${not empty requestScope.productList}">  <%-- productList 비어있지 않을경우 --%>
			
				<%-- 상품 목록 시작 --%>
				<div id="teaProductList" class="row"> 
					<c:forEach var="pvo" items="${requestScope.productList}" varStatus="status">
					<%-- ★ 여기서부터 아래의 별까지 for문으로 반복해서 출력. 별 안쪽이 상품하나. --%>
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
			   					<div class="mb-2" ></div>
			   				</c:if>
			   			
			     		    <h5 class="card-title" style="font-weight:bold;"><a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}">${pvo.pname}</a></h5>
			      			<p class="card-text"><fmt:formatNumber value="${pvo.saleprice}" pattern="#,###" /> 원</p>
			      			
			      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>
			      			<a class="card-text text-secondary mr-5">찜하기</a>
			      							      			
			      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>
			      			<a class="card-text text-secondary">담기</a>
			   			</div>
			  		</div>
			  		</c:forEach>
			 		</div>
			 		
				  </c:if>
			
				  <c:if test="${empty requestScope.productList}">  <%-- productList 비어있을 경우 --%>
					상품 준비중입니다.
				  </c:if>
			  	 <%-- ★ 여기까지! --%>
			</div>
			<%-- 상품 목록 끝 --%>	
			
		</div>
      	<%-- 본문 끝 --%>
		
	    </div>  
   </div>
</div>

<%-- 페이징 --%>
<div id="div_pageBar">
	<nav aria-label="Page navigation example">
		   <ul class="pagination justify-content-center" style="margin: auto; margin-top: 100px;">${pageBar}</ul>  <%-- 하단에 페이지바 생성함. MallByCategory.java 클래스로 부터 받아옴. --%>
	</nav>
</div>

<%@ include file="../footer.jsp"%>

