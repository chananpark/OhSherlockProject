package lsw.member.controller;

import java.util.Random;

public class CreateRandomCode {

	public int ranNum() {

        Random rnd  = new Random();
        int randnum = 0;
        for (int i = 0; i < 6; i++) {
           randnum += rnd.nextInt(9 - 0 + 1) + 0;
        } // end of for---------------

        System.out.println("인증번호 : " + randnum);

        return randnum;
    }
   
	
}
