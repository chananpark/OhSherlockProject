package common.controller;

public abstract class AbstractController implements InterCommand {

	/*
	    ※ view 단 페이지(.jsp) 이동시 
	    forward 방법: super.setRedirect(false); 
	    redirect 방법: super.setRedirect(true);
	    이동하고자 하는 페이지: super.setViewPage("페이지경로");
	*/	
	
	private boolean isRedirect = false;
	
	private String viewPage;

	public boolean isRedirect() {
		return isRedirect;
	}

	public void setRedirect(boolean isRedirect) {
		this.isRedirect = isRedirect;
	}

	public String getViewPage() {
		return viewPage;
	}

	public void setViewPage(String viewPage) {
		this.viewPage = viewPage;
	}
	
}
