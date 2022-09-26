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
		
	 	// Get the element with id="defaultOpen" and click on it 
	 	// 새로고침 했을 경우 기본 오픈은 상품상세 설정
		document.getElementById("defaultOpen").click();
	}); // end of $(document).ready
	
	// 상품상세, 고객리뷰, 상품고시정보 탭 클릭 메소드
	function openPage(pageName,elmnt,color,fontColor) {
		var i, tabcontent, tablinks;
		tabcontent = document.getElementsByClassName("tabcontent");
		for (i = 0; i < tabcontent.length; i++) {
			tabcontent[i].style.display = "none";
		}
		tablinks = document.getElementsByClassName("tablink");
		
		for (i = 0; i < tablinks.length; i++) {
			tablinks[i].style.backgroundColor = "";
		    tablinks[i].style.color = "";
		}
		
		document.getElementById(pageName).style.display = "block";
		elmnt.style.backgroundColor = color;
		elmnt.style.color = fontColor;
	} // end of function openPage(pageName,elmnt,color,fontColor)

	
	
</script>

<style type="text/css">

	.productViewContainer .productbtn {
		width:100%; 
		border:none;
		border-radius: 3px;
		height: 40px;
	}

	/* Style tab links */
	/* 상품상세 탭 기본 css 시작 */
	.productViewContainer .tablink {
		background-color: white;
		color: black;
		float: left;
		border: none;
		outline: none;
		cursor: pointer;
		padding: 14px 16px;
		font-size: 17px;
		width: 20%;
	}
	
	.productViewContainer .tablink:hover {
		background-color: white;
		color: #1E7F15;
	}
	
	/* Style the tab content (and add height:100% for full page content) */
	.productViewContainer .tabcontent {
		color: black;
		display: none;
		/* padding: 100px 20px; */
		height: 100%;
		margin: 0;
	}
	/* 상품상세 탭 기본 css 끝*/
	
	.productViewContainer #btnClass {
	
	}


</style>

<div class="container productViewContainer">

	<%-- 상품 상세 상단부 시작 --%>
	<div id="product_top" class="row">
		
		<div id="product_img" class="col-md-6" style="text-align:center;">
			<img src="../images/tea_collection.png" width="90%" />
			<p class="mt-2">
				<span class="mr-3"><i class="fab fa-envira mr-1"></i>적립금 280 찻잎 적립</span>
				<span class="mr-3"><i class="fas fa-truck-moving mr-1"></i>3만원 이상 무료배송</span>
				<span><i class="fas fa-shopping-bag mr-1"></i>쇼핑백 동봉</span>
			</p>
		</div>
	
		<div id="product_title" class="col-md-6">
			<p class="my-3 pt-3">
				<span>티제품</span>
				<span>&nbsp;>&nbsp;</span>
				<span>티세트</span>
			</p>		
			<p class="h2" style="font-weight:bold;">프리미엄 티 컬렉션</p>
			<p>취향과 기분에 따라 다채로운 맛과 향을 즐기기 좋은, 알찬 구성의 베스트셀러 티 세트</p>
			<p class="h5 row mt-5" >
				<span class="col-9" style="text-align: left;" >상품 가격</span>
				<span class="col-3" style="font-weight:bold; text-align: center;">28,000원</span>
			</p>
			<p class="h5 row" >
				<span class="col-9" style="text-align: left;" >구매 수량</span>
				<span class="col-3"><input type="number" value="1" min="1" max="10" required style="text-align: right; width: 100px;"/></span>		
			</p>
			<hr>
			
			<table class="table table-active table-borderless bg-light">
          		<tbody>
            		<tr>
              			<td class="col col-9 text-left">상품금액</td>
              			<td class="col col-3 text-right">28,000</td>
            		</tr>
            		<tr>
              			<td class="col col-9 text-left">배송비</td>
              			<td class="col col-3 text-right">2,500</td>
            		</tr>
            		<tr>
              			<td class="col col-9" style="color:#1E7F15; font-weight:bolder;"><h4>결제예정금액</h4></td>
             			<td class="col col-3 text-right" style="color:#1E7F15;"><h4 style="font-weight:bold;">30,500</h4></td>
            		</tr>
          		</tbody>
	       </table>
	       
	       <div class="row">
			   <a class="col-4"><input class="productbtn" type="button" value="찜하기" /></a>
			   <a class="col-4" href="<%=ctxPath%>/cart/cart.jsp"><input class="productbtn" type="button" value="장바구니" /></a>
			   <a class="col-4" href="<%=ctxPath%>/product/payment.jsp"><input class="productbtn" type="button" value="바로구매" style="background-color: #1E7F15; color:white;"/></a>
		   </div>
		   
		</div>
		
	
	</div>
	<%-- 상품 상세 상단부 끝 --%>
	
	
	<%-- 상품 상세 페이지 시작--%>
	<div id="product_bottom" style="margin-top:10%;" class="">
		
		<%-- 탭 버튼 --%>
		<div id="btnClass" class="d-flex justify-content-center ">
			<button class="tablink" onclick="openPage('Home', this, '#1E7F15', 'white')" id="defaultOpen">상품상세</button>
			<button class="tablink" onclick="openPage('Review', this, '#1E7F15', 'white')" >고객리뷰</button>
			<button class="tablink" onclick="openPage('Info', this, '#1E7F15', 'white')">상품고시정보</button>
		</div>
		
		<hr>

		<%-- 탭 연결 --%>
		<div id="Home" class="tabcontent">
			<%@ include file="product_detail.jsp"%>
		</div>
		
		<div id="Review" class="tabcontent">
			<%@ include file="product_review.jsp"%>
		</div>
		
		<div id="Info" class="tabcontent">
			<%@ include file="product_info.jsp"%>
		</div>
	
	</div>
	<%-- 상품 상세 페이지 끝--%>
</div>








<%@ include file="../footer.jsp"%>