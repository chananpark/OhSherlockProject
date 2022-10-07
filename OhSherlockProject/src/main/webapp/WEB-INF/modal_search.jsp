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
	
	.recent:hover{
		cursor:url("https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbLcHy8%2FbtrNprKfXky%2F8QmDKvqOmZx19ZPk9Zk1H0%2Fimg.png"), auto !important;
		text-decoration: underline;
		color: #1E7F15;
	}

	.deleteOne{
		border-radius: 5%;
		margin-left:5%;
		padding:0% 1%;
	}

	.deleteOne:hover{
		cursor:url("https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbLcHy8%2FbtrNprKfXky%2F8QmDKvqOmZx19ZPk9Zk1H0%2Fimg.png"), auto !important;
		background-color: rgba( 30, 127, 21, 0.3 );
	}
	
	#clearBtn {
		border-radius: 5%;
		border-style: none;
		margin-left: 5%;
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
	
	// 최근 검색어 목록 불러오기
	localStorage.getItem("key");
	for(let i = 0; i < window.localStorage.length; i++) {  
		// key 찾기  
		const key = window.localStorage.key(i);    
		if(key.startsWith('sw')) {
			// value 찾기  
			const value = window.localStorage.getItem(key);    
			// 결과 출력  
			$("#recentSearchWords").append("<p><span class='recent'>"+value+"</span><span class='deleteOne'>&times</span></p>");
			}
		}
	
	// 최근 검색어 클릭시
	$(".recent").click((e)=>{

		const recentWord = $(e.target).text();
		$("input[name='searchWord']").val(recentWord);
		
		const frm = document.search_form;
		frm.action="<%=request.getContextPath()%>/shop/productSearch.tea";
		frm.submit();
	});
	
	// 검색어 개별 삭제
	$(".deleteOne").click((e)=>{
		
		const deleteWord = $(e.target).prev().text();
		$(e.target).parent().hide();
		localStorage.removeItem("sw"+deleteWord);
	});
});

// 검색하기
function goSearch(){
	
	const input = $("input[name='searchWord']").val().trim();
	
	if (input==""){
		alert("검색어를 입력하세요!");
		return;
	}
	
	// 최근 검색어 저장
	const searchWord = $(".search_txt").val();
	localStorage.setItem("sw"+searchWord, searchWord);
	
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
	
	<div style="width: 85%; margin: 3% auto auto auto">
		<span>최근 검색어</span>
		<button id="clearBtn" class="text-right" type="button" onclick="clearSearchWords()">검색어 비우기</button>
		<div id="recentSearchWords" class="mt-4">
		</div>
	</div>
</div>
  	