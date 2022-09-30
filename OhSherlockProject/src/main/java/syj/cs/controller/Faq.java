package syj.cs.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class Faq extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/cs/faq.jsp");
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
