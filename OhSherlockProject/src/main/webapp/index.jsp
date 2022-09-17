<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="header.jsp"%>

<div class="header">
	<div class="banner" id="banner">
		<div id="carousel_advertise" class="carousel slide carousel-fade"
			data-ride="carousel">
			<!-- carousel slide : slide(슬라이드) 형태 -->
			<ol class="carousel-indicators">
				<li data-target="#carousel_advertise" data-slide-to="0"
					class="active"></li>
				<li data-target="#carousel_advertise" data-slide-to="1"></li>
				<li data-target="#carousel_advertise" data-slide-to="2"></li>
				<li data-target="#carousel_advertise" data-slide-to="3"></li>
			</ol>
			<div class="carousel-inner">
				<div class="carousel-item active">
					<img src="<%=ctxPath%>/images/오설록배너1.png" class="d-block w-100"
						alt="...">
					<!-- d-block 은 display: block; 이고  w-100 은 width 의 크기는 <div class="carousel-item active">의 width 100% 로 잡으라는 것이다. -->
					<div class="carousel-caption d-none d-md-block">
						<!-- d-none 은 display : none; 이므로 화면에 보이지 않다가, d-md-block 이므로 d-md-block 은 width 가 768px이상인 것에서만 display: block; 으로 보여라는 말이다.  -->
						<h4 class="bannerTitle">
							데일리 식습관 메이트<br>콤부차 리치피치 출시!
						</h4>
						<p>
							칼로리 부담없이 건강관리에 즐거움을 더하는 콤부차<br>새로운 맛 리치피치를 만나보세요.<br>
							<br>09.15 - 09.30
						</p>
					</div>
				</div>
				<div class="carousel-item">
					<img src="<%=ctxPath%>/images/오설록배너2.png" class="d-block w-100"
						alt="...">
					<div class="carousel-caption d-none d-md-block">
						<h4 class="bannerTitle">
							데일리 식습관 메이트<br>콤부차 리치피치 출시!
						</h4>
						<p>
							칼로리 부담없이 건강관리에 즐거움을 더하는 콤부차<br>새로운 맛 리치피치를 만나보세요.<br>
							<br>09.15 - 09.30
						</p>
					</div>
				</div>
				<div class="carousel-item">
					<img src="<%=ctxPath%>/images/오설록배너3.png" class="d-block w-100"
						alt="...">
					<div class="carousel-caption d-none d-md-block">
						<h4 class="bannerTitle">
							데일리 식습관 메이트<br>콤부차 리치피치 출시!
						</h4>
						<p>
							칼로리 부담없이 건강관리에 즐거움을 더하는 콤부차<br>새로운 맛 리치피치를 만나보세요.<br>
							<br>09.15 - 09.30
						</p>
					</div>
				</div>
				<div class="carousel-item">
					<img src="<%=ctxPath%>/images/오설록배너4.png" class="d-block w-100"
						alt="...">
					<div class="carousel-caption d-none d-md-block">
						<h4 class="bannerTitle">
							데일리 식습관 메이트<br>콤부차 리치피치 출시!
						</h4>
						<p>
							칼로리 부담없이 건강관리에 즐거움을 더하는 콤부차<br>새로운 맛 리치피치를 만나보세요.<br>
							<br>09.15 - 09.30
						</p>
					</div>
				</div>

			</div>
			<a class="carousel-control-prev" href="#carousel_advertise"
				role="button" data-slide="prev"> <span
				class="carousel-control-prev-icon" aria-hidden="true"></span> <span
				class="sr-only">Previous</span>
			</a> <a class="carousel-control-next" href="#carousel_advertise"
				role="button" data-slide="next"> <span
				class="carousel-control-next-icon" aria-hidden="true"></span> <span
				class="sr-only">Next</span>
			</a>
		</div>
	</div>
</div>

<div class="container" id="todaytea" >

	<h4 id="todaytea_title" style="font-weight: bold;">오늘은 어떤 차를 마셔볼까요?</h4>

	<div class="card"
		style="width: 250px; margin: 20px 20px 0 0;">
		<img class="card-img-top" src="images/제주동백꽃.png" alt="Card image"
			style="width: 100%">
		<div class="card-body" style="border: none;">
			<h4 class="card-title">러블리 티 박스</h4>
			<p class="card-text">20,000원</p>
			<a href="#" class="btn btn-primary"
				style="float: right; background-color: #1E7F15; border: none;">DETAIL</a>
		</div>
	</div>

	<div class="card"
		style="width: 250px; margin: 20px 20px 0 0;">
		<img class="card-img-top" src="images/그린티라떼더블샷.png" alt="Card image"
			style="width: 100%">
		<div class="card-body">
			<h4 class="card-title">그린티 라떼 더블샷</h4>
			<p class="card-text">12,000원</p>
			<a href="#" class="btn btn-primary"
				style="float: right; background-color: #1E7F15; border: none;">DETAIL</a>
		</div>
	</div>

	<div class="card"
		style="width: 250px; margin: 20px 20px 0 0;">
		<img class="card-img-top" src="images/제주순수녹차.png" alt="Card image"
			style="width: 100%">
		<div class="card-body">
			<h4 class="card-title">제주 순수녹차</h4>
			<p class="card-text">9,500원</p>
			<a href="#" class="btn btn-primary"
				style="float: right; background-color: #1E7F15; border: none;">DETAIL</a>
		</div>
	</div>

	<div class="card" style="width: 250px; margin: 20px 20px 0 0;">
		<img class="card-img-top" src="images/시그니처기프트세트.png" alt="Card image" style="width: 100%">
		<div class="card-body">
			<h4 class="card-title">기프트 세트</h4>
			<p class="card-text">22,500원</p>
			<a href="#" class="btn btn-primary" style="float: right; background-color: #1E7F15; border: none;">DETAIL</a>
		</div>
	</div>
</div>


<!-- 이벤트 컨테이너 시작 -->
<div class="container eventContainer">
	<div class="eventText">오늘만 이 가격!</div>
      <section id="index_sectionBox" class="row">
        <div id="indexEvent" class="col-md-6">
          <img
            src="<%=ctxPath%>/images/벚꽃향가득한올레20입.jpg"
            style="max-width: 100%; height: auto; vertical-align: top"
          />
          <div id="indexEventText">
            <p style="margin-left:10px">벚꽃향 가득한 올레 20입</p>
            <div id="priceInfo">
					<div class="salePercent" style="margin-left:10px; padding: 2px 5px; border-radius: 50%; background-color: #fd5c5c; text-align: center; font-weight: 500; color: #fff;">
						30%</div>
					<div style="text-decoration: line-through; font-size:18px; margin-left: 30px;">23,000</div>
              <div style="font-size: 30px;margin-left: 12px;">16,100원</div>
            </div>
          </div>
        </div>

        <div id="indexStoreStory" class="col-md-6">
          <div id="store" style="font-size:">매장안내</div>
          <div id="brandStory">
            <img
              src="<%=ctxPath%>/images/brand_story_img.jpg"
              style="max-width: 100%; height: auto; vertical-align: top"
            />
            <div id="brandStoryText">
              <div style="font-size:20px; font-weight: bold">OH!SHERLOCK</div>
              <div>오!셜록 스토리</div>
            </div>
          </div>
        </div>
      </section>
</div>
<!-- 이벤트 컨테이너 끝 -->
<%@ include file="footer.jsp"%>