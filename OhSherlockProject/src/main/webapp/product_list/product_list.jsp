<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@ include file="../header.jsp"%>

<script type="text/javascript">

	$(document).ready(function(){
		
		
	}); // end of $(document).ready

</script>

<%-- 직접 만든 css --%>
<link href="../css/style_yeojin.css" rel="stylesheet" type="text/css" />

	
	<div class="container">
		<div><img src= "../images/tea_header_img.png" width=100%/></div>
      
		<div class="row">
	      	<%-- 사이드 메뉴 시작 --%>
	       	<div class="col-md-3" id="sideinfo">
				<div style="text-align: left; padding: 5%; margin-top:5%;">
	            	<span class="h4" style="font-weight:bold;">티 제품</span>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:5%;">
	            	<a>전체 상품</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:5%;">
	            	<a>베스트</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:5%;">
	            	<a>녹차/말차</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:5%;">
	            	<a>홍차</a>
	         	</div>
	         	<div style="text-align: left; padding: 4%; margin-left:5%;">
	            	<a>허브차</a>
	         	</div>
	         	<div id="sidecontent" style="text-align: left; padding: 20px;"></div>
	       	</div>
    	    <%-- 사이드 메뉴 끝 --%>
    	    
	       	<div class="col-md-9" id="maininfo" style="padding: 2.5%;">
	       		<%-- 본문 시작 --%>
				<div id="maincontent">
		    	    <%-- 본문 내부 상단 바 시작 --%>
					<span class="text-dark h5" style="font-weight:bold;">전체상품</span>
					
					<%-- 정렬 선택 창 --%>
					<span id="order_list">
						<a>신상품순</a>
						<span class="text-dark">&nbsp;|&nbsp;</span>
						<a>높은가격순</a>
						<span class="text-dark">&nbsp;|&nbsp;</span>
						<a>낮은가격순</a>
						<span class="text-dark">&nbsp;|&nbsp;</span>
						<a>리뷰많은순</a>
						<span class="text-dark">&nbsp;|&nbsp;</span>
						<a>판매순</a>
					</span>
		    	    <%-- 본문 내부 상단 바 끝 --%>
					
					<hr>
					
					<%-- 상품 목록 시작 --%>
					<div> 
						<div class="card-deck mb-5">
		  <div class="card">
		    <img src="../images/Koala.jpg" class="card-img-top" alt="...">
		    <div class="card-body">
		      <h5 class="card-title">Card title</h5>
		      <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
		      <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
		    </div>
		  </div>
		  <div class="card">
		    <img src="../images/Koala.jpg" class="card-img-top" alt="...">
		    <div class="card-body">
		      <h5 class="card-title">Card title</h5>
		      <p class="card-text">This card has supporting text below as a natural lead-in to additional content.</p>
		      <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
		    </div>
		  </div>
		  <div class="card">
		    <img src="../images/Koala.jpg" class="card-img-top" alt="...">
		    <div class="card-body">
		      <h5 class="card-title">Card title</h5>
		      <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This card has even longer content than the first to show that equal height action.</p>
		      <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
		    </div>
		  </div>
		</div>
					
					
					
					
					
					
					
					</div>
					<%-- 상품 목록 시작 --%>					
				
				</div>
	       		<%-- 본문 끝 --%>
	       		
			</div>
    	    
		</div>
	      
	</div>
	

<%@ include file="../footer.jsp"%>