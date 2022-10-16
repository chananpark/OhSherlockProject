<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>   
    
<style type="text/css">

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
	
	table > tbody > tr:hover {
		background-color: #f1f1f1;
		color: black;
		cursor: pointer;		
	}

	.chooseDate{
		margin-right: 2%;
		width: 20%;
	}


	/* 기간 탭 기본 css 시작 */
	#btnClass .tablink {
		background-color: white;
		color: black;
		float: left;
		border: none;
		outline: none;
		cursor: pointer;
		padding: 14px 0px;
		font-size: 17px;
		width: 11%;
	}
	
	#btnClass .tablink:hover {
		background-color: #e9ecef;
		
	}
</style>    
    
    
<script type="text/javascript">

	let period = 1; // 조회기간 초기값
	let startDate; // 시작날짜
	let endDate; // 마지막날짜
	let currentShowPageNo;
	let goBackURL = ""; // 전역변수
	
	$(document).ready(function() {
		
		// 날짜 초기값
		const now = new Date();
		endDate = formatDate(now);
		startDate = formatDate(now.setMonth(now.getMonth()-Number(period)));
		
		// 기간조회 탭버튼 클릭이벤트
		$("button.period").on('click', (e) => {
			const now = new Date();
			period = $(e.target).attr("id");
 			endDate = formatDate(now);
			startDate = formatDate(now.setMonth(now.getMonth()-Number(period)));
			search();
		});
		
		/*
		// 날짜선택 조회버튼 이벤트
		$("input#datePickBtn").on('click', () => {
			const now = new Date();
     	startDate = formatDate($("input#startDate").val());
     	endDate = formatDate($("input#endDate").val());
     	
     	if(startDate > endDate){ // 끝날짜가 시작날짜보다 이후 일때
     		alert("날짜를 정확하게 입력하세요");
     		return;
     	}
     	
			search();
		});
		
		*/
		// jQuery UI 의 datepicker
		$("input.chooseDate").datepicker({
                 dateFormat: 'yy-mm-dd'  //Input Display Format
                ,showOtherMonths: true   //빈 공간에 현재월의 앞뒤월의 날짜를 표시
                ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
                ,changeYear: true        //콤보박스에서 년 선택 가능
                ,changeMonth: true       //콤보박스에서 월 선택 가능                
                ,showOn: "both"          //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
                ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
                ,buttonImageOnly: true   //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
                ,buttonText: "선택"       //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
                ,yearSuffix: "년"        //달력의 년도 부분 뒤에 붙는 텍스트
                ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
                ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
                ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
                ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
                ,minDate: "-2Y" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
                ,maxDate: "M" //최대 선택일자(+1D:하루후, +1M:한달후, +1Y:일년후)                
         });                    
            
         //input을 datepicker로 선언
         $("input#startDate").datepicker();                    
         $("input#endDate").datepicker();
         
         //endDate의 초기값을 오늘 날짜로 설정
         $('input#endDate').datepicker('setDate', 'today');
         
         //startDate의 초기값을 7일전으로 설정
         $('input#startDate').datepicker('setDate', '-1M');
         
     
      // 주문란을 눌렀을때 주문 상세조회를 보는 이벤트
         $("tbody > tr").click(function(e){
 			
			 			const $target = $(e.target); 
			 			
			 			// 클릭한 tr의 odrcode 알아오기
			 			const odrcode = $target.parent().find("input[name='odrcode']").val(); 
			 			// console.log("확인용 : "+ odrcode);
			 			 
			 			location.href = "<%= request.getContextPath() %>/mypage/orderCheck_detail.tea?odrcode="+odrcode+"&goBackURL=${requestScope.goBackURL}";
		 		}); // end of $("tbody > tr").click(function()
        
		  // datepicker에 기간 조회 
      $("#datePickBtn").on('click',function(e){
				const dateFrm = document.datepickerFrm;
				dateFrm.action="<%=request.getContextPath()%>/mypage/orderCheck.tea";
				dateFrm.submit();
			});		
		 	
	   // 기간조회 탭버튼 클릭이벤트
			$("button.period").on('click', (e) => {
				const now = new Date();
				period = $(e.target).attr("id");
				endDate = formatDate(now);
				startDate = formatDate(now.setMonth(now.getMonth()-Number(period)));
				
				$("input#hide_startDate").val(startDate);
				$("input#hide_endDate").val(endDate);
				
				const datePeriod = document.datePeriod;
				datePeriod.action="<%=request.getContextPath()%>/mypage/orderCheck.tea";
				datePeriod.submit();
			});
         
	});// $(document).ready(function() {});

    function search() {
    	
    

} // end of function search() {}-------------------
	
	// 날짜 포맷함수
 	function formatDate(date) {
 	    
 	    var d = new Date(date),
 	    
 	    month = '' + (d.getMonth() + 1) , 
 	    day = '' + d.getDate(), 
 	    year = d.getFullYear();
 	    
 	    if (month.length < 2) month = '0' + month; 
 	    if (day.length < 2) day = '0' + day; 
 	    
 	    return [year, month, day].join('-');
 	    
 	}
	
</script>    
    
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">주문조회</h2><br>
      <hr style="background-color: black; height: 1.2px;"><br>
      <h5 style="font-weight: bold;">취소/반품 내역</h5>
    </div>
  
    
    <div class="row bg-light" style="height: 80px; margin-top: 55px; width: 99.8%; margin-left: 0;">
		<%-- 탭 버튼 --%>
	    <div class="btn-group mx-auto" role="group" aria-label="Basic example" style="float: left;">
		  <button id="1" type="button" class="btn btn-light period">1개월</button>
		  <button id="3" type="button" class="btn btn-light period">3개월</button>
		  <button id="6" type="button" class="btn btn-light period">6개월</button>
		  <button id="12" type="button" class="btn btn-light period">12개월</button>
		</div>
		
		<form name="datePeriod">
			<input type="hidden" id="hide_startDate"  name="startDate">
			<input type="hidden" id="hide_endDate"  name="endDate">
		</form>
		
	  <form id="datepickerFrm" name="datepickerFrm">  
  	<%-- datepicker --%>  
  	<div class="date" style="float: left; margin-top: 25px;">
	    	<input class="chooseDate" type="text" id="startDate" name="startDate">
			<span class="bar">~</span>
			<input class="chooseDate" type="text" id="endDate"  name="endDate">
			<input type="button" id="datePickBtn" value="조회" style="margin-left: 10px; width: 80px;"/>
		</div>
		
		</form>	
	</div>
    
    <div>
		<table class="table" style="margin-top: 80px;">
			<colgroup>
	          <col width="250px"/>
	          <col width="400px"/>
	          <col/>
	          <col/>
	          <col/>
	      	</colgroup>
			<thead class="thead-light">
				<tr>
					<th style="text-align: center;">주문일자(주문번호)</th>
					<th style="text-align: center;">제품명</th>
					<th>수량</th>
					<th>가격</th>
					<th>처리상태</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="ovo" items="${requestScope.orderList}">
					<tr>
						<td class="align-middle" style="text-align: center;">${ovo.odrdate}<br>[${ovo.odrcode}]</td>
						<td><img src="<%=request.getContextPath() %>/images/${ovo.odvo.pvo.pimage}" width=100 height=100 />${ovo.odvo.pvo.pname}</td>
						<td class="align-middle">${ovo.odvo.oqty}</td>
						<td class="align-middle"><fmt:formatNumber value="${ovo.odvo.oprice}" pattern="#,###"/>원</td>
						<td class="align-middle">
							<c:choose>
						<c:when test="${ovo.odrstatus == '1' }">
							<label for="deliver${status.index}">상품준비중</label>
						</c:when>
						<c:when test="${ovo.odrstatus == '2' }">
							<label for="complete${status.index}">배송중</label>
						</c:when>
						<c:when test="${ovo.odrstatus == '-1' }">
							<label for="refund${status.index}">환불처리중</label>
						</c:when>
						<c:when test="${ovo.odvo.refund == 1}">
							<span class="text-danger">환불완료</span>
						</c:when>
						<c:when test="${ovo.odvo.cancel == 1}">
							<span class="text-info">주문취소</span>
						</c:when>
						<c:otherwise>
							<span>배송완료</span>
						</c:otherwise>
						</c:choose>
							<input name="odrcode" type="hidden" value="${ovo.odrcode}" />
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	<br>
		<nav aria-label="Page navigation example" style="margin-top: 60px;">
			<ul class="pagination justify-content-center" style="margin:auto;">${requestScope.pageBar}</ul>
		</nav>
    
  </div>
</div>

<%@ include file="../footer.jsp"%>
