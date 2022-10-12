package syj.storeInfo.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class StoreList extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/storeInfo/storeList.jsp");
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception

}
