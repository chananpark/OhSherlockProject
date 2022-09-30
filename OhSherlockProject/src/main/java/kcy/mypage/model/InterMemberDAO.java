package kcy.mypage.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface InterMemberDAO {

	// 아이디 찾기(성명, 이메일을 입력받아서 해당 사용자의 아이디를 알려준다)
	String idFind(Map<String, String> paraMap) throws SQLException;

	// 회원의 코인 및 포인트 변경하기
	int coinUpdate(Map<String, String> paraMap) throws SQLException;

	// 페이징 처리를 한 모든 예치금 내역 보여주기
	List<CoinVO> selectPagingCoin(Map<String, String> paraMap) throws SQLException;

	/*
	// 페이징 처리에 대한 페이지 출력하기
	int getTotalPage(Map<String, String> paraMap) throws SQLException; */


	
}
