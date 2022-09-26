<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ include file="../sidebar.jsp"%> 

<style>

.mysidebar .nav-link {
	/* border:solid 1px red; */
	width: 500px;
    padding: 0 0 3px 0;
    font-size: 13px;       
    color: #404040; 
}
  
.mysidebar #nav02{
	/* border:solid 1px red; */
	padding: 10px 0 0 0;
} 
 
.mysidebar .title{
	/* border:solid 1px red; */
	font-family: 'Nanum Gothic', sans-serif;
	padding-top: 5%;      
	font-size: 18px;       
    color: #404040; 
} 

.mysidebar{
	font-family: 'Gowun Dodum', sans-serif;
	position: alsolute;
	/* margin-top: 60px;    */  
	margin-left: 70px;  
	width: 100px; 
	float: left;
}  

/* .myIndex{	
	margin-top: 5%;     
	margin-left: 4%;  
	width: 100px; 
	float: left; 
} */

.mypage {
	position: relative; /* 원래있던 자신의 위치를 기준으로 한 상대위치 값을 지정한다. 자주사용한다.!! */
	left: 60px;  /* 가로위치값 */
}

.mpComment {
	font-size: 15px; 
	font-weight: bold;
}


.infoUpdate {
	width: 20%;
	margin-left: 15px;
	border: 2px solid #666666;
	background-color: #666666;
	color: white;
}

.infoUpdate:hover {
	border: 2px solid #1E7F15;
	background-color: #1E7F15;
    color: white;
}

.charge {
	width: 120px;
	margin-left: 45px;
	background-color: #1E7F15;
	color: white;
}

.viewBtns {
	border: 1px; 
	solid gray; 
	width: 50px; 
	height: 30px;
}

.orderIf td {
	vertical-align: middle;
}

</style>

<script type="text/javascript">


	$(document).ready(function(){
	
	    $("button#btnSubmit").click(function(){ // 로그인 버튼을 클릭하면
	          goLogin(); 
	    });
	       
	    
	    
	    
	 });// end of $(document).ready(function(){})-----------------------------
	
	 //=== 나의정보 수정하기 === //
	 function goEditPersonal(userid) {  // 어떤 회원 userid를 수정할 것인지 파라미터로 받아옴.
	 
	    // 나의정보 수정하기 팝업창 띄우기 (GET 방식으로)
	     const url = "<%= request.getContextPath() %>/member/memberEdit.up?userid="+userid; 
	     // 어떤 회원 userid를 수정할 것인지 MemberEdit.java 클래스에 넘겨준다.(get방식)
	       
	       
	     window.open(url, "memberEdit", 
	                "left="+pop_left+", top="+pop_top+", width="+pop_width+", height="+pop_height); // 팝업창 띄우기(url, 팝업창이름, "팝업창 크기지정")   *url 은 보여줄 페이지(CoinPurchaseTypeChoice.java) 이다. 
	          
	   
	 }// end of function goEditPersonal()----------------------


	// 코인충전 결제금액 선택하기(실제로 카드결제) //
	    function deposit_charge(userid){
	         
	         // 코인구매 금액 선택 팝업창 띄우기
	         const url = "<%= request.getContextPath()%>/mypage/deposit_charge.tea?userid="+userid;
	         
	         window.open(url, "deposit_charge",
	                   "left=450px, top=100px, width=900px, height=650px");   
	         
	         
	   }// end of function goCoinPurchaseTypeChoice(userid){}-------------------

	   
	   
	      // === 아임포트 결제를 해주는 함수 === //
	      function goCoinPurchaseEnd(coinmoney) { 
//	         alert("확인용 부모창의 함수 호출함. 결제금액 : " + coinmoney + "원"); 
	     
	           const userid = "${sessionScope.loginuser.userid}";  
	        //   alert("확인용 결제할 사용자 아이디 : " + userid);
	           
	        //  아임포트 결제 팝업창 띄우기 
	             const url = "<%= request.getContextPath()%>/mypage/coinPurchaseEnd.tea?userid="+userid+"&coinmoney="+coinmoney;
	           
	           window.open(url, "coinPurchaseEnd",
	                     "left=350px, top=100px, width=1000px, height=600px");
	      }  
	     
	      
	      // == DB 상의 tbl_member 테이블의 해당 사용자의 코인금액 및 포인트를 증가(update) 시켜주는 함수 == //
	        function goCoinUpdate(userid, coinmoney){
	           
	           console.log("~~~ 확인용 ~~~ :" +userid+ ", coinmoney : " +coinmoney);
	           
	           const frm = document.coinUpdateFrm;
	           frm.userid.value = userid;
	           frm.coinmoney.value = coinmoney;
	           
	           frm.action = "<%= request.getContextPath()%>/mypage/coinUpdateLoginuser.tea"; 
	           frm.method = "POST"; 
	           frm.submit();
	           
	        }

	
	

</script>

<div class="container mypage">
	<h2 style="font-weight: bold; margin-bottom: 20px;">마이페이지</h2>
	
	<div class="card border-0">  
	   <div class="card-body" style="background-color: #cccccc;">  
	      <i style='font-size:48px; float: left; padding: 0 2%;' class='fas'>&#xf508;</i>     
	      <h5 class="card-title mpComment">&nbsp;&nbsp;&nbsp;&nbsp;${(sessionScope.loginuser).name}님,  안녕하세요.</h5>  
	      <div>
		      <a href="<%= request.getContextPath() %>/member/memberEdit.tea?userid=${(sessionScope.loginuser).userid}"><button type="button" class="btn infoUpdate">회원정보 수정</button></a>  <%-- 파라미터 userid 값을 넘겨줌 --%>
		      <i class="fab fa-envira" style="margin-left: 230px; font-size: 25px; vertical-align: middle;"></i>
		      <span style="font-weight: bold;">적립금 </span><fmt:formatNumber value="${(sessionScope.loginuser).point}" pattern="###,###찻잎" />  
              <i class="far fa-credit-card" style="margin-left: 20px; font-size: 25px; vertical-align: middle;"></i>
              <span style="font-weight: bold;">예치금 </span><fmt:formatNumber  value="${(sessionScope.loginuser).coin}" pattern="###,###원" /> 
              <a href="javascript:deposit_charge('${(sessionScope.loginuser).userid}');" type="button" class="btn charge">예치금충전</a>
            
	      </div> 
	   </div>
	</div>

    
    <br><br><br>
	<div>
	   <span style="font-weight: bold; font-size: 15pt;">최근 주문정보</span>
	   <span>(최근 1개월)</span>
	   <span style="float: right;">더보기&nbsp;></span>
	</div>

	<div class="orderIf">
		<table class="table mt-4 text-center"> 
			<thead class="thead-light"> 
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
					<td><input type="button" class="viewBtns" value="조회" /></td>
				</tr>
				<tr>
					<td>2022.01.20</td>
					<td>러블리 티 박스</td>
					<td>20,000원</td> 
					<td><input type="button" class="viewBtns" value="조회" /></td> 
				</tr>
				<tr>
					<td>2021.12.22</td>
					<td>에브리데이 텀블러 키트</td>
					<td>36,500원</td> 
					<td><input type="button" class="viewBtns" value="조회" /></td> 
				</tr>
			</tbody>
		</table>
	</div>
	
	
    <br>
	<div>
	   <span style="font-weight: bold; font-size: 15pt;">최근 문의내역</span>
	   <span style="float: right;">더보기&nbsp;></span>
	</div>

	<div>
		<table class="table mt-4 text-center"> 
			<thead class="thead-light"> 
				<tr>
					<th>날짜</th>
					<th>제목</th>
					<th>문의유형</th>
				</tr>
			</thead> 
			<tbody>
				<tr>
					<td>2022.09.06</td>
					<td>배송문의</td>
					<td>기타</td> 
				</tr>
				<tr>
					<td>2022.01.20</td>
					<td>주문취소/배송전변경 문의</td>
					<td>취소/환불/교환</td> 
				</tr>
				<tr>
					<td>2021.12.26</td>
					<td>교환/반품문의</td>
					<td>취소/환불/교환</td> 
				</tr>
			</tbody>
		</table>
	</div>
	
    <%-- PG(Payment Gateway 결제대행)에 코인금액을 카드(카카오페이 등)로 결제 후 DB상에 사용자의 코인액을 update 를 해주는 폼이다. --%>
    <form name="coinUpdateFrm" >
      <input type="hidden" name="userid" />    
      <input type="hidden" name="coinmoney" />    
    </form>
    
	
</div>
 <%@ include file="../footer.jsp"%>