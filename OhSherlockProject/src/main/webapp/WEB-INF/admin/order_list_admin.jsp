<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ include file="../header.jsp"%>  

<style>

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

input[type='button'] {
	border: none;
}

input[type='button'] {
	background-color: #1E7F15;
	color: white;
}

button {
	border: none;
}

.clickedBtn {
	background-color: rgb(226, 230, 234) !important;
}
</style>

<script type="text/javascript">

//주문 처리상태
const odrstatus = '${odrstatus}';

// 한 페이지당 목록 개수
const sizePerPage = '${sizePerPage}';

// 검색타입
const searchType = '${searchType}';

// 검색어
const searchWord = '${searchWord}';

	$(document).ready(function(){
		
	    // 히든폼에 odrstatus 값 담기
	   $("input#odrstatus").val(odrstatus);

		// 처리상태 버튼 표시
		$(".orderStatus[value='"+odrstatus+"']").addClass('clickedBtn');
		
		// sizePerPage 값 넣어주기
	    if(sizePerPage != "") {
		    $("select#sizePerPage").val(sizePerPage);
	    }
	    			   
	    // 검색어가 있을때 입력창에 넣어주기
	    if(searchWord != "") {
		    $("select#searchType").val(searchType).prop("selected", true);
		    $("input#searchWord").val(searchWord);		   
	    }
	    
	   // select값 변경시
	   $("select#sizePerPage").on("change", function(){
		   goSearch();
	   });
	   
	   // 검색 버튼 클릭시
	   $("#searchBtn").click(()=>{
		   if($("input#searchWord").val()==""){
			   alert("검색어를 입력하세요!");
			   return;
		   }	
		   
		   goSearch();
	   });
	   
	   // 검색어에서 엔터시
	   $("input#searchWord").on("keyup",(e)=>{
		   if(e.keyCode == "13") {
			   if($("input#searchWord").val()==""){
				   alert("검색어를 입력하세요!");
				   return;
			   }	
			   goSearch();
		   }
	   });
	   
	   // 처리상태 버튼 클릭시 히든폼에 값 담아주고 검색
	   $(".orderStatus").click((e)=>{
		   $("input#odrstatus").val($(e.target).val());
		   goSearch();
	   });
	   
	    
	}); // end of $(document).ready
	
	// 검색하기
	function goSearch() {
		
	   const frm = document.orderFrm;
	   frm.action = "orderList.tea";
	   frm.method = "GET";
	   frm.submit();
	}
		
	// 체크박스 한개 선택시
	function check(thisClass) {
		if($('input[class='+thisClass+']:checked').length == $('.'+thisClass).length){   
			$('.all').prop('checked',true);     
		}
		else{
			$('.all').prop('checked',false);     
		}
	}
	
	// 전체선택/해제
	function checkAll(className, obj){
	   const isChecked = obj.prop('checked');
	   $('.'+className).prop('checked', isChecked);
	}
	
	// 발송처리
	function processDeliver(type) {
		
		// 체크된 체크박스
		const orders = $("input:checkbox[class='"+type+"Chk']:checked");
		
		const cnt = orders.length;

      	if(cnt < 1) {
          	alert("처리할 주문을 선택하세요!");
          	return; // 종료 
       	}
      			
		// 선택된 주문번호들을 담는 배열
		const odrcodeArr = new Array();
		
		for(let i = 0; i < cnt; i++) {
			const odrcode = $(".td_odrcode").eq(i).text();
			odrcodeArr.push(odrcode);
		}
		
		const odrcodes = odrcodeArr.join();
				
		$.ajax({
            url:"<%= ctxPath%>/admin/processDeliver.tea",
            type:"POST",
            data:{"type":type,"odrcodes":odrcodes},
            dataType:"JSON",     
            success:function(json){
            	if(json.isSuccess){
					alert("주문 처리가 완료되었습니다.");
					location.href="javascript:history.go(0)"; 
            	}else{
            		alert("주문 처리를 실패하였습니다.");
            	}
            },
            error: function(request, status, error){
               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
         });
		
	}
	
	// 환불처리
	function refundOrder() {
		// 체크된 체크박스
		const orders = $("input:checkbox[class=refundChk]:checked");
		
		const cnt = orders.length;

      	if(cnt < 1) {
          	alert("처리할 주문을 선택하세요!");
          	return; // 종료 
       	}
      	
     	// 선택된 주문번호들을 담는 배열
		const odrcodeArr = new Array();
		
		for(let i = 0; i < cnt; i++) {
			const odrcode = $(".td_odrcode").eq(i).text();
			odrcodeArr.push(odrcode);
		}
		
		const odrcodes = odrcodeArr.join();
      			
		// 선택된 주문상세번호들을 담는 배열
		const odnumArr = new Array();
		
		
		for(let i = 0; i < cnt; i++) {
			const odnum = $(".span_odnum").eq(i).text();
			odnumArr.push(odnum);
		}
		
		const odnums = odnumArr.join();

		// 선택된 주문자들을 담는 배열
		const useridArr = new Array();
		
		for(let i = 0; i < cnt; i++) {
			const userid = $(".td_fk_userid").eq(i).text();
			useridArr.push(userid);
		}
		
		const userids = useridArr.join();

		// 선택된 주문금액들을 담는 배열
		const opriceArr = new Array();
		
		for(let i = 0; i < cnt; i++) {
			const oprice = $(".span_oprice").eq(i).text();
			opriceArr.push(oprice);
		}
		
		const oprices = opriceArr.join();

		$.ajax({
            url:"<%= ctxPath%>/admin/refundOrder.tea",
            type:"POST",
            data:{"odrcodes":odrcodes,"odnums":odnums,"userids":userids,"oprices":oprices},
            dataType:"JSON",     
            success:function(json){
            	if(json.isSuccess){
					alert("주문 처리가 완료되었습니다.");
					location.href="javascript:history.go(0)"; 
            	}else{
            		alert("주문 처리를 실패하였습니다.");
            	}
            },
            error: function(request, status, error){
               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
         });
	}

</script>

<div class="container" id="order_list">

	<h2 class="col text-left" style="font-weight: bold">주문관리</h2><br>
	<hr class="mb-5" style="background-color: black; height: 1.2px;">
	
	<%-- 탭 버튼 --%>
	 <div class="row bg-light mb-4" style="height: 67px; width: 40%; margin: auto; justify-content: center;">
		  <button value="1" type="button" class="orderStatus btn btn-light col col-3">배송대기</button>
		  <button value="2" type="button" class="orderStatus btn btn-light col col-3">배송중</button>
		  <button value="refundRequest" type="button" class="orderStatus btn btn-light col col-3">환불요청</button>
		  <button value="3" type="button" class="orderStatus btn btn-light col col-3">처리완료</button>
	</div>
	
	<form name="orderFrm">
	
	  	<div class="text-left mt-4" style="display: inline-block;">
			<select id="sizePerPage" name="sizePerPage">
				<option disabled>선택</option>
				<option value="10">10</option>
				<option value="30">30</option>
				<option value="50">50</option>
			</select>
	  		<select id="searchType" name="searchType">
				<option value="odrcode">주문번호</option> 
				<option value="fk_userid">주문자 아이디</option>
		    </select>
		  	<input type="text" id="searchWord" name="searchWord" placeholder="검색어를 입력하세요"/>&nbsp;
		  	<button id="searchBtn" type="button" class="rounded"><i class="fas fa-search"></i></button>
	  	</div>
	  	
	  	<input type="hidden" name='odrstatus' id='odrstatus'/>
	  	
	  	<div class="mt-4" style="display: inline-block; float: right;">
	  	<%-- 배송대기 상태일 경우 --%>
	  	<c:if test="${odrstatus == '1' }">
			<input type="checkbox" id="deliverAll" class="all" onChange="checkAll('deliverChk',$(this))"/>&nbsp;<label for="deliverAll">전체선택</label>&nbsp;
			<input type="button" class="rounded" value="발송처리" onclick="processDeliver('deliver')"/>
		</c:if>
		<%-- 배송중 상태일 경우 --%>
		<c:if test="${odrstatus == '2' }">
			<input type="checkbox" id="completeAll" class="all ml-3" onChange="checkAll('completeChk',$(this))"/>&nbsp;<label for="completeAll">전체선택</label>&nbsp;
			<input type="button" class="rounded" value="배송완료" onclick="processDeliver('complete')"/>
		</c:if>
		<%-- 환불요청 상태일 경우 --%>
		<c:if test="${odrstatus == 'refundRequest' }">
			<input type="checkbox" id="refundAll" class="all ml-3" onChange="checkAll('refundChk',$(this))"/>&nbsp;<label for="refundAll">전체선택</label>&nbsp;
			<input type="button" class="rounded" value="환불처리" onclick="refundOrder()"/>
		</c:if>
		</div>
  	</form>		
  	
  	<div>
	  	<table class="table mt-4 prodList text-center" >
			<thead class="thead-light">
				<tr class="row">
					<th class="col">주문일자</th>
					<th class="col">주문번호</th>
					<th class="col">상품명</th>
					<th class="col">주문금액</th>
					<th class="col">주문자</th>
					<th class="col">주문상세</th>
					<th class="col">주문처리</th>
				</tr>
			</thead>
			<tbody>
			<c:if test="${not empty orderList }">
			<c:forEach items="${orderList }" var="ovo" varStatus="status">
					<span class="span_odnum" style="display:none;">${ovo.odvo.odnum}</span>
					<span class="span_oprice" style="display:none;">${ovo.odvo.oprice}</span>
				<tr class="row">
					<td class="col">${ovo.odrdate}</td>
					<td class="col td_odrcode">${ovo.odrcode}</td>
					<td class="col">${ovo.odvo.pvo.pname}</td>
					<td class="col"><fmt:formatNumber value="${ovo.odvo.oprice}" pattern="#,###"/>원</td>
					<td class="col td_fk_userid">${ovo.fk_userid}</td>
					<td class="col">
						<input type="button" class="rounded" id="orderDetailBtn" 
						onclick="location.href='<%=ctxPath%>/admin/orderDetail.tea?odrcode=${ovo.odrcode}&goBackURL=${goBackURL}'" value="조회"/>
					</td>
					<td class="col">
						<c:choose>
						<c:when test="${ovo.odrstatus == '1' }">
							<input type="checkbox" id="deliver${status.index}" class="deliverChk" onChange="check($(this).attr('class'))"/>&nbsp;
							<label for="deliver${status.index}">발송처리</label>
						</c:when>
						<c:when test="${ovo.odrstatus == '2' }">
							<input type="checkbox" id="complete${status.index}" class="completeChk" onChange="check($(this).attr('class'))"/>&nbsp;
							<label for="complete${status.index}">배송완료</label>
						</c:when>
						<c:when test="${odrstatus == 'refundRequest' }">
							<input type="checkbox" id="refund${status.index}" class="refundChk" onChange="check($(this).attr('class'))"/>&nbsp;
							<label for="refund${status.index}">환불처리</label>
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
					</td>
				</tr>
			</c:forEach>	
			</c:if>
			<c:if test="${empty orderList }">
			<tr>
			<td colspan="6" class="pt-4">주문 목록이 없습니다.</td>
			</tr>
			</c:if>
			</tbody>
		</table>
	</div>
		
		<nav aria-label="Page navigation example" style="margin-top: 60px;">
		<ul class="pagination justify-content-center">${pageBar}</ul>
	</nav>

</div>

<%@ include file="../footer.jsp"%>