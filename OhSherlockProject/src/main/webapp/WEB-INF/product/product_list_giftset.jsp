<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@ include file="../header.jsp"%>

<%@ page import="common.model.ProductVO" %>

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

<script>

let cnum;
let currentShowPageNo;
let order;
let jsonPageBar;

$(()=>{
	cnum = "${cnum}";
	currentShowPageNo = "${currentShowPageNo}";
	
	// 정렬 버튼 클릭시 이벤트
	 $(".order").click((e)=>{
		 order = $(e.target).attr('id'); // 정렬기준
		// 목록 가져오기
		getOrderedList();
		
		// 페이지바 가져오기
		getPageBar();
	}); 
	
});

// 목록 가져오기
function getOrderedList() {
	
	$.ajax({
		url:"<%=ctxPath%>/shop/productGiftSetJSON.tea",
		type:"get",
		data:{"cnum":cnum, "order":order, "currentShowPageNo":currentShowPageNo},
		dataType:"JSON",
		success:function(json){
	        let html = "";
	         	
     		$.each(json, function(index, item){
   				
   			html += 

	  		'<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">'+
	    	'<a href="">'+
	    	'<img src="../images/'+item.pimage+'" class="card-img-top"/></a>'+
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
				
				if(item.pqty==0)
						html +=
			' <div class="badges rounded text-light text-center mb-2 badge-dark"style="width: 70px; font-weight: bold; ">품절</div>';
					
    				
    				html += ' <h5 class="card-title" style="font-weight:bold;"><a href="#">'+item.pname+'</a></h5>'+
	      			' <p class="card-text">'+item.price.toLocaleString('en')+'원</p>'+
	      			
	      			
	      			' <a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart"></i></a>'+
	      			' <a class="card-text text-secondary mr-5">찜하기</a>'+
	      							      			
	      			' <a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg "></i></a>'+
	      			' <a class="card-text text-secondary">담기</a>'+
	      			
	   			'</div> </div>';
         		}); 
	         	
	         	$("#giftSetList").html(html);
	         	
	    		$('i.heart').click(function() {
	    	        $(this).removeClass("text-secondary");
	    	        $(this).addClass("text-danger");
	    	    })
		},
		error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
	});
	
}

// 페이지바 가져오기
function getPageBar() {
	
	$.ajax({
		url:"<%=ctxPath%>/shop/pageBarJSON.tea",
		type:"get",
		data:{"cnum":cnum, "currentShowPageNo":currentShowPageNo},
		dataType:"JSON",
		success:function(json){
			
			// 기존 페이지바 숨기기
			$("nav#nav_pageBar").hide();
			
			// json으로 받아온 페이지바
			jsonPageBar = json.pageBar;
			let html = '<nav id="nav_pageBar" aria-label="Page navigation example">'+
			'<ul id="jsonPageBar" class="pagination justify-content-center">'+jsonPageBar+'</ul></nav>';
			
			// json 페이지바 표시 
			$("#div_pageBar").html(html);
	        
			// 현재 페이지 active
			$("button.ajaxPage[id='"+currentShowPageNo+"']").parent().addClass('active');
			
	        // 제이슨 페이지바 클릭이벤트
	    	$("button.ajaxPage").click((e)=>{
	    		currentShowPageNo = $(e.target).attr('id');
	    		$("button.ajaxPage").parent().removeClass('active');
	    		$(e.target).parent().addClass('active');
	    		
	    		getOrderedList();
	    	});
	        
	        // 처음페이지로 버튼 클릭시
	        $("button.first").click((e)=>{
	    		currentShowPageNo = $(e.target).attr('id');
	    		getPageBar();
	    		getOrderedList();
	    	});
	        
	     	// 이전페이지로 버튼 클릭시
	        $("button.prev").click((e)=>{
	    		currentShowPageNo = $(e.target).attr('id');
	    		getPageBar();
	    		getOrderedList();
	    	});
	        
	     	// 다음페이지로 버튼 클릭시
	        $("button.next").click((e)=>{
	    		currentShowPageNo = $(e.target).attr('id');
	    		getPageBar();
	    		getOrderedList();
	    	});
	        
	     	// 마지막페이지로 버튼 클릭시
	        $("button.last").click((e)=>{
	    		currentShowPageNo = $(e.target).attr('id');
	    		getPageBar();
	    		getOrderedList();
	    	});
	        
		},
		error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
	});
	
}


</script>
	
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
					<div id="giftSetList" class="row"> 
						
						<%-- ★ 여기서부터 아래의 별까지 for문으로 반복해서 출력. 별 안쪽이 상품하나. --%>
						<c:if test="${not empty productList}">
						<c:forEach var="pvo" items="${productList}">
				  		<div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 ">
				    		<a href="<%= ctxPath %>/product/product_view.jsp"><img src="../images/${pvo.pimage}" class="card-img-top"/></a>
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
				  		상품 준비중입니다.
				  		</c:if>
				  		<%-- ★ 여기까지! --%>
					</div>
					<%-- 상품 목록 끝 --%>					
					
				</div>
	       		<%-- 본문 끝 --%>
				
			</div>
    	    
		</div>
		<div id="div_pageBar">
			<nav id="nav_pageBar" aria-label="Page navigation example">
				<ul id = "originPageBar" class="pagination justify-content-center">${pageBar}</ul>
			</nav>
		</div>
	</div>
	
<%@ include file="../footer.jsp"%>

