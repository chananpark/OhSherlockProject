<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<style>


	#modal_search .search_btn {
		color: white;
		background: #1E7F15;
		border: none;
		border-radius: 10%;
		height: 40px;
		width: 40px;
	 }

	#modal_search .search_txt {
		height: 40px;
		width: 80%;
	}
	

</style>

<script>

$(()=>{
	
	// 포커스
	$(".search_txt").focus();
	
	// 검색버튼 클릭시
	$(".search_btn").click(()=>{
		goSearch();
	});
	
	// 검색어 입력후 엔터시
	$("input[name='searchWord']").bind("keydown", function(event){
		if(event.keyCode == 13) { 
			goSearch();
		}
	});
	
	// 최근 검색어 불러오기
	localStorage.getItem("key");
	for(let i = 0; i < window.localStorage.length; i++) {  
		// key 찾기  
		const key = window.localStorage.key(i);    
		// value 찾기  
		const value = window.localStorage.getItem(key);    
		// 결과 출력  
		$("#recentSearchWords").append("<p>"+value+"</p>");
		}
	
});

function goSearch(){
	
	const input = $("input[name='searchWord']").val().trim();
	
	if (input==""){
		alert("검색어를 입력하세요!");
		return;
	}
	
	// 최근 검색어 저장
	const searchWord = $(".search_txt").val();
	localStorage.setItem(searchWord, searchWord);
	
	const frm = document.search_form;
	frm.action="<%=request.getContextPath()%>/shop/productSearch.tea";
	frm.submit();
}

// 검색어 비우기
function clearSearchWords(){
	localStorage.clear();
	$("#recentSearchWords").hide();
}
</script>
    
<div id="modal_search">

    <form name="search_form" style="text-align: center;" id="todo-form" class="form">
    	<input class="search_txt" name="searchWord" type="text" placeholder="검색어를 입력해 주세요"/>
    	<input name=cnum type="hidden" value=""/>
	   	<button class="search_btn" type="button" form="todo-form"><i class="fas fa-search"></i></button>
  	</form>
	
	<div style="width: 90%; margin: 2% auto">
		<span >최근 검색어</span>
		<button class="text-right" type="button" onclick="clearSearchWords()">검색어 비우기</button>
		<div id="recentSearchWords" class="mt-4">
		</div>
	</div>
</div>
  	