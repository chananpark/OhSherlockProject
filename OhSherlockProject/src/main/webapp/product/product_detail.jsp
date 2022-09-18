<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<style>

	#more {display: none;}
</style>


<%-- 상품 상세는 일단 이미지로 쭉 뿌렸습니다. --%>
<img src="../images/product_detail1.jpg" width="100%"/>
<span id="dots"></span><span id="more">
<img src="../images/product_detail2.jpg" width="100%"/>
<img src="../images/product_detail3.jpg" width="100%"/>
<img src="../images/product_detail4.jpg" width="100%"/>
<img src="../images/product_detail5.jpg" width="100%"/>
<img src="../images/product_detail6.jpg" width="100%"/>
<img src="../images/product_detail7.jpg" width="100%"/>
</span>

<button onclick="myFunction()" class="btn btn-default btn-lg bg-light mt-3" id="myBtn" style="width: 100%;">더보기</button>

<%-- 더보기 버튼 실행 함수 --%>
<script>
function myFunction() {
  var dots = document.getElementById("dots");
  var moreText = document.getElementById("more");
  var btnText = document.getElementById("myBtn");

  if (dots.style.display === "none") {
    dots.style.display = "inline";
    btnText.innerHTML = "더보기"; 
    moreText.style.display = "none";
  } else {
    dots.style.display = "none";
    btnText.innerHTML = "접기"; 
    moreText.style.display = "inline";
  }
}
</script>