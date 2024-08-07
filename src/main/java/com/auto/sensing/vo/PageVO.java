package com.auto.sensing.vo;

import org.springframework.stereotype.Component;
import org.springframework.web.util.UriBuilder;
import org.springframework.web.util.UriComponentsBuilder;

@Component
public class PageVO {
	private int pageNum; //현재의 페이지 번호
	private int amount; // 페이지당 출력할 데이터 개수
	private SearchVO search;
	
	public PageVO() {
		this(1, 10);
	}
	
	public PageVO(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public String getListLink() {
		UriBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", pageNum)
				.queryParam("amount", amount);
		
		return builder.toString();
	}

	public int getPageNum() {
		return pageNum;
	}

	public int getAmount() {
		return amount;
	}

	public SearchVO getSearch() {
		return search;
	}

	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public void setSearch(SearchVO search) {
		this.search = search;
	}
}
