<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<div class="footer pt-5">
		<div class="jumbotron">
			<div class="row">
				<div class ="col col-md-8">
				  <p class="lead">고객센터 02-336-8546</p>
				  <p>평일 09:30 ~ 18:00 (점심시간 12:30 ~ 13:30)<br>(주말 및 공휴일은 휴무입니다)</p>
				  <p class="lead">무통장 입금 계좌번호</p>
				  <p>우리 1004-001-7979&nbsp;&nbsp;국민 053679-01-08282<br>
				  하나 486-960719-12345&nbsp;&nbsp;농협 317-4989-77&nbsp;&nbsp;예금주 오셜록(주)</p>
				  </div>
		  		<div class ="col col-md-4" id="storeInfo">
				  <p><a href="<%= request.getContextPath() %>/storeInfo/storeList.tea" class="lead">매장안내</a></p>
				  <p><a href="<%= request.getContextPath() %>/storeInfo/storeDetail.tea?no=1">서울 서교동 쌍용본점</a></p>
				  <p><a href="<%= request.getContextPath() %>/storeInfo/storeDetail.tea?no=2">제주도 한라산 오름점</a></p>
				  <p><a href="<%= request.getContextPath() %>/storeInfo/storeDetail.tea?no=3">프랑스 파리 에펠탑점</a></p>
				  <p><a href="<%= request.getContextPath() %>/storeInfo/storeDetail.tea?no=4">미국 뉴욕 센트럴파크점</a></p>
			  	</div>
		  	</div>

		  <br>
		  <p><a href="#">이용안내</a>&nbsp;&nbsp;<a href="#">이용약관</a>&nbsp;&nbsp;<a href="#">개인정보처리방침</a></p>
		  <p>사업자번호 123-45-67890 | 통신판매업번호 2022-서울마포-7979 | ssherlock.oh@gmail.com</p>
		  <hr class="my-4">
		  <p>Copyright (c) Oh!Sherlock 한국 공식몰 All Rights Reserved.</p>
		</div>
	</div>
</body>
</html>