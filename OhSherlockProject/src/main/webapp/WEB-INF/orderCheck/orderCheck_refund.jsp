<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>   

<style type="text/css">
	
	#exchangeContainer th, #exchangeContainer td {
		text-align: center;
		vertical-align: middle;
	}
	
	span.star {
		color: red;
		font-weight: bold;
		font-size: 13pt;
	}
	
	.form-select {
		width: 200px;
		text-align: left;
	}
	
	.exchangeNotice td {
		font-size: 14px;
	}
	
	.btn-light {
		width: 85px; 
		color: #1a1a1a; 
		border-style: none; 
		height: 33px;
	}
	
	.btn-secondary {
		width: 85px; 
		margin: 15px; 
		border-style: none; 
		height: 33px;
	}
	
	.btn-secondary:hover {
		border: 2px none #1E7F15;
		background-color: #1E7F15;
	    color: white;
	}
	
	#addressBtn {
		background-color: #1E7F15;
		color: white;
		height: 30px;
		border-style: none;
		border-radius: 5%;
}
	
</style>    

<script type="text/javascript" src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script type="text/javascript">

	

 $(document).ready(function() {
	 
	 $("#sumPrice").html('0원');
	 $("h4").html('0원');
	 
		// 스피너
		$("input.spinner").spinner({
     	spin: function(event, ui) {
	            if(ui.value > event.value) {
	            	$(this).spinner("value", event.value);
	               	return false;
	            }
	            else if(ui.value < 0) {
	            	$(this).spinner("value", 0);
	               	return false;
	            }
      	}
   	});// end of $(".spinner").spinner({});-----------------

		
		// 우편번호 클릭했을때
		  $('button#addressBtn').click(function () {
			  new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                let addr = ''; // 주소 변수
	                let extraAddr = ''; // 참고항목 변수

	                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    addr = data.roadAddress;
	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    addr = data.jibunAddress;
	                }

	                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	                if(data.userSelectedType === 'R'){
	                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있고, 공동주택일 경우 추가한다.
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                    // 조합된 참고항목을 해당 필드에 넣는다.
	                    document.getElementById("extra_address").value = extraAddr;
	                
	                } else {
	                    document.getElementById("extra_address").value = '';
	                }

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('postcode').value = data.zonecode;
	                document.getElementById("address").value = addr;
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById("detail_address").focus();
	            }
		        }).open(); 	
		  }); // 우편번호 찾기 버튼을 클릭했을때-----
		
		  // 우편번호 입력란에 키보드로 입력할 경우 이벤트 처리하기
		  $("input:text[id='postcode']").keyup(function () {
		    alert('우편번호 입력은 "우편번호찾기" 를 클릭으로만 하셔야 합니다.');
		    $(this).val('');
			  $("input#address").val('');
			  $("input#extra_address").val('');
			  $("input#detail_address").val('');
		  });
		  
		  
			// 제품번호의 모든 체크박스가 체크가 되었다가 그 중 하나만 이라도 체크를 해제하면 전체선택 체크박스에도 체크를 해제하도록 한다.
			$(".chkboxodnum").click(function(){
				   
			   var bFlag = false;
			   $(".chkboxodnum").each(function(){
			      	var bChecked = $(this).prop("checked");
			      	if(!bChecked) {
			         	$("#cartSelectAll").prop("checked",false);
			        	bFlag = true;
			        	return false;
			    	}
				});
				   
			   if(!bFlag) {
			      $("#cartSelectAll").prop("checked",true);
			   }
			   
			});
			
			// 스피너를 변경했을때
			$("input.spinner").bind("spinstop", function(e) {
				
			  const $target = $(e.target);
				
		    const oqty = $target.parents().find("input[name='hidden_oqty']").val(); 
		    const oprice = $target.parents().find("input[name='oprice']").val(); 
				// console.log($target.val())
				// 주문량보다 초과선택할경우
				
				if($target.val() > oqty ){
					alert("주문하신 상품수량을 초과했습니다.");
					$(this).spinner("value", oqty);
				}
				
				
			}); 
		
	});// end of $(document).ready()-----------------------

	// 장바구니 전체 선택하기
	function allCheckBox() {
	
		var bool = $("#cartSelectAll").is(":checked");
		
		$(".chkboxodnum").prop("checked", bool);
	}// end of function allCheckBox()-------------------------
	
	
	function clickCheckBox(frm) {

  		var totalSalePriceSum = 0;
  		
		var count = frm.odnum.length;
		if(count == undefined) count = 1;
		
		if( count == 1) {
			if( frm.odnum.checked == true ){
				totalSalePriceSum = parseInt( (frm.oprice.value)*(frm.oqty.value) );
			}	
		} else if (count > 1) {
		
		  	for(var i=0; i < count; i++ ){
		  		if( frm.odnum[i].checked == true ){
	  				totalSalePriceSum += parseInt( (frm.oprice[i].value)*(frm.oqty[i].value) );
	      		}
			}
	  	
		}
		
		$("#sumPrice").html(totalSalePriceSum.toLocaleString('en')+"원");
		
		totalSalePriceSum = totalSalePriceSum + ${ovo.delivery_cost};
		
		$("h4").html(totalSalePriceSum.toLocaleString('en')+"원");
		
 	} // end of function clickCheckBox(this)
	
	
	
	// 이전 버튼을 클릭하면 
	function goback() {
		
		location.href = "<%= request.getContextPath() %>${requestScope.goBackURL}";
	}
	
	function goRefund() {
		
		  // 주소가 안적혀있을때 
		  if ($("input:text[id='postcode']").val() == null ) { // 우편번호가 안적혀있는 경우
		    alert('우편번호찾기를 클릭하셔서 우편번호를 입력하셔야 합니다.');
		    return; // 종료
		  } 
		  else {
		    // "우편번호찾기" 을 클릭을 했을 경우
		
		    const regExp = new RegExp(/^\d{5}$/g);
		    //  숫자 5자리만 들어오도록 검사해주는 정규표현식 객체 생성
		
		    const postcode = $("input:text[id='postcode']").val();
		
		    const bool = regExp.test(postcode);
		
		    if (!bool) {
		      alert('우편번호 형식에 맞지 않습니다.');
		      $("input:text[id='postcode']").val('');
		      return; // 종료
		    }
		  }
		  
		  // 반품사항 안내확인 체크 여부 확인
      const returnagree =  $("input#returnagree").is(":checked");
      if(!returnagree){
       	alert("반품사항 안내확인에 체크하셔야 합니다.");
       	return;
      }
      
  		///// == 체크박스의 체크된 갯수(checked 속성이용) == /////
    	const checkCnt = $("input:checkbox[name='odnum']:checked").length;
    
	   	if(checkCnt < 1) {
	       	alert("취소하실 제품을 선택하세요.");
	       	return; // 종료 
	    } 
	   	
	   	else {
	         const allCnt = $("input:checkbox[name=odnum]").length; // 모든 체크박스의 개수
	         
	         const odnumArr = new Array(); // 제품번호 // DB에 넣기 위해서 받아오는데, 상품이 여러개 일 수 있으니 배열로 받아온다
	         const oqtyArr = new Array();
	         
	         const pnameArr = new Array();
	         const opriceArr = new Array();
	    
	         for(var i=0; i<allCnt; i++) {
	             if( $("input:checkbox[name=pnum]").eq(i).is(":checked") ) { // .eq(i) 첫번째 체크박스가 체크되어져 있다면 꺼내온다.
	            	 odnumArr.push( $("input:checkbox[name=odnum]").eq(i).val() ); // 체크박스의 value 값 ${cartvo.pnum} 
	            	 oqty.push( $("input.oqty").eq(i).val() ); 
	            	 pname.push( $("span.pname").eq(i).val() ); 
	            	 oprice.push( $("td.oprice").eq(i).val() ); 
	            	}
	         }// end of for---------------------------
	            
	         const pnamejoin = pnameArr.join();
	         const opricejoin = opriceArr.join();
	
	         var bool = confirm("상품 "+pnamejoin+" 환불신청을 하시겠습니까?");
	           
	         if(bool) {
	        	// 최종적으로 폼을 보내어 준다.
		   		  const frm = document.refundFrm;
		   		  frm.action = '<%=ctxPath%>/mypage/orderCheck_refund.tea';
		   		  frm.method = 'post';
		   		  frm.submit();
	         }
	   	}

	}// end of function goRefund()
	
</script>
<form name="refundFrm"> 
<div class="container">
  <div class="col-md-12">
  
    <div class="col-md-15">
      <h2 style="font-weight: bold;">반품 신청</h2><br>
      <hr style="background-color: black; height: 1.2px;"><br>
      <h5 style="font-weight: bold;">주문번호 ${ovo.odrcode}</h5>
    </div>  
    
		    <div id="exchangeContainer">
				<table class="table" style="margin-top: 80px;">
					<colgroup>
			          <col/>
			          <col width="175px"/>
			          <col width="380px"/>
			          <col/>
			          <col/>
			      	</colgroup>
					<thead class="thead-light">
						<tr>
							<th><input type="checkbox" id="cartSelectAll" name="cartSelectAll" value="cartSelectAll" onClick="allCheckBox('${ovo.odvo.odnum}'); clickCheckBox(this.form);" >
								<label for="cartSelectAll">&nbsp;전체선택</label></th>
							<th style="text-align: center;">주문일자(주문번호)</th>
							<th style="text-align: center;">제품명</th>
							<th>수량</th>  <%-- 수량은 내가 선택한 개수 내에서만 선택 가능. -> 예: 3개를 주문했다면 1~3개 중 몇개를 교환할지 선택가능함. --%>
							<th>&nbsp;&nbsp;&nbsp;가격</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="ovo" items="${requestScope.orderList}">
							<tr>
								<td><input type="checkbox" class="chkboxodnum" id="odnum${status.index}" name="odnum" value="${ovo.odvo.odnum}" onclick="clickCheckBox(this.form)"></td>
								<td class="align-middle" style="text-align: center;">${ovo.odrdate}<br>[${ovo.odrcode}]</td>
								<td><img src="<%=request.getContextPath() %>/images/${ovo.odvo.pvo.pimage}" width=100 height=100><span class="pname">${ovo.odvo.pvo.pname}</span></td>
								<td><input class="spinner oqty" style="width:50px" name="oqty" value="${ovo.odvo.oqty}" required/></td>
								<td class="oprice" class="align-middle">${ovo.odvo.oprice}</td>
							</tr>
							<input type="hidden" name="oprice" value="${ovo.odvo.oprice}"/>
							<input type="hidden" name="hidden_oqty" value="${ovo.odvo.oqty}"/>
							<%-- 히든태그 목록 --%>
							<input type="hidden" id="odnumjoin" name="odnumjoin" value="" />
							<input type="hidden" id="pnamejoin" name="pnamejoin" value="" />
							<input type="hidden" id="oqtyjoin" name="oqtyjoin" value="" />
							<input type="hidden" id="opricejoin" name="opricejoin" value="" />
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<br>
		    <hr>
		    <br>  
		    
		    <h5>반품사유 선택</h5>
		    <table class="table table-bordered mt-4">
		    	<colgroup>
			          <col width="180px"/>
			          <col />
		      	</colgroup>
		        <tbody class="thead-light">
		          <tr>
				         <th>사유<span class="star">*</span></th>
				         <td>
				          <select name="refund_reason" class="form-select form-select-sm" aria-label=".form-select-sm example">
									  <option value="" selected>&nbsp;사유를 선택해주세요</option>
									  <option value="고객단순변심">&nbsp;고객단순변심</option>
									  <option value="상품불만족">&nbsp;상품불만족</option>
									  <option value="상품불량">&nbsp;상품불량</option>
									  <option value="상품파손">&nbsp;상품파손</option>
									  <option value="오배송">&nbsp;오배송</option>
				          </select>
			  		 		 </td>
		          </tr>
		        </tbody>
		    </table>
		
		    <br><br>
		    
		    <h5>회수지 정보</h5>  <%-- 실제 배송된 정보 db에서 가져오기 --%>
			<div id="deliveryAddr" class="collapse show">
				<table class="table table-bordered mt-2 orderInfo">
					<colgroup>
			          <col width="180px"/>
			          <col />
			      	</colgroup>
					<thead class="thead-light">
						<tr>
							<th>보내는 분<span class="star">*</span></th>
							<td><input id="deliveryMemo" type="text" name="deliveryMemo"
								size="40" value="${ovo.recipient_name}" /></td>
						</tr>
						<tr>
							<th>연락처<span class="star">*</span></th>
							<td><input id="deliveryMemo" type="text" name="deliveryMemo"
								size="40" value="${ovo.recipient_mobile}" /></td>
						</tr>
						<tr>
							<th style="vertical-align: middle">주소<span class="star">*</span></th>
							<td class="border-0">
							<input class="addressInput mt-2 required" type="text" id="postcode" name="postcode" size="20" value="${ovo.recipient_postcode}" placeholder="우편번호" />
							<button type="button" id="addressBtn">우편번호찾기</button>
							<br> 
							<input class="addressInput mt-2 " type="text" id="address" name="address" size="40" value="${ovo.recipient_address}" placeholder="주소"/><br>
							<input class="addressInput mt-2 " type="text" id="extra_address" name="extra_address" size="40" value="${ovo.recipient_extra_address}" /><br>
							<input class="addressInput mt-2 " type="text" id="detail_address" name="detail_address" size="40" value="${ovo.recipient_detail_address}" placeholder="상세주소" /> 
						</tr>
						<tr>
							<th>배송메모</th>
							<td><input id="deliveryMemo" type="text" name="deliveryMemo"
								size="40" placeholder="부재시 경비실에 맡겨주세요" /></td>
						</tr>
					</thead>
				</table>
			</div>    

    <br><br>

	<h5>환불정보</h5>
	   <div class="paymentTotal mt-4">
	      <table class="table table-active table-borderless">
	          <tbody>
	            <tr>
	              <td class="col col-9 text-left" style="padding-top: 20px; padding-bottom: 0.7px;">총 상품금액</td>
	              <td class="col col-3 text-right" style="padding-top: 20px; padding-bottom: 0.7px;" ><span id="sumPrice"></span></td>
	            </tr>
	            <tr>
	              <td class="col col-9 text-left">배송비</td>
	              <td class="col col-3 text-right" style="padding-bottom: 20px;"><fmt:formatNumber value="${ovo.delivery_cost}" pattern="#,###"/>원</td>
	            </tr>
	            <tr style="border-top: 1px solid #d9d9d9;">
	              <td class="col col-9" style="color:#1E7F15; font-weight:bolder; padding-bottom: 15px;"><h4>총 환불예정금액</h4></td>
	              <td class="col col-3 text-right " style="color:#1E7F15; font-weight:bolder; padding-bottom: 15px;"><h4></h4></td>  
	            </tr>
	          </tbody>
	        </table>
    	</div>

	<br><br>
    
    <div class="exchangeNotice">
      <table class="table table-active table-borderless">
          <thead style="font-weight: bold;">
            <tr>
              <th>반품사항 안내</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style="padding: 3px 12px 5px 12px;">·&nbsp;모든 환불은 예치금 적립으로 처리되오니 유의하여 주시기 바랍니다.</td>
            </tr>
            <tr>
              <td style="padding: 15px 15px 10px; 15px; font-size: 16px;">아래의 경우 반품이 처리되지 않을 수 있습니다.</td>
            </tr>
            <tr>
              <td style="padding: 3px 12px 5px 12px;">·&nbsp;고객단순변심, 상품불만족 등 고객 귀책 사유로 반품 신청시 반품 택배비가 입금 또는 동봉이 되지 않거나 확인이 어려운 경우</td>
            </tr>
            <tr>
              <td style="padding: 3px 12px 5px 12px;">·&nbsp;고객단순변심, 상품불만족 등 고객 귀책 사유로 반품 신청시 상품포장 개봉, 상품포장 개봉, 상품사용으로 상품의 가치가 훼손된 경우</td>
            </tr>
            <tr>
              <td style="padding: 3px 12px 12px 12px;">·&nbsp;고객단순변심, 상품불만족 등 고객 귀책 사유로 반품 신청시 시간경과에 따라 재판매가 어려운 상품의 경우</td>
            </tr>
          </tbody>
        </table>
    </div>	
    
    <span class="input_button checkbox">
	    <input type="checkbox" id="returnagree" name="returnagree" />
	    <label for="returnagree">&nbsp;반품사항 안내를 확인하였습니다.</label>
    </span>
    	
    	
    <div class="text-center" id="detail" style="display: block; margin-top: 40px;"> <!-- 주문상세 id -->
	  <input type="button" class="btn-light" value="이전" onclick="goback()" />
	  <input type="button" class="btn-secondary" value="반품신청" onclick="goRefund()" />
    </div>
    
    
  </div>
</div>
</form> 
<%@ include file="../footer.jsp"%>
