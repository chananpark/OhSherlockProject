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

.selected {
	color: #1E7F15 !important;
	font-weight: bold;
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

input.cart { 
   background-color: transparent; 
     border-style: none;
}

</style>

<script type="text/javascript">

let cnum;
let snum;
let currentShowPageNo;
let order;
let jsonPageBar;

$(document).ready(function(){
	
	cnum = "${cnum}";  // 카테고리번호
	snum = "${snum}";  // 스펙번호(best)
	currentShowPageNo = "${currentShowPageNo}";
	
	// 찜하기(아이콘) 클릭시 색깔 변경
	$('i.heart').click(function() {
        $(this).removeClass("text-secondary");
        $(this).addClass("text-danger");
    });
	// 찜하기 클릭시 색깔 변경
	$('a.like').click(function(e) {
		const $target = $(e.target); // 이벤트가 발생되어진 곳
		$target.parent().find("i.heart").removeClass("text-secondary");
		$target.parent().find("i.heart").addClass("text-danger");
    });
	
	// 정렬 버튼 클릭시 이벤트
	 $(".order").click((e)=>{
		 order = $(e.target).attr('id'); // 정렬기준
		 
		// 목록 가져오기
		getOrderedList();
		
		// 페이지바 가져오기
		getPageBar();
		
		// 선택된 정렬 글자색, 굵게
		$(".order").removeClass("selected");
		$(e.target).addClass("selected");
	}); 
	
	// 선택된 카테고리 글자색, 굵게
	if (cnum == "" && snum == "") {
		document.getElementById("allGoods").classList.add("selected");
	} else if (cnum == "" && snum != "") {
		document.getElementById("bestGoods").classList.add("selected");
	} else if (cnum == "1" && snum == "") {
		document.getElementById("categoryGoods1").classList.add("selected");
	} else if (cnum == "2" && snum == "") {
		document.getElementById("categoryGoods2").classList.add("selected")
	} else if (cnum == "3" && snum == "") {
		document.getElementById("categoryGoods3").classList.add("selected")
	}	
	
});// end of $(document).ready(function(){}---------------------------
		

//상품 목록 가져오기
function getOrderedList() {
	
	 $.ajax({
           url: "<%= ctxPath%>/shop/productTeaJSON.tea",
           type:"get",
	   	   data:{"cnum":cnum, "order":order, "currentShowPageNo":currentShowPageNo, "snum":snum},
	   	   dataType:"JSON",
           success:function(json){
           	let html = "";
         	
           	if(json.length != 0) {
    	        
	     		$.each(json, function(index, item){
      				
	     			html += ' <div class="card border-0 mb-4 mt-1 col-lg-4 col-md-6 "> '+
		    		    	' <a href="<%= ctxPath %>/shop/productView.tea?pnum=' + item.pnum + '"> '+
		    		    	' <img src="../images/'+item.pimage+'" class="card-img-top"/></a> '+
		    	    		' <div class="card-body">';
	    	    			
    	    		if(item.sname=='BEST'){
    					html +=
    	   				' <div class="badges rounded text-light text-center mb-2 badge-danger" style="width:70px; font-weight:bold;"> '+
    	   				  item.sname+ '</div> ';
    	    		}
    				if(item.sname=='NEW'){
    					html +=
    	  				' <div class="badges rounded text-light text-center mb-2" style="width:70px; font-weight:bold; background-color: #1E7F15;"> '+
    	  				  item.sname+ '</div> ';
    				}
    				if(item.pqty == 0)
  							html +=
    					' <div class="badges rounded text-light text-center mb-2 badge-dark" style="width: 70px; font-weight: bold;">품절</div> ';
    				
    				if(item.sname == null){
    					html += ' <div class="mb-2">&nbsp;</div> ';
    				}
    					
    				html += ' <h5 class="card-title" style="font-weight:bold;"><a href="<%= ctxPath %>/shop/productView.tea?pnum=' + item.pnum + '"> '+item.pname+'</a></h5> ';
    				
    				if(item.price != item.saleprice) {
    					html += ' <p>'+
    							' <span class="card-text" style="text-decoration-line: line-through;">' +item.price.toLocaleString('en')+ '원</span> '+
   								' <span class="card-text" style="color: #1E7F15; font-weight:bold;">' +item.saleprice.toLocaleString('en')+ '원</span><br> '+
   								' </p>';
    				} else {
    					html += ' <p>'+
    							' <span class="card-text">' +item.saleprice.toLocaleString('en')+ '원</span><br> '+
    							' </p>';
    					
    				}
    				
    				html += ' <a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart" onclick="goLike(' + item.pnum + ');"></i></a> '+
    	   					' <a class="card-text text-secondary mr-5 like" onclick="goLike(' + item.pnum + ');">찜하기</a> '+
		    	   							      			
		    	   			' <a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg" onClick="clickCart('+item.pnum +');"></i></a> '+
		    	   			' <input class="card-text text-secondary cart" type="button" onClick="clickCart('+item.pnum +');" value="담기" style="padding-left: 0; margin-left: 0;"/> '+
		    	   			
                       		
			      			
		    	 			' </div> </div>';
    	      		}); 
	            }
		        
		        else {
		        	html = "상품 준비중입니다.";
		        }
           	
   	         	$("#teaProductList").html(html); 
   	         	
	   	     	// 찜하기(아이콘) 클릭시 색깔 변경
	   	     	$('i.heart').click(function() {
	   	             $(this).removeClass("text-secondary");
	   	             $(this).addClass("text-danger");
	   	         });
	   	     	// 찜하기 클릭시 색깔 변경
	   	     	$('a.like').click(function(e) {
	   	     		const $target = $(e.target); // 이벤트가 발생되어진 곳
	   	     		$target.parent().find("i.heart").removeClass("text-secondary");
	   	     		$target.parent().find("i.heart").addClass("text-danger");
	   	         });
   	         	
           },
           error: function(request, status, error){
        	   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
           }
    });
	
}// end of function orderProduct(order) {}--------------------


	
//페이지바 가져오기
function getPageBar() {
	
	$.ajax({
		url:"<%=ctxPath%>/shop/pageBarTeaJSON.tea",
		type:"get",
		data:{"cnum":cnum, "currentShowPageNo":currentShowPageNo, "snum":snum},
		dataType:"JSON",
		success:function(json){
			
			// 기존 페이지바 숨기기
			$("nav#nav_pageBar").hide();
			
			// json으로 받아온 페이지바
			jsonPageBar = json.pageBar;
			let html = '<nav id="nav_pageBar" aria-label="Page navigation example">'+
					   '<ul class="pagination justify-content-center" style="margin: auto; margin-top: 100px;">'+jsonPageBar+'</ul>'+
					   '</nav>';
			
			// json 페이지바 표시 
			$("#div_pageBar").html(html);
	        
			// 현재 페이지 active (클릭후 background 색상을 계속 유지)
			$("button.ajaxPage[id='"+currentShowPageNo+"']").parent().addClass('active');
			
	        // 제이슨 페이지바 클릭이벤트
	    	$("button.ajaxPage").click((e)=>{
	    		currentShowPageNo = $(e.target).attr('id');  // 클릭한 곳의 id
	    		$("button.ajaxPage").parent().removeClass('active');  
	    		$(e.target).parent().addClass('active');  // 클릭한 곳의 id active
	    		
	    		getOrderedList();
	    	});
	        
		},
		error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
	});
	
}


//Function Declaration
//찜하기버튼 클릭시
function goLike(pnum) {
	
	const frm = document.prodStorageFrm;
	
	$("#hidden_pnum").val(pnum);
	
	frm.method = "POST";
	frm.action = "<%= request.getContextPath()%>/shop/likeAdd.tea";
	frm.submit();
     
}// end of function goLike(pnum)------------------------------
	
//장바구니 담기
function clickCart(pnum) { 
	
	const frm = document.prodStorageFrm;
	
	$("#hidden_pnum").val(pnum);
	
	frm.method = "POST"; 
	frm.action = "<%=request.getContextPath()%>/cart/cartAdd.tea";
	frm.submit();
	
} // end of function goCart()

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
           	<a id="allGoods" href="<%= ctxPath %>/shop/productTea.tea">전체 상품</a>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a id="bestGoods" href="<%= ctxPath %>/shop/productTea.tea?snum=2">베스트</a>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a id="categoryGoods1" href="<%= ctxPath %>/shop/productTea.tea?cnum=1">녹차/말차</a>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a id="categoryGoods2" href="<%= ctxPath %>/shop/productTea.tea?cnum=2">홍차</a>
        	</div>
        	<div style="text-align: left; padding: 4%; margin-left:10%;">
           	<a id="categoryGoods3" href="<%= ctxPath %>/shop/productTea.tea?cnum=3">허브차</a>
        	</div>
      	</div>
  	    <%-- 사이드 메뉴 끝 --%>
  	    
      	<div class="col-md-10" id="maininfo" style="padding: 2.5%;">
      		<%-- 본문 시작 --%>
			<div id="maincontent">
    	    	<%-- 본문 내부 상단 바 시작 --%>
				<span class="text-dark h5 subject" style="font-weight:bold;">${requestScope.name}</span> <%-- 소제목 --%>
			
				<%-- 정렬 선택 창 --%>
				<span id="order_list">
					<button type="button" class="order selected" id="pnum desc"">신상품순</button>
					<span class="text-dark">|</span>
					<button type="button" class="order" id="saleprice desc">높은가격순</button>
					<span class="text-dark">|</span>
					<button type="button" class="order" id="saleprice asc">낮은가격순</button>
					<span class="text-dark">|</span>
					<button type="button" class="order" id="reviewCnt desc">리뷰많은순</button>
					<span class="text-dark">|</span>
					<button type="button" class="order" id="orderCnt desc">판매순</button>
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
									<div class="badges rounded text-light text-center mb-2 badge-dark" style="width: 70px; font-weight: bold;">품절</div>
								</c:if>
								
								<c:if test="${empty pvo.spvo.sname}">
				   					<div class="mb-2">&nbsp;</div>
				   				</c:if>
				   			
				     		    <h5 class="card-title" style="font-weight:bold;"><a href="<%= ctxPath %>/shop/productView.tea?pnum=${pvo.pnum}">${pvo.pname}</a></h5>
				      			
				      			
				      			<%-- 세일 상품 금액 표시 --%>
				      			<c:choose>
				      				<c:when test="${pvo.price != pvo.saleprice}">
				      				  <p>
						      			<span class="card-text" style="text-decoration-line: line-through;"><fmt:formatNumber value="${pvo.price}" pattern="###,###"/>원</span>
					      				<span class="card-text" style="color: #1E7F15; font-weight:bold;"><fmt:formatNumber value="${pvo.saleprice}" pattern="###,###"/>원</span><br>
				      				  </p>
				      				</c:when>
				      				<c:otherwise>
				      				  <p>
					      				<span class="card-text"><fmt:formatNumber value="${pvo.saleprice}" pattern="###,###"/>원</span><br>
				      				  </p>
				      				</c:otherwise>
				      			</c:choose>
				      			
				      			<a class="card-text mr-2"><i class="far fa-heart text-secondary fa-lg heart" onclick="goLike(${pvo.pnum})"></i></a>
				      			<a class="card-text text-secondary mr-5 like" onclick="goLike(${pvo.pnum})">찜하기</a>
				      							      			
				      			<a class="card-text mr-2"><i class="fas fa-shopping-basket text-secondary fa-lg " onClick="clickCart(${pvo.pnum});"></i></a>
                           		<input class="card-text text-secondary cart" type="button" onClick="clickCart(${pvo.pnum});" value="담기" style="padding-left: 0; margin-left: 0;"/>
				      			
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
			
				<%-- 페이징 --%>
				<div id="div_pageBar">
					<nav id="nav_pageBar" aria-label="Page navigation example">
				    	<ul class="pagination justify-content-center" style="margin: auto; margin-top: 100px;">${pageBar}</ul>  <%-- 하단에 페이지바 생성함. MallByCategory.java 클래스로 부터 받아옴. --%>
					</nav>
				</div>
				</div>
		      	<%-- 본문 끝 --%>
				
				<form name="prodStorageFrm">
					<%-- 제품번호--%>
					<input type="hidden" name="pnum" id="hidden_pnum" />
				</form>
			
      	</div>  
   </div>
</div>

<%@ include file="../footer.jsp"%>

