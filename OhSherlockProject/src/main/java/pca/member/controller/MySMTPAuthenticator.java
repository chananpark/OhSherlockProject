package pca.member.controller;

import javax.mail.Authenticator;

import javax.mail.PasswordAuthentication;

public class MySMTPAuthenticator extends Authenticator {

	@Override
	public PasswordAuthentication getPasswordAuthentication() {
		
		return new PasswordAuthentication("ssherlock.oh","znoiflzzvwtehkxf");
		
	}
}
