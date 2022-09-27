<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OH!Sherlock</title>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css">

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<script src="https://kit.fontawesome.com/48a76cd849.js" crossorigin="anonymous"></script>
<!-- 폰트 목록 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gowun+Dodum&family=Nanum+Gothic:wght@700&display=swap" rel="stylesheet">

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js"></script>

<!-- jQueryUI CSS 및 JS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<script>
	$(function(){
		
		$("#header_menu").addClass("transparentBg");
		
	    // 스크롤 시 header fade-in
	    $(document).on('scroll', function(){
	        if($(window).scrollTop() > 50){
	            $("#header_menu").removeClass("transparentBg");
	            $("#header_menu").addClass("whiteBg");
	        }else{
	            $("#header_menu").removeClass("whiteBg");
	            $("#header_menu").addClass("transparentBg");
	        }
	    });

		$("#topBtn").click(function() {
			$('html, body').animate({scrollTop:0}, '300');
		});
	    
	    $("#nav_header").hover((e)=>{
	    	$("#header_menu").removeClass("transparentBg");
            $("#header_menu").addClass("whiteBg");
	    }, (e) =>{
	    	$("#header_menu").removeClass("whiteBg");
            $("#header_menu").addClass("transparentBg");
	    });
	    
	    // xl이하일때 메뉴 배경 하얗게, 드롭다운 오른쪽 정렬
	    $(window).resize(function(){
	        var width = parseInt($(this).width());

	        if (width < 1200){
	            $('#navbarNavDropdown').css('background-color','white');    
	            $('#navbarNavDropdown').css({'width':'100vw', 'margin': '0 calc(-50vw + 50%)','padding': '0 5%'});  
	            $('#navbarNavDropdown .dropdown-item').addClass('text-right pr-0');
	        } else {
	            $('#navbarNavDropdown').css('background-color','transparent');
	            $('#navbarNavDropdown .dropdown-item').removeClass('text-right pr-0');
	        }
	    }).resize();
	}); 
</script>

<style>
.container {
	font-family: 'Gowun Dodum', sans-serif;
	position: relative;
	margin-top: 120px;
}

.header {
	font-family: 'Nanum Gothic', sans-serif;
}

.footer {
	font-family: 'Gowun Dodum', sans-serif;
	clear: both;
	margin-bottom: 0;
}

.footer a {
	text-decoration: none;
}

.footer a:link, .footer a:visited {
	color: black;
}

/* 체크박스 시그니처 컬러로 바꾸기 */
input[type=checkbox] {
	accent-color: #1E7F15;
}

#topBtn {
	background-color: #1E7F15;
	border-radius: 50%;
	opacity: 50%;
	position: fixed;
	bottom: 5%;
	right: 5%;
}

.header>nav {
	/* font-family: 'Gowun Dodum', sans-serif; */
	/* font-family: 'Nanum Gothic', sans-serif; */
	font-weight: 800;
	font-size: 15pt;
}

/* 메뉴바에 마우스 올리면 메뉴 dropdown */
.header .dropdown:hover .dropdown-menu {
	display: block;
	margin-top: 0;
}
/* 드롭다운 화살표 삭제 */
.header .dropdown-toggle::after {
	display: none;
}

/* 드롭다운 border 삭제 */
.header .no-border {
	border: 0 !important;
	box-shadow: none;
}

#nav_header {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	z-index: 100;
/* 	background: linear-gradient(to bottom, rgba(0,0,0,0.25), transparent); */
	height: 90px;
}

#header_menu {
	height: 90px;
}

.bannerTitle {
	text-align: left;
	font-weight: bold;
	color: #140d06;
	line-height: 30pt;
}

.banner p {
	margin-bottom: 80px;
	text-align: left;
	font-size: 10pt;
	color: #140d06;
}

#todaytea>.card {
	float: left;
}

.whiteBg {
	background: white;
	transition-duration: 0.5s;
	transition-timing-function: ease;
	-webkit-transition-duration: 0.4s;
	-webkit-transition-timing-function: ease;
}

.transparentBg {
	background: linear-gradient(to bottom, rgba(0,0,0,0.25), transparent);
	transition-duration: 0.5s;
	transition-timing-function: ease;
	-webkit-transition-duration: 0.4s;
	-webkit-transition-timing-function: ease;
}

/* --- 이벤트 컨테이너 css --- */

div.eventContainer {
   clear: both;
   margin-bottom: 37px;
}

h4.eventText{
	font-weight: bold;
	padding: 60px 0px 10px 0px;
}
section#index_sectionBox {
	position: relative;
}

div#indexEvent {
	position: relative;
}

div#indexEventText {
	position: absolute;
	bottom: 27px;
	left: 30px; 
	color: #fff;
	min-width: 400px;
}


div#indexEventText > p {
	font-size: 26px;
	margin: 0px;
    margin-bottom: 3px;
}

div#priceInfo {
	display: flex;
	height: 53px;
	font-size: 24px;
	line-height: 54px;
	width: auto;
}

div#indexStoreStory {
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

 
/* 매장안내 */

#storebox {
  position:relative;
  width: 91%;
  padding:5px;
  border-radius: 0.25rem;
  background-color: #ffd9b3;
}

div#brandStory {
	position: relative;
}

div#brandStoryText {
	position: absolute;
	top: 103px;
	left: 36px;
	color: white;
	font-size: 30px;
}

/* --- 이벤트 컨테이너 css 끝 --- */
</style>

</head>

<body>
	<div class="header " id="nav_header">
		<!-- d-flex flex-column min-vh-100 -->
		<nav class="navbar navbar-expand-xl navbar-light fixed-top px-5 pt-2" id="header_menu">
			<a class="navbar-brand" href="<%=ctxPath%>/index.tea"><img class="mr-3" src="<%=ctxPath%>/images/o_logo.png" width=80px /></a>

			<%-- 고정 부분 --%>
			<div class="d-flex order-xl-1 ml-auto pr-2">
				<ul class="navbar-nav flex-row">
					<li class="nav-item active mr-2"><span class="nav-link menufont_size text-dark">
					<i class="fas fa-grip-lines-vertical fa-lg"></i></span></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="<%=ctxPath%>/cart/cart.jsp">
					<i class="fas fa-shopping-basket fa-lg"></i></a></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">
					<i class="fas fa-heart fa-lg"></i></a></li>
					<li class="nav-item active"><a class="nav-link menufont_size text-dark" data-toggle="modal" data-target="#btnSearch" data-dismiss="modal" data-backdrop="static">
					<i class="fas fa-search fa-lg"></i></a></li>
				</ul>
			</div>


			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown"
				aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarNavDropdown">
				<ul class="navbar-nav text-right">
					<li class="nav-item dropdown mr-2">
					<a class="nav-link dropdown-toggle menufont_size text-dark" href="" 
					id="navbarDropdown" data-toggle="dropdown">티제품</a> <%-- 여기 클릭시 전체 상품으로 연결 --%>
						<div class="dropdown-menu no-border" aria-labelledby="navbarDropdown" id="teaProducts">
							<a class="dropdown-item" href="">전체상품</a> <a
								class="dropdown-item" href="#">베스트</a> <a class="dropdown-item"
								href="#">녹차/말차</a> <a class="dropdown-item" href="#">홍차</a> <a
								class="dropdown-item" href="#">허브차</a>
						</div></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">기프트세트</a></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">이벤트상품</a></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="<%=ctxPath%>/storeInfo/storeList.jsp">매장안내</a></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="<%=ctxPath%>/brandStory/brandStory.tea">브랜드스토리</a></li>
				</ul>
				<ul class="navbar-nav text-right mx-auto">
				
				
				<%-- 로그인 전 상태일 때 --%>
				<c:if test="${empty sessionScope.loginuser}"> 
					<li class="nav-item dropdown mr-2"><a class="nav-link dropdown-toggle menufont_size text-secondary"
						href="<%=ctxPath%>/login/login.tea" id="navbarDropdown" data-toggle="dropdown">로그인</a> 
						<%-- 로그인을 누르면 기본은 로그인 창으로 연결 --%>
						<div class="dropdown-menu no-border" aria-labelledby="navbarDropdown">
							<a class="dropdown-item" href="<%=ctxPath%>/login/login.tea">로그인</a> 
							<a class="dropdown-item" href="<%=ctxPath%>/member/memberRegister.tea">회원가입</a>
						</div></li>
					<li class="nav-item active mr-2"><a
						class="nav-link menufont_size text-secondary" href="<%=ctxPath%>/mypage/mypage.tea">마이페이지</a></li>
				</c:if>
				
				<%-- 로그인 후 로그인->로그아웃으로 바뀐 --%>
				<c:if test="${not empty sessionScope.loginuser}">
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-secondary" href="<%=ctxPath%>/login/logout.tea">로그아웃</a></li>
					
					<%-- 관리자 로그인 시 마이페이지 -> 관리자전용 --%>
					<c:if test="${sessionScope.loginuser.userid eq 'admin'}">
					<li class="nav-item dropdown mr-2"><a
						class="nav-link dropdown-toggle menufont_size text-secondary"
						href="" id="navbarDropdown" data-toggle="dropdown">관리자전용</a>
						<div class="dropdown-menu no-border" aria-labelledby="navbarDropdown">
							<a class="dropdown-item" href="<%=ctxPath%>/member/member_list.tea">회원조회</a> 
							<a class="dropdown-item" href="<%=ctxPath%>/admin/prod_mgmt_list.tea">상품관리</a>
						</div></li>
					</c:if>
									
					<c:if test="${sessionScope.loginuser.userid ne 'admin'}">		
					<li class="nav-item active mr-2"><a
						class="nav-link menufont_size text-secondary" href="<%=ctxPath%>/mypage/mypage.tea">마이페이지</a></li>
					</c:if>
				</c:if>

					<li class="nav-item dropdown mr-2"><a href="#" class="nav-link dropdown-toggle menufont_size text-secondary"
						id="navbarDropdown" data-toggle="dropdown">고객센터</a>
						<div class="dropdown-menu no-border"
							aria-labelledby="navbarDropdown">
							<a class="dropdown-item" href="<%=ctxPath%>/cs/notice.tea">공지사항</a> <a
								class="dropdown-item" href="#">자주 묻는 질문</a> <a
								class="dropdown-item" href="<%=ctxPath%>/cs/inquiry.tea">1:1 상담</a>
						</div></li>
				</ul>
			</div>
		</nav>
	</div>
	
	<button id="topBtn" class="btn"><i class="far fa-hand-point-up" style="color:white"></i></button>

	
	
<%-- *** 검색 모달창 *** --%>
<div class="modal fade" id="btnSearch" style="font-family: 'Gowun Dodum', sans-serif;">
	<div class="modal-dialog modal-lg">
    	<div class="modal-content">
    
	      	<!-- Modal header -->
	      	<div class="modal-header">
	        	<h4 class="modal-title" style="font-weight:bold;">검색</h4>
	        	<button type="button" class="close idFindClose" data-dismiss="modal">&times;</button>
	      	</div>
	      
	      	<!-- Modal body -->
	      	<div class="modal-body">
	        	<div id="search">
	        	<%-- jsp 파일 연결을 위해서 iframe 을 사용하지 않고, 우선 include로 연결해 두었다. --%>
	        	<%--	<iframe id="iframe_reviewWrite" style="border: none; width: 100%; height: 350px;" src="<%= request.getContextPath()%>/login/idFind.up"> </iframe>---%>
             		<%@ include file="modal_search.jsp"%>
	        	</div>
	      	</div>
	      
	      	<!-- Modal footer -->
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-light idFindClose" data-dismiss="modal">Close</button>
	        	<%-- close나 엑스 버튼을 누르면 아이디 찾기에 입력해 놓은 값을 날려주기 
	        		 close와 엑스버튼을 한번에 잡으려고 클래스를 idFindClose 로 동일하게 부여--%>
	      	</div>
	      	
		</div>
	</div>
</div>	
	
	