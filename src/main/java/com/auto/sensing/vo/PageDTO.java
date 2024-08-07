package com.auto.sensing.vo;

//@Component
public class PageDTO {
	private int pageCount; //view 하단에 출력할 페이지 사이즈
	private int startPage; // 현재 페이지를 기준으로 시작하는 페이지 번호
	private int endPage; // 현재 페이지를 기준으로 마지막 페이지 번호
	private int realEnd; // 실제 마지막 페이지 번호
	private boolean prev, next; //prev: 이전 페이지 존재 여부 & next: endPage가 realPage보다 작으면 true
	private int total; //전체 데이터의 개수 
	private PageVO page;
	
	public PageDTO(int total, int pageCount, PageVO page) {
		this.total = total;
		this.page = page;
		this.pageCount = pageCount;
		this.endPage = (int)(Math.ceil(page.getPageNum()*1.0/pageCount)) * pageCount;
		this.startPage = endPage - (pageCount-1);
		
		realEnd = (int)(Math.ceil(total * 1.0 / page.getAmount()));
		
		if(endPage > realEnd) {
			endPage = realEnd == 0? 1 : realEnd;
		}
		
		prev = startPage > 1;
		next = endPage < realEnd;
		
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public void setRealEnd(int realEnd) {
		this.realEnd = realEnd;
	}

	public void setPrev(boolean prev) {
		this.prev = prev;
	}

	public void setNext(boolean next) {
		this.next = next;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public void setPage(PageVO page) {
		this.page = page;
	}

	public int getPageCount() {
		return pageCount;
	}

	public int getStartPage() {
		return startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public int getRealEnd() {
		return realEnd;
	}

	public boolean isPrev() {
		return prev;
	}

	public boolean isNext() {
		return next;
	}

	public int getTotal() {
		return total;
	}

	public PageVO getPage() {
		return page;
	}

}
