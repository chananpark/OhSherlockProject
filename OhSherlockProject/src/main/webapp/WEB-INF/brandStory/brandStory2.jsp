<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>

.bsContainer section {
    width: 100%;
    min-height: 500px;
}

.bsContainer .navbar {
    position: fixed;
    z-index: 999;
    top: 50%;
    right: 50px;
    transform: translateY(-50%);
}

.bsContainer .navbar .nav-menu {
    margin: 0;
    padding: 0;
    list-style-type: none;
}

.bsContainer .navbar .nav-menu li {
    position: relative;
    min-width: 200px;
    text-align: right;
}

.bsContainer .navbar .nav-menu li .dot {
    display: block;
    color: #fff;
    padding: 5px 0;
}

.bsContainer .navbar .nav-menu li .dot::before,
.bsContainer .navbar .nav-menu li .dot::after {
    display: block;
    position: absolute;
    content: '';
    border-radius: 50%;
    top: 50%;
    transition: all .3s ease;
}

.bsContainer .navbar .nav-menu li .dot::before {
    width: 5px;
    height: 5px;
    right: 0;
    border: 2px solid #181818;
    transform: translateY(-50%);
}

.bsContainer .navbar .nav-menu li .dot::after {
    width: 15px;
    height: 15px;
    border: 2px solid #1E7F15;
    right: -5px;
    transform: translateY(-50%) scale(0);
}

.bsContainer .navbar .nav-menu li .dot.active::before,
.bsContainer .navbar .nav-menu li:hover .dot::before {
    background: #1E7F15;
    border-color: #1E7F15;
}

.bsContainer .navbar .nav-menu li .dot.active::after,
.bsContainer .navbar .nav-menu li:hover .dot::after {
    transform: translateY(-50%) scale(1);
}

.bsContainer .navbar .nav-menu li .dot span {
    display: inline-block;
    opacity: 0;
    font-weight: 700;
    letter-spacing: .5px;
    text-transform: capitalize;
    background-color: #1E7F15;
    padding: 10px 20px;
    border-radius: 3px;
    margin-right: 30px;
    transform: translateX(20px);
    transition: all .3s ease;
}

.bsContainer .navbar .nav-menu li .dot span::before {
    display: block;
    position: absolute;
    content: '';
    border-left: 7px solid #1E7F15;
    border-top: 7px solid transparent;
    border-bottom: 7px solid transparent;
    top: 50%;
    transform: translate(7px, -50%);
    right: 0;
    transition: all .3s ease;
}

.bsContainer .navbar .nav-menu li .dot.active span,
.navbar .nav-menu li:hover .dot span {
    transform: translateX(0px);
    opacity: 1;
}

</style>

<script>
$(function(){

    var link = $('#navbar a.dot');
    link.on('click',function(e){
        
        //href 속성을 통해, section id 타겟을 잡음
        var target = $($(this).attr('href')); 
        
        //target section의 좌표를 통해 꼭대기로 이동
        $('html, body').animate({
            scrollTop: target.offset().top
        },600);
        
        //active 클래스 부여
        $(this).addClass('active');

        //앵커를 통해 이동할때, URL에 #id가 붙지 않도록 함.
        e.preventDefault();
    });
    
    $(window).on('scroll',function(){
        findPosition();
    });

    function findPosition(){
        $('section').each(function(){
            if( ($(this).offset().top - $(window).scrollTop() ) < 200){
                link.removeClass('active');
                $('#navbar').find('[data-scroll="'+ $(this).attr('id') +'"]').addClass('active');
            }
        });
    }

    findPosition();
    
	// 페이지 로딩되면 자동으로 브랜드스토리 클릭
	$("a#bsHome").trigger("click");
});
</script>

<div class="container bsContainer" >
	<nav id="navbar" class="navbar">
		<ul class="nav-menu">
			<li><a data-scroll="home" href="#home" class="dot active" id="bsHome"> <span>Oh!Sherlock</span>
			</a></li>
			<li><a data-scroll="bi" href="#bi" class="dot active"> <span>BI</span>
			</a></li>
			<li><a data-scroll="pca" href="#pca" class="dot"> <span>박찬안</span>
			</a></li>
			<li><a data-scroll="lye" href="#lye" class="dot"> <span>이예은</span>
			</a></li>
			<li><a data-scroll="syj" href="#syj" class="dot"> <span>손여진</span>
			</a></li>
			<li><a data-scroll="lsw" href="#lsw" class="dot"> <span>임선우</span>
			</a></li>
			<li><a data-scroll="kcy" href="#kcy" class="dot"> <span>강채영</span>
			</a></li>
		</ul>
	</nav>

	<section id="home">
	<hr style="padding-top: 90px; border-style:none">
		<h2 style="font-weight: bold">오셜록 브랜드스토리</h2>
		<hr>
		
		<div class="d-flex" style="margin-top: 5%" >
		<div class="card align-self-center" style="width: 500px">
			<img class="card-img-top" src="../images/sherlock1.png"
				alt="Card image">
			<div class="card-img-overlay">
				<h4 class="card-title text-white-50">OH! Sherlock</h4>
				<p class="card-text text-white">오셜록은 향긋합니다</p>
			</div>
		</div>
		<div class="card align-self-center" style="width: 500px">
			<img class="card-img-top" src="../images/sherlock2.png"
				alt="Card image">
			<div class="card-img-overlay">
				<h4 class="card-title text-white-50">OH! Sherlock</h4>
				<p class="card-text text-white">오셜록은 맛있습니다</p>
			</div>
		</div>
		<div class="card align-self-center" style="width: 500px">
			<img class="card-img-top" src="../images/sherlock3.png"
				alt="Card image">
			<div class="card-img-overlay">
				<h4 class="card-title text-white-50">OH! Sherlock</h4>
				<p class="card-text text-white">오셜록은 진실합니다</p>
			</div>
		</div>
	</div>
		
		<div class="text-center jumbotron" style="margin-top: 5%; background-color: rgb(210,219,198)">
			<h5>
				오셜록의 역사는 2022년 5월, 21B Worldcup Street에서 시작되었습니다.<br><br> 오셜록은 최고의
				인재들을 영입하여 부단한 노력과 연구를 통하여 지속적으로 발전하고 있습니다.
			</h5>
		</div>
		
	</section>


	<section id="bi">
		<hr style="padding-top: 90px; border-style:none">
		<h2 style="font-weight: bold" class="mt-5">BI(Brand Identity)</h2>
		<hr>
		<div class="bi text-center" style="margin: 5% 0;">
		<h4 style="margin-top: 5%; font-weight:bold">브랜드 로고<br>─</h4>
		<h5 style="margin: 5% 0;">Fragrant World의 비전을 담은 OH!Sherlock의 얼굴을 소개합니다.</h5>
		<img src="../images/o_logo_big.png" width=300>
		<h5 style="margin: 5% 0;">OH!Sherlock의 심볼마크는 Java 커피잔의 향긋함을 담아<br>
		인생의 모든 순간에 늘 아름다운 향기를 선사하겠다는 약속입니다.</h5>
		<hr style="width:50%">
		<h4 style="margin-top: 5%; font-weight:bold">브랜드 시그니처 컬러<br>─</h4>
		<img src="../images/signature_color.png" width=80%/>
		<h5 style="margin: 5% 0;">OH!Sherlock의 시그니처 컬러는 제주 녹차밭의 진녹색을 떠올리게 하여<br>
		하루 종일 컴퓨터만 보느라 지친 현대인의 안구 피로감을 해소해줍니다.</h5>
		</div>
	</section>

	<hr style="padding-top: 90px; border-style:none">
	<h2 style="font-weight: bold" class="mt-5">임직원 소개</h2>
	<hr>

	<section id="pca">
	<hr style="padding-top: 90px; border-style:none">
		<div class="mt-4 pca">
			<h4>박찬안</h4>
		</div>
	</section>
	<hr>
	<section id="lye">
	<hr style="padding-top: 90px; border-style:none">
		<h4>이예은</h4>
	</section>
	<hr>
	<section id="syj">
	<hr style="padding-top: 90px; border-style:none">
		<h4>손여진</h4>
	</section>
	<hr>
	<section id="lsw">
	<hr style="padding-top: 90px; border-style:none">
		<h4>임선우</h4>
	</section>
	<hr>
	<section id="kcy">
	<hr style="padding-top: 90px; border-style:none">
		<h4>강채영</h4>
	</section>
</div>

<%@ include file="../footer.jsp"%>