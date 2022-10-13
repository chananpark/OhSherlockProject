<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%@ include file="../header.jsp"%>


<style type="text/css">

   .productViewContainer .productbtn {
      width:100%; 
      border:none;
      border-radius: 3px;
      height: 40px;
   }

   /* Style tab links */
   /* 상품상세 탭 기본 css 시작 */
   .productViewContainer .tablink {
      background-color: white;
      color: black;
      float: left;
      border: none;
      outline: none;
      cursor: pointer;
      padding: 14px 16px;
      font-size: 17px;
      width: 20%;
   }
   
   .productViewContainer .tablink:hover {
      background-color: white;
      color: #1E7F15;
   }
   
   /* Style the tab content (and add height:100% for full page content) */
   .productViewContainer .tabcontent {
      color: black;
      display: none;
      /* padding: 100px 20px; */
      height: 100%;
      margin: 0;
   }
   /* 상품상세 탭 기본 css 끝*/
   
   .productViewContainer #btnClass {
   
   }


</style>

<script type="text/javascript">

   $(document).ready(function(){
      
      $('i.heart').click(function() {
           $(this).removeClass("text-secondary");
           $(this).addClass("text-danger");
       })
      
       // Get the element with id="defaultOpen" and click on it 
       // 새로고침 했을 경우 기본 오픈은 상품상세 설정
      document.getElementById("defaultOpen").click();
      
      
      
      // == 주문개수 스피너 달기 == // 
         $("input#spinner").spinner( {
               spin: function(event, ui) {
                  if(ui.value > 100) {
                     $(this).spinner("value", 100);
                     return false;
                  }
                  else if(ui.value < 1) {
                     $(this).spinner("value", 1);
                     return false;
                  }
               }
         } );// end of $("input#spinner").spinner({});----------------
      
      
   }); // end of $(document).ready
   
   // 상품상세, 고객리뷰, 상품고시정보 탭 클릭 메소드
   function openPage(pageName,elmnt,color,fontColor) {
      var i, tabcontent, tablinks;
      tabcontent = document.getElementsByClassName("tabcontent");
      for (i = 0; i < tabcontent.length; i++) {
         tabcontent[i].style.display = "none";
      }
      tablinks = document.getElementsByClassName("tablink");
      
      for (i = 0; i < tablinks.length; i++) {
         tablinks[i].style.backgroundColor = "";
          tablinks[i].style.color = "";
      }
      
      document.getElementById(pageName).style.display = "block";
      elmnt.style.backgroundColor = color;
      elmnt.style.color = fontColor;
   } // end of function openPage(pageName,elmnt,color,fontColor)

   
      
   // Function Declaration
   // 찜하기버튼 클릭시
   function goLike() {
         
      const frm = document.prodStorageFrm;
      
      frm.method = "POST";
      frm.action = "<%= request.getContextPath()%>/shop/likeAdd.tea";
      frm.submit();
      
   }// end of function goLike()------------------------------
      
      
      
      function goCart(){
               
         // === 주문량에 대한 유효성 검사하기 ===
         const frm = document.prodStorageFrm;
         
         const regExp = /^[0-9]+$/; // 숫자만 체크하는 정규표현식
         const oqty = frm.oqty.value;
         const bool = regExp.test(oqty);
         
         if(!bool){
            // 숫자 이외의 값이 들어온 경우
            alert("주문개수는 1개 이상이어야 합니다.");
            frm.oqty.value = "1";
            frm.oqty.focus();
            return; // 종료 
         }
         
         
         // 문자형태로 숫자로만 들어온 경우
         if(Number(oqty) < 1){
            alert("주문개수는 1개 이상이어야 합니다.");
            frm.oqty.value = "1";
            frm.oqty.focus();
            return; // 종료 
         }
         
         // 주문개수가 1개 이상인 경우
         frm.method = "POST";
         frm.action = "<%= request.getContextPath() %>/shop/cartAdd.up";
         frm.submit();
         
               
      }// end of goCart() -----------------------------------------         
   
      
      
      // 바로주문
      function goOrder(pnum) {
         
         var oqty = $("input[name='oqty']").val();
         var price = $("input[name='price']").val();
         var point = $("input[name='point']").val();
         var saleprice = $("input[name='saleprice']").val();

         var sumtotalOriginalPrice = Number(oqty) * Number(price); // 총구매정가
         var sumtotalPrice = Number(oqty) * Number(saleprice); // 총구매금액
         var sumtotalPoint = Number(oqty) * Number(point); // 
         
         if( sumtotalPrice < 30000 ) {
            sumtotalPrice += sumtotalPrice + 3000
         }
         
         var bool = confirm("총주문액 : "+sumtotalPrice+"원 결제하시겠습니까?");
           
           if(bool) {
            $("#oqtyjoin").val(oqty);
            $("#totalPricejoin").val(sumtotalPrice); // 상품구매금액
            $("#sumtotalPrice").val(sumtotalPrice);
            $("#sumtotalOriginalPrice").val(sumtotalOriginalPrice); // 총구매정가
            $("#sumtotalPoint").val(sumtotalPoint);
            
            const frm = document.prodStorageFrm;
            
            frm.method = "POST"; 
            frm.action = "<%=request.getContextPath()%>/shop/orderPayment.tea";
            frm.submit();
           }
         
         
      } // end of function goOrder(pnum)
      
</script>



<div class="container productViewContainer">

   <%-- 상품 상세 상단부 시작 --%>
   <form name="prodStorageFrm">
   <div id="product_top" class="row">
      
      <div id="product_img" class="col-md-6" style="text-align:center;">
         <img src="../images/${pvo.pimage}" width="90%" />
         <p class="mt-2">
            <span class="mr-3"><i class="fab fa-envira mr-1"></i>적립금 ${requestScope.pvo.point} 찻잎 적립</span>
            <span class="mr-3"><i class="fas fa-truck-moving mr-1"></i>3만원 이상 무료배송</span>
            <span><i class="fas fa-shopping-bag mr-1"></i>쇼핑백 동봉</span>
         </p>
      </div>
   
      <div id="product_title" class="col-md-6">
         <p class="my-3 pt-3">
            <span>
               <c:if test="${pvo.fk_cnum == '1' || pvo.fk_cnum == '2' || pvo.fk_cnum == '3'}">
                  티제품
               </c:if>
               <c:if test="${pvo.fk_cnum == '4' || pvo.fk_cnum == '5' || pvo.fk_cnum == '6'}">
                  기프트세트
               </c:if>
            </span>
            <span>
               <c:if test="${pvo.fk_cnum == '1'}">
                  &nbsp;>&nbsp;녹차/말차
               </c:if>
               <c:if test="${pvo.fk_cnum == '2'}">
                  &nbsp;>&nbsp;홍차
               </c:if>
               <c:if test="${pvo.fk_cnum == '3'}">
                  &nbsp;>&nbsp;허브티
               </c:if>
            </span>
         </p>      
         <p class="h2" style="font-weight:bold;">${pvo.pname}</p>
         <p>${pvo.psummary}</p>
         <p class="h5 row mt-5" >
            <span class="col-9" style="text-align: left;" >상품 가격</span>
            <span class="col-3" style="font-weight:bold; text-align: center;"><fmt:formatNumber value="${pvo.price}" pattern="###,###"/>원</span>
         </p>
         
            <p class="h5 row" >
               <label for="spinner" class="col-9" style="text-align: left; margin-top: 10px;">구매 수량</label> 
               <span class="col-3"><input id="spinner" name="oqty" value="1" min="1" max="100" style="text-align: right; width: 50px;" /></span>      
            </p>
         
         <hr>
         
         <table class="table table-active table-borderless bg-light">
                <tbody>
                  <tr>
                       <td class="col col-9 text-left">상품금액</td>
                       <td class="col col-3 text-right"><fmt:formatNumber value="${pvo.price}" pattern="###,###"/>원</td>
                  </tr>
                  <tr>
                       <td class="col col-9 text-left">할인율</td>
                       <td class="col col-3 text-right">${requestScope.pvo.discountPercent}% 할인</td>
                  </tr>
                  <tr>
                       <td class="col col-9 text-left">배송비</td>
                       <c:if test="${requestScope.pvo.saleprice >= 30000}">
                          <td class="col col-3 text-right">배송비 무료</td>
                     </c:if>
                     <c:if test="${requestScope.pvo.saleprice < 30000}">
                          <td class="col col-3 text-right">2,500원</td>
                     </c:if>
                  </tr>
                  <tr>
                       <td class="col col-9" style="color:#1E7F15; font-weight:bolder;"><h4>결제예정금액</h4></td>
                      <td class="col col-3 text-right" style="color:#1E7F15;"><h4 style="font-weight:bold;"><fmt:formatNumber value="${requestScope.pvo.saleprice}" pattern="###,###"/>원</h4></td>
                  </tr>
                </tbody>
          </table>
          
          <%-- ==== 장바구니담기 또는 바로주문하기 폼 ==== --%>
             <div class="row">
               <input class="productbtn" type="button" onclick="goLike();" value="찜하기" style="width: 30%; margin-left: 16px; margin-right: 12.5px;" />
                  <input class="productbtn" type="button" onclick="goCart();" value="장바구니" style="width: 30%; margin-right: 12.5px;" />
                  <input class="productbtn" type="button"  onclick="goOrder('${pvo.pnum}');" value="바로구매" style="width: 30%; background-color: #1E7F15; color:white;"/>
            </div>
            <input type="hidden" name="pnumjoin" id="pnumjoin" value="${requestScope.pvo.pnum}" />
            <input type="hidden" name="price" id="hidden_price" value="${requestScope.pvo.price}" />
            <input type="hidden" name="point" id="hidden_point" value="${requestScope.pvo.point}" />
            <input type="hidden" name="saleprice" id="hidden_saleprice" value="${requestScope.pvo.saleprice}" />
            <input type="hidden" name="pnamejoin " id="pnamejoin " value="${requestScope.pvo.pname}" />
            <input type="hidden" name="oqtyjoin  " id="oqtyjoin  " value="" />
            <input type="hidden" name="imagejoin   " id="imagejoin   " value="${pvo.pimage }" />
            <input type="hidden" name="totalPricejoin      " id="totalPricejoin      " value="" />
            <input type="hidden" name="sumtotalOriginalPrice     " id="sumtotalOriginalPrice     " value="" />
            <input type="hidden" name="sumtotalPrice     " id="sumtotalPrice     " value="" />
            <input type="hidden" name="cartnojoin     " id="cartnojoin     " value="" />
            
         
      </div>
      
   
   </div>
   <%-- 상품 상세 상단부 끝 --%>
   
   
   <%-- 상품 상세 페이지 시작--%>
   <div id="product_bottom" style="margin-top:10%;" class="">
      
      <%-- 탭 버튼 --%>
      <div id="btnClass" class="d-flex justify-content-center ">
         <button class="tablink" onclick="openPage('Home', this, '#1E7F15', 'white')" id="defaultOpen">상품상세</button>

         <button class="tablink" onclick="openPage('Review', this, '#1E7F15', 'white')" >고객리뷰</button>

         <button class="tablink" onclick="openPage('Info', this, '#1E7F15', 'white')">상품고시정보</button>
      </div>
      
      <hr>

      <%-- 탭 연결 --%>
      <div id="Home" class="tabcontent">
         <%@ include file="product_detail.jsp"%>
      </div>
      
      <div id="Review" class="tabcontent">
         <%@ include file="product_review.jsp"%>
      </div> 
      

      
      <div id="Info" class="tabcontent">
         <%@ include file="product_info.jsp"%>
      </div>
   
   </div>
   <%-- 상품 상세 페이지 끝--%>
</form>
</div>

<%@ include file="../footer.jsp"%>



