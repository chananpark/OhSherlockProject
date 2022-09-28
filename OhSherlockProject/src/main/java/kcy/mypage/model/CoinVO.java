package kcy.mypage.model;

public class CoinVO {

	private int coinno;             // 예치금내역식별번호
	private String fk_userid;       // 회원아이디
	private String coin_date;       // 날짜      
	private int coin_amount;        // 금액
	
	
	
	/////////////////////////////////////////////////////////////////////////////	
	
	public CoinVO() {
	}
	

	public CoinVO(int coinno, String fk_userid, String coin_date, int coin_amount) {
		this.coinno = coinno;
		this.fk_userid = fk_userid;
		this.coin_date = coin_date;
		this.coin_amount = coin_amount;
	}




	public int getCoinno() {
		return coinno;
	}

	public void setCoinno(int coinno) {
		this.coinno = coinno;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public String getCoin_date() {
		return coin_date;
	}

	public void setCoin_date(String coin_date) {
		this.coin_date = coin_date;
	}

	public int getCoin_amount() {
		return coin_amount;
	}

	public void setCoin_amount(int coin_amount) {
		this.coin_amount = coin_amount;
	}
	
	
	

	
	
	
}
