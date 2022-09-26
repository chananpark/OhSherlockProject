<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 

<% String ctxPath = request.getContextPath(); %>
    
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css">

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<script src="https://kit.fontawesome.com/48a76cd849.js" crossorigin="anonymous"></script>
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

<style type="text/css">

	.container {
		font-family: 'Gowun Dodum', sans-serif;
	}

    span {
    	margin-right: 10px;
    }
                   
	.stylePoint {
		background-color: #1E7F15; 
		color: white;
	}
                
	.purchase {
		cursor: pointer;
		color: red;
	}         
	      
   .depositbtn {
		width: 20%;
		margin-top: 50px;
		border: 2px solid #666666;
		background-color: #666666;
		color: white;
	}
	
   .depositbtn:hover {
		border: 2px solid #1E7F15;
		background-color: #1E7F15;
	    color: white;
	}
	#error{
	
		text-align: center;
		position: absolute;
		left: 35%;  
	}
   
   
</style>

<script type="text/javascript">
/* $("coindiv").hide(); */

$(document).ready(function(){
	let coinmoney = 0;
	
	$("#error").hide();
	
	
	$("input:radio[name='coinmoney']").bind("click", (e)=>{
		
		const $target = $(e.target);
		
		coinmoney = $target.val();

		
		const index = $("input:radio[name='coinmoney']").index($target);
		/* 
		   console.log("~~~ 확인용 index => " + index);
		   ~~~ 확인용 index => 0
		   ~~~ 확인용 index => 1
		   ~~~ 확인용 index => 2 
		*/
		
		$("td>span").removeClass("stylePoint");
		$("td>span").eq(index).addClass("stylePoint");
		// $("td>span").eq(index); ==> $("td>span")중에 index 번째의 요소인 엘리먼트를 선택자로 보는 것이다.
		//                             $("td>span")은 마치 배열로 보면 된다. $("td>span").eq(index) 은 배열중에서 특정 요소를 끄집어 오는 것으로 보면 된다. 예를 들면 arr[i] 와 비슷한 뜻이다.    
		
		$("#error").hide();
		$("#coinamount").text(coinmoney+" 원");
		
		const pointamount = $target.parent().parent().find('span').text() + " 찻잎";
		$("#pointamount").text(pointamount);
		
/* 		
		localStorage.setItem('coinamount', coinamount);
		
		$("coindiv").show(); */
		
	});
	
	$("#purchase").hover(function(e){
		                      $(e.target).addClass("purchase");
	                       }, 
	                       function(e){
	                    	  $(e.target).removeClass("purchase");
	                       });
	
	
	$("#purchase").click(function(){
		
		const checkedCnt = $("input:radio[name='coinmoney']:checked").length; 
		
		if(checkedCnt == 0) {
			// 결제금액을 선택하지 않았을 경우 
			$("#error").show();
			return; // 종료
		}
		
		else {
			// 결제하러 들어간다.
			
		/* === 팝업창에서 부모창 함수 호출 방법 3가지 ===
		    1-1. 일반적인 방법
			opener.location.href = "javascript:부모창스크립트 함수명();";
								
			1-2. 일반적인 방법
			window.opener.부모창스크립트 함수명();

			2. jQuery를 이용한 방법
			$(opener.location).attr("href", "javascript:부모창스크립트 함수명();");
		*/
		//  opener.location.href = "javascript:goCoinPurchaseEnd("+coinmoney+");";  
		//  또는
		coinmoney = coinmoney.replace(',','');
		coinmoney = Number(coinmoney);
		//alert(coinmoney);
		
		//window.opener.CoinPurchaseEnd(coinmoney);
		//  또는
		   $(opener.location).attr("href", "javascript:goCoinPurchaseEnd("+coinmoney+");"); 
		
			self.close(); // 팝업창을 닫는 것이다. 
		}
		
	});
	
	
	
	
	
	
});// end of $(document).ready(function(){})---------------------------
 
</script>

<div class="container"> 
	<i class="far fa-credit-card" style="font-size: 40px; float: left; padding-top:40px; padding-right: 20px;"></i> 
	<h2 style="font-weight: bold; margin-bottom: 5px; position: relative; bottom: -40px;">예치금 충전</h2>          
     
    <br><br>
     
	<div>
		<table class="table mt-4 text-center"> 
		    <colgroup>
	          <col />
	          <col width="400px"/>
	          <col/>
	      	</colgroup>
			<thead class="thead-light"> 
				<tr>
					<th></th>
					<th>충전금액</th>
					<th>적립예정금액</th>
				</tr>
			</thead> 
			<tbody>
				<tr>
				   <td style="text-align: right;">
				   	 <input type="radio" name="coinmoney" value="50,000" />
				   </td>
				   <td>
	                 <label class="radio-inline">&nbsp;50,000원</label>
                   </td>
                   <td>
	                 <span>500</span>
	               </td>
				</tr>
				<tr>
				   <td style="text-align: right;">
				   	 <input type="radio" name="coinmoney" value="100,000" />
				   </td>
				   <td>
	                 <label class="radio-inline">&nbsp;100,000원</label>
                   </td>
                   <td>
	                 <span>1,000</span>
	               </td>
				</tr>
				<tr>
				   <td style="text-align: right;">
				   	 <input type="radio" name="coinmoney" value="200,000" />
				   </td>
				   <td>
	                 <label class="radio-inline">&nbsp;200,000원</label>
                   </td>
                   <td>
	                 <span>2,000</span>
	               </td>
				</tr>
				<tr>
				   <td style="text-align: right;">
				   	 <input type="radio" name="coinmoney" value="300,000" />
				   </td>
				   <td>
	                 <label class="radio-inline">&nbsp;300,000원</label>
                   </td>
                   <td>
	                 <span>3,000</span>
	               </td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div>
      <table class="table table-active table-borderless" style="height: 100px;">
          <tbody class="text-center" style="font-weight: bold;">
             <tr>
			   <td style="margin-bottom: 70px; text-align: center;">
                 <span>충전금액&nbsp;&nbsp;&nbsp;</span>
                 <span id="coinamount">원</span>
                 <div id="coindiv">    
                 <c:set var="coincoin" value="${coinmoney}" />
                 <fmt:formatNumber value="${coincoin }" pattern="###,###" />
                 </div>
               </td>
             </tr>
             <tr>  
               <td style="margin-bottom: 70px; text-align: center;">
                 <span>적립예정금액</span>
                 <span id="pointamount">찻잎</span>
                 <%--<fmt:formatNumber pattern="###,###" /> P--%> 
               </td>
			</tr>
          </tbody>
        </table>
    </div>
	
	<div class="text-center">  
		<table>
			<tr>
	      	 	<td id="error" style="height: 10px; color: red;">결제종류에 따른 금액을 선택하세요!!</td>   
	        </tr>
        </table>
	</div>
	
    <div class="text-center">
       <input type="button" class="btn depositbtn" id="purchase" colspan="3" value="예치금충전하기" />
    </div>
	
</div>