<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	    // 스크롤 시 header fade-in
	    $(document).on('scroll', function(){
	        if($(window).scrollTop() > 100){
	            $("#header_menu").removeClass("transparentBg");
	            $("#header_menu").addClass("whiteBg");
	        }else{
	            $("#header_menu").removeClass("whiteBg");
	            $("#header_menu").addClass("transparentBg");
	        }
	    })

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
}

nav {
	/* font-family: 'Gowun Dodum', sans-serif; */
	/* font-family: 'Nanum Gothic', sans-serif; */
	font-weight: 800;
	font-size: 15pt;
}

/* 메뉴바에 마우스 올리면 메뉴 dropdown */
.dropdown:hover .dropdown-menu {
	display: block;
	margin-top: 0;
}
/* 드롭다운 화살표 삭제 */
.dropdown-toggle::after {
	display: none;
}

/* 드롭다운 border 삭제 */
.no-border {
	border: 0 !important;
	box-shadow: none;
}

.footer a {
	text-decoration: none;
}

.footer a:link, .footer a:visited {
	color: black;
}

#nav_header {
	position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 100;
    background: transparent;
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

#todaytea > .card {
	float: left;
}

.whiteBg{
  background: white;
  transition-duration: 0.5s;
  transition-timing-function: ease;
  
  -webkit-transition-duration:0.4s;
  -webkit-transition-timing-function:ease;
}

.transparentBg{
  
  background: transparent;
  transition-duration: 0.5s;
  transition-timing-function: ease;
  
  -webkit-transition-duration:0.4s;
  -webkit-transition-timing-function:ease;
}

/* 체크박스 시그니처 컬러로 바꾸기 */
input[type=checkbox] {
  accent-color: #1E7F15;
}

</style>

</head>

<body>
	<div class="header " id="nav_header">
		<!-- d-flex flex-column min-vh-100 -->
		<nav class="navbar navbar-expand-xl navbar-light fixed-top px-5 pt-2" id="header_menu">
			<a class="navbar-brand" href="#"><img class="mr-3" src="<%=ctxPath%>/images/o_logo.png" width=80px /></a>

			<%-- 고정 부분 --%>
			<div class="d-flex order-xl-1 ml-auto pr-2">
				<ul class="navbar-nav flex-row">
					<li class="nav-item active mr-2"><span class="nav-link menufont_size text-dark">
					<i class="fas fa-grip-lines-vertical fa-lg"></i></span></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">
					<i class="fas fa-shopping-basket fa-lg"></i></a></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">
					<i class="fas fa-heart fa-lg"></i></a></li>
					<li class="nav-item active"><a class="nav-link menufont_size text-dark" href="#">
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
					<a class="nav-link dropdown-toggle menufont_size text-dark" href="#" 
					id="navbarDropdown" data-toggle="dropdown">티제품</a> <%-- 여기 클릭시 전체 상품으로 연결 --%>
						<div class="dropdown-menu no-border" aria-labelledby="navbarDropdown" id="teaProducts">
							<a class="dropdown-item" href="#">전체상품</a> <a
								class="dropdown-item" href="#">베스트</a> <a class="dropdown-item"
								href="#">녹차/말차</a> <a class="dropdown-item" href="#">홍차</a> <a
								class="dropdown-item" href="#">허브차</a>
						</div></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">기프트세트</a></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">이벤트상품</a></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">매장안내</a></li>
					<li class="nav-item active mr-2"><a class="nav-link menufont_size text-dark" href="#">브랜드스토리</a></li>
				</ul>
				<ul class="navbar-nav text-right mx-auto">
					<li class="nav-item dropdown mr-2"><a
						class="nav-link dropdown-toggle menufont_size text-secondary"
						href="#" id="navbarDropdown" data-toggle="dropdown">로그인</a> <%-- 로그인을 누르면 기본은 로그인 창으로 연결 --%>
						<div class="dropdown-menu no-border"
							aria-labelledby="navbarDropdown">
							<a class="dropdown-item" href="#">로그인</a> <a
								class="dropdown-item" href="#">회원가입</a>
						</div></li>
					<li class="nav-item active mr-2"><a
						class="nav-link menufont_size text-secondary" href="#">마이페이지</a></li>
					<li class="nav-item dropdown mr-2"><span
						class="nav-link dropdown-toggle menufont_size text-secondary"
						id="navbarDropdown" data-toggle="dropdown">고객센터</span>
						<div class="dropdown-menu no-border"
							aria-labelledby="navbarDropdown">
							<a class="dropdown-item" href="#">공지사항</a> <a
								class="dropdown-item" href="#">자주 묻는 질문</a> <a
								class="dropdown-item" href="#">1:1 상담</a>
						</div></li>
				</ul>
			</div>
		</nav>
	</div>