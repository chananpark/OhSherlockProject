<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
   #likeContainer th, #likeContainer td {
      text-align: center;
      vertical-align: middle;
   }
   
   .paymentBtn {
      background-color: #1E7F15;
      color: white;
   }
   
   #likeContainer .likeList input[type=button] {
      border: none;
      border-radius: 5%;
      height: 30px;
   }
   
   #likeContainer .likeButtons input[type=button] {
      border: none;
      border-radius: 5%;
      height: 35px;
   }
   
   img {
       display: inline-block;
       content: "";
   }
   
   #check_all{
      font-weight: bold;
   }
   
   .del {
      margin-bottom: 40px;
   }
   
</style>

<script type="text/javascript">

   $(document).ready(function(){
      
      // 제품번호의 모든 체크박스가 체크가 되었다가 그 중 하나만 이라도 체크를 해제하면 전체선택 체크박스에도 체크를 해제하도록 한다.
      $(".chkboxpnum").click(function(){
            
            var bFlag = false;
            $(".chkboxpnum").each(function(){
               var bChecked = $(this).prop("checked"); // 체크된 체크박스
               if(!bChecked) { // 체크된 것이 아니라면
                  $("#likeSelectAll").prop("checked",false);
                  bFlag = true;
                  return false;
               }
            });
            
            if(!bFlag) {
               $("#likeSelectAll").prop("checked",true);
            }
            
         });
      
      
      // 찜목록 전체개수 값
      const allCnt = $("input:checkbox[name='pnum']").length;  // 체크여부 상관없는 모든 체크박스개수
      document.getElementById("likeCnt").textContent = allCnt;
      
   });// end of $(document).ready()--------------------------
   
      
   // Function declaration
   // 전체선택 체크박스 클릭시
   function allCheckBox() {
   
      var bool = $("#likeSelectAll").is(":checked");
      /*
         $("#likeSelectAll").is(":checked"); 은
           선택자 $("#likeSelectAll") 이 체크되어지면 true를 나타내고,
           선택자 $("#likeSelectAll") 이 체크가 해제되어지면 false를 나타내어주는 것이다.
      */
      
      $(".chkboxpnum").prop("checked", bool);  // 전체선택 체크박스 체크여부에 따라 개별 선택박스 모두 체크 or 모두 해제
   }// end of function allCheckBox()-------------------------

   
   
   // 찜목록 테이블에서 특정제품 1개행을 찜목록에서 비우기
   function goDel(likeno) {   // 상품삭제 버튼 누르면  => 찜목록번호(시퀀스)로 구별하여 삭제하기
      
      const $target = $(event.target);  // 실제 버튼태그에서 event 가 발생됨.
   	  console.log($target.parent().parent().html());  // tr 태그에 해당함.
   
      const pname = $target.parent().parent().parent().find("span.like_pname").text();  // 상품삭제 버튼에 해당하는 상품명 잡아오기
      console.log(pname);

      const bool = confirm(pname+" 상품을 삭제하시겠습니까?");
      
      if(bool) {
    	  
    	  $.ajax({
    		  url:"<%= request.getContextPath()%>/shop/likeDel.tea",
    		  type:"POST",
    		  data:{"likeno":likeno},  // 찜목록번호(시퀀스)를 넘겨주어 알아온다.
    		  dataType:"JSON",
    		  success:function(json) {
    			  // {n:1}
    			  if(json.n == 1) {  // json.n 객체는 넘겨받은 {n:1} 을 의미함.
    				  location.href = "likeList.tea"; // 삭제가 반영된 찜목록을 보여준다. 찜목록은 페이징처리를 안함.
    			  }
    		  },
    		  error: function(request, status, error){
    			  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
              }
    	  });
      }
      else {
    	  alert(pname+" 상품 삭제를 취소하셨습니다.");
    	  
      }
      
   }// end of function goDel(likeno) {}-------------------  
   
   
   
   // 찜목록 테이블에서 특정제품 선택행들을 찜목록에서 비우기
    function goSelectDel() {
        
      const allCnt = $("input:checkbox[name='pnum']").length; // 전체 체크박스의 개수(체크여부 상관없음)
      
      const likenoArr = new Array();  // 찜목록번호 배열
      
      for(var i=0; i<allCnt; i++) { 
         
         if($("input:checkbox[name='pnum']").eq(i).is(":checked")) {  // 전체 체크박스 배열중에서 한개를 끄집어온 것이 체크가 되었다면
            likenoArr.push( $("input.likeno").eq(i).val() );         // 체크된 체크박스의 찜번호값을 찜목록번호배열에 쌓아둔다.
         }

      }// end of for------------------------------------
      
      const likenojoin =  likenoArr.join(); // 배열을 문자열로 합쳐주는 것. ["1","2"] -> ["1,2"]
      
      if(likenojoin != "") {
    	  
	      const bool = confirm("선택한 상품을 삭제하시겠습니까?");
	      
	      if(bool) {
	         
	         $.ajax({
	            url:"<%= request.getContextPath()%>/shop/likeSelectDel.tea",
	            type:"POST",
	            data:{"likenojoin":likenojoin},
	            dataType:"JSON",
	            success:function(json) {
	                // {n:1}
	                console.log("확인: "+json.n);
	               if(json.n == 1) { 
	                  location.href = "likeList.tea"; // 삭제가 반영된 찜목록을 보여준다. 찜목록은 페이징처리를 안함.
	               }
	             },
	            error: function(request, status, error){
	               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	             }
	         });
	         
	      }
    	  
      }
      else {
    	  alert("선택한 상품이 없습니다.");
      }
      
    }// end of function goSelectDel() {}------------------- 
   
   
   // 장바구니 클릭시
   function clickCart(pnum, likeno) { <%-- 여기 --%> 
		
		const frm = document.prodStorageFrm;
		// 찜목록에서 oqty(수량) 선택은 불가능하므로 DAO(여진) 장바구니조회 메소드에서 oqty 초기값 1로 지정해주어야 함 ★
		// pnum 와 likeno 값을 넘겨주어 찜목록에서 장바구니 버튼 클릭시 해당상품은 삭제된다.
		$("#hidden_pnum").val(pnum);
		$("#hidden_likeno").val(likeno);
		
		frm.method = "POST"; 
		frm.action = "<%=request.getContextPath()%>/cart/cartAdd.tea";
		frm.submit();
		
	} // end of function clickCart(pnum)--------------------
   
   
   
   
</script>
   
<form name="prodStorageFrm"> 
     <div class="container" id="likeContainer">
      <i class="fas fa-coins" style="font-size: 40px; float: left; padding-right: 10px;"></i>  
      <h2 style="font-weight: bold">찜목록</h2><br>
         <hr style="background-color: black; height: 1.2px;"> 
      
      <div>
         <span id="check_all">전체 <span style="color:#1E7F15;" id="likeCnt"></span>개</span> ｜ 좋아요 상품은 최대 <span style="color:#1E7F15; font-weight: bold;">90일간</span> 보관됩니다.
      </div>
      
      <br>
      
      <div class="likeList">
         <table class="table mt-4">
            <thead class="thead-light">
               <tr>
                  <th><input type="checkbox" id="likeSelectAll" onClick="allCheckBox();" />
                     <label for="likeSelectAll">&nbsp;전체선택</label></th>
                  <th>상품정보</th>
                  <th>가격</th>
                  <th>처리</th>
               </tr>
            </thead>
            <tbody>
               <c:if test="${empty requestScope.likeList}">
                     <tr>
                          <td colspan="4" align="center">
                            <span style="color: #1E7F15; font-weight: bold;"><br><br><br>
                               찜하기 상품이 없습니다.
                            </span>
                          </td>   
                     </tr>
                  </c:if>  
                  
               <c:if test="${not empty requestScope.likeList}">
                 <c:forEach var="likevo" items="${requestScope.likeList}" varStatus="status">  <%-- likList 의 구성은 likevo 로 되어있음  --%>
                   <tr>
                     <td> <%-- 체크박스 및 제품번호 --%>
                                <%-- c:forEach 에서 선택자 id를 고유하게 사용하는 방법  
                                     varStatus="status" 을 이용하면 된다.
                                     status.index 은 0 부터 시작하고,
                                     status.count 는 1 부터 시작한다. 
                                --%>
                                <input type="checkbox" name="pnum" class="chkboxpnum" id="pnum${status.index}" value="${likevo.pnum}" />&nbsp;
                                <input type="hidden" for="pnum${status.index}" value="${likevo.pnum}" /> <%-- 체크박스 및 제품번호 --%>  
                     </td>
                     <td>
                        <a href="/OhSherlockProject/shop/productView.tea?pnum=${likevo.pnum}">  <%-- 썸네일이미지 --%>
                                 <img src="/OhSherlockProject/images/${likevo.prod.pimage}" class="img-thumbnail" width="100" style="margin-right: 100px; border: 0;" />
                              </a>
                         <span class="like_pname">${likevo.prod.pname}</span>  <%-- 제품명 --%>
                      </td>
                     <td>
                        <fmt:formatNumber value="${likevo.prod.saleprice}" pattern="###,###" />원  <%-- 가격 --%>
                         <%-- 체크박스를 선택한 찜목록을 삭제하기 위해 찜목록번호(시퀀스)를 알아야 한다 --%>
                              <input type="hidden" class="likeno" value="${likevo.likeno}" />  <%-- 찜목록번호(시퀀스) 는 hidden 처리함. --%>
                     </td>
                     <td>
							<%-- 장바구니에 추가해주기★ --%>
							<p><input class="paymentBtn" type="button" onClick="clickCart(${likevo.pnum}, ${likevo.likeno});" value="장바구니"/></p>  
							<input type="hidden" name="pnum" id="hidden_pnum" value="${likevo.pnum}" /> <%-- 제품번호--%>
							<input type="hidden" name="likeno" id="hidden_likeno" value="${likevo.pnum}" /> <%-- 찜목록번호--%>
							<%-- 찜목록에서 해당 특정 제품 비우기 --%> 
							<p><input type="button" onclick="goDel('${likevo.likeno}')" value="상품삭제"/></p> <%-- 찜목록번호(시퀀스)로 구별하여 삭제해준다. ${likevo.likeno} 은 숫자이든 문자이든 적용될 수 있도록 '' 를 꼭 감싸준다. 예: 찜목록번호 234-567 도 인식할 수 있음. --%>
						</td> 
					 </tr>
			      </c:forEach>
				</c:if>
			</tbody>
		</table>
	</div>
	
	
	<div class="likeButtons mt-5">
		<%-- 체크박스 선택한 것들만 잡아와서 삭제해주기 주문하기 참고하기★ --%>
		<span class="float-right"><input type="button" class="paymentBtn del" onClick="goSelectDel();"  value="선택삭제"/></span>
	</div>
</div>

<%@ include file="../footer.jsp"%>