<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<script type="text/javascript">
   
	$(document).ready(function(){
      
		var currentPosition = parseInt($(".myIndex").css("top"));
		  $(window).scroll(function() {
		    var position = $(window).scrollTop(); 
		    $(".myIndex").stop().animate({"top":position+currentPosition+"px"},1000);
		  });
		
   	});

</script>

<!-- 직접 만든 CSS -->
<link rel="stylesheet" href="./css/style_chaeyoung.css">

<%-- 인덱스시작 --%>   
<div class="container">
<h2 style="font-weight: bold;">마이페이지</h2> 

	<div class="myIndex">        
		  <p class="title" id="shopping" style="font-weight: bold;">나의 쇼핑</p>  
		  <div class="nav flex-column" id="nav01">
		      <a class="nav-link" href="#">주문조회</a>
		      <a class="nav-link" href="#">취소/반품/교환 내역</a>
		      <a class="nav-link" href="#">장바구니</a>
		      <a class="nav-link" href="#">찜목록</a>
		  </div>
		  
		  <div class="nav flex-column" id="nav02">
		    <a class="nav-link" href="#">적립금내역</a>
		    <a class="nav-link" href="#">예치금내역</a>
		  </div>
		  
		  <p class="title" id="activity" style="font-weight: bold;">나의 활동</p>
		  <div class="nav flex-column" id="nav03">
		      <a class="nav-link" href="#">1:1 문의 내역</a>
		      <a class="nav-link" href="#">상품 리뷰</a>
		  </div>
		  
		  <p class="title" id="information" style="font-weight: bold;">나의 정보</p>
		  <div class="nav flex-column" id="nav04">
		      <a class="nav-link" href="#">회원정보수정</a>
		      <a class="nav-link" href="#">회원탈퇴</a>
		  </div>
   </div>
</div>
<%-- 인덱스끝 --%>  
 


<div class="container">
  <div class="card"> 
    <div class="card-body" style="background-color: #cccccc;">  
      <i style='font-size:48px; float: left; padding: 0 2%;' class='fas'>&#xf508;</i>     
      <h5 class="card-title" style="font-size: 15px; font-weight: bold;">홍길동님,  안녕하세요.</h5>   
      <button type="button" class="btn btn-success" style="width: 20%;">회원정보 수정</button>  
<!--       <a href="#" class="card-link">Another link</a>   -->
    </div>
  </div>
</div>



<div class="container" style="">  
  <a style="font-weight: bold;">최근 주문정보</a>
  <table class="table" style="width: 60%; text-align: center;">       
    <thead class="table-dark" style="background-color: #f2f2f2; color:#404040;">  
      <tr>
        <th>날짜</th>
        <th>상품명</th>
        <th>결제금액</th>
        <th>배송현황</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>2022.09.05</td>
        <td>프리미엄 티 컬렉션</td>
        <td>28,000원</td>
      </tr>
      <tr>
        <td>2022.01.20</td>
        <td>러블리 티 박스</td>
        <td>20,000원</td>
      </tr> 
      <tr>
        <td>2021.12.22</td>
        <td>에브리데이 텀블러 키트</td>
        <td>36,500원</td>
      </tr>
    </tbody>
  </table>
 </div> 
 
 <%@ include file="footer.jsp"%>