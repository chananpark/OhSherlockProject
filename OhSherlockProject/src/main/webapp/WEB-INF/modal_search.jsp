<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>



</script>


    
<style>

	#modal_search .search_box {
	
	}

	#modal_search .search_btn {
		color: white;
		background: #1E7F15;
		border: none;
		border-radius: 10%;
		height: 50px;
		width: 50px;
	 }

	#modal_search .search_txt {
		height: 50px;
		width: 80%;
	}
	
	

</style>

<script>

$(()=>{
	
	$(".search_btn").click(()=>{
		
		const frm = document.search_form;
		frm.action="<%=request.getContextPath()%>/shop/productSearch.tea";
		frm.submit();
	});
});
</script>
    
<div id="modal_search" class="wrapper">

    <form name="search_form" style="text-align: center;" id="todo-form" class="form">
    	<input class="search_txt" name="searchWord" type="text" placeholder="검색어를 입력해 주세요">
	   	<button class="search_btn" type="button" form="todo-form"><i class="fas fa-search"></i></button>
  	</form>
	
	<h5 style="margin: 20px 50px;">최근 검색어</h5>
</div>
  	