<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
        
<style>

	/* * {box-sizing: border-box;} */
	
	.page-link {
	  color: #666666; 
	  background-color: #fff;
	  border: 1px solid #ccc; 
	}
	
	.page-item.active .page-link {
	 z-index: 1;
	 color: #1E7F15;
	 border-color: #1E7F15;
	 
	}
	
	.page-link:focus, .page-link:hover {
	  color: #1E7F15;
	  background-color: #fafafa; 
	  border-color: #1E7F15;
	}

	.badge {
		background-color: #1E7F15; 
		color: white; 
		font-weight: bold;
	}
	
	.btn-secondary {
		width: 80px; 
		margin: 15px; 
		border-style: none; 
		height: 30px;
		font-size: 14px;
	}
	
	.btn-secondary:hover {
		border: 2px none #1E7F15;
		background-color: #1E7F15;
	    color: white;
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
	
	.chooseDate{
		margin-right: 2%;
		width: 20%;
	}
	
	a, a:hover, a:link, a:visited {
		color: black;
		text-decoration: none;
	}
</style>       

<script>

	let period = 1; // 조회기간 초기값
	let startDate; // 시작날짜
	let endDate; // 마지막날짜
	let lenInquiry = 5; // 한번에 불러올 글 개수
	let lead = 1; // 가져올 목록 중 첫번째 rownum
	
	$(() => {
		
		// 날짜 초기값
		const now = new Date();
		endDate = formatDate(now);
		startDate = formatDate(now.setMonth(now.getMonth()-Number(period)));
		
		search();
		
		 // 더보기버튼 이벤트
	    $("button#more").click(()=>{
	    	$(this).val(Number(start) + lenInquiry);
	    });
		
		// 기간조회 탭버튼 클릭이벤트
		$("button.period").on('click', (e) => {
			const now = new Date();
			period = $(e.target).attr("id");
			endDate = formatDate(now);
			startDate = formatDate(now.setMonth(now.getMonth()-Number(period)));
			search();
		});
		
		// 날짜선택 조회버튼 이벤트
		$("input#datePickBtn").on('click', () => {
			const now = new Date();
            startDate = formatDate($("input#startDate").val());
        	endDate = formatDate($("input#endDate").val());
			search();
		});
		
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
         $('input#startDate').datepicker('setDate', '-7D');
 		
	});
	
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

	// 조회시 호출 함수
	function search(){
		
		// 글 개수 조회
		$.ajax({
			url:"<%=ctxPath%>/mypage/inquiryCountJson.tea",
			type:"get",
			data:{"lead":lead, "lenInquiry":lenInquiry, "startDate":startDate, "endDate":endDate},
			dataType:"JSON",
			success:function(json){
  	         	$("#inquiryLength").text(json.total);
			},
			error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		});
		
		// 글 목록 조회
		$.ajax({
			url:"<%=ctxPath%>/mypage/inquiryListJson.tea",
			type:"get",
			data:{"lead":lead, "lenInquiry":lenInquiry, "startDate":startDate, "endDate":endDate},
			dataType:"JSON",
			success:function(json){
         		let html = '';
         		
         		if (json.length == 0) {
         			// 데이터가 존재하지 않는 경우
         			 html += "<tr><td colspan='4'>1:1문의 내역이 없습니다.</td><tr>";
	         		// 결과 출력
	         		$("#inquiryTbl>tbody").html(html);
         		}else{
  	         		$.each(json, function(index, item){
	         			html += "<tr><td>"+item.inquiry_type+"</td><td>"
							+item.inquiry_subject+"</td><td>"+item.inquiry_date+
							"</td><td>"+item.inquiry_answered+"</td></tr>";
	         		}); 
						
	         		$("#inquiryTbl>tbody").html(html);
				}
  	         		
			},
			error: function(request, status, error){
	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		});	
	}
</script>

	<div class="container" id="inquiry">

	<div class="titleZone row">
		<h2 class="col text-left" style="font-weight: bold">1:1문의</h2>
		<br>
		<div class="col text-right">
			<span style="font-weight: bold; font-size: 20px;">02-336-8546</span><br>
			<span style="font-weight: normal; font-size: 15.5px;">평일 09:30
				~ 18:00 (점심시간 12:30 ~ 13:30)<br>주말 및 공휴일 휴무
			</span>
		</div>
	</div>
	
	<hr style="background-color: black; height: 1.2px;">
	<h5 style="font-weight: bold;">내 상담 내역</h5>
	
	 <div class="row bg-light" style="height: 80px; margin-top: 55px; width: 99.8%; margin-left: 0;">
		<%-- 탭 버튼 --%>
	    <div class="btn-group mx-auto" role="group" aria-label="Basic example" style="float: left;">
		  <button id="1" type="button" class="btn btn-light period">1개월</button>
		  <button id="3" type="button" class="btn btn-light period">3개월</button>
		  <button id="6" type="button" class="btn btn-light period">6개월</button>
		  <button id="12" type="button" class="btn btn-light period">12개월</button>
		</div>
	  
	  	<%-- datepicker --%>  
	    <div class="date" style="float: left; margin-top: 25px;">
	    	<input class="chooseDate" type="text" id="startDate">
			<span class="bar">~</span>
			<input class="chooseDate" type="text" id="endDate">
			<input type="button" id="datePickBtn" value="조회" style="margin-left: 10px; width: 80px;"/>
		</div>
	</div>
	
	<br>
	<div style="margin-top: 10px;">총 <span id="inquiryLength"></span>건의 상담 내역이 있습니다.</div>
	<table class="table mt-2 text-center" id="inquiryTbl">
			<thead class="thead-light">
				<tr>
					<th>문의유형</th>
					<th>제목</th>
					<th>등록일</th>
					<th>처리상태</th>
				</tr>
			</thead>
			<tbody>
				
			</tbody>
			<tfoot>
			</tfoot>
		</table>
			
            <span id="count">0</span>
	
	<div class="text-right" id="detail" style="display: block; margin-top: 15px;">
	  <input type="button" class="btn-secondary rounded" value="문의남기기" onclick="location.href='<%=ctxPath%>/cs/inquiry.tea'"/>
    </div>
	
	

</div>

<%@ include file="../footer.jsp"%>