<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="paginationWrap d-flex justify-content-between">
    <div class="fc_888">총 ${pageMaker.realEnd}페이지 중 ${pageMaker.page.pageNum}</div>
    <nav aria-label="Page navigation">
        <c:if test="${not empty pageMaker}">
            <ul class="pagination justify-content-center" id="pagination">
                <li class="page-item ${pageMaker.page.pageNum eq 1 ? 'disabled' : '' }">
                    <button id="previous" onclick="goPage(${pageMaker.page.pageNum-1});"
                        class="page-link">Previous</button>
                </li>
                <c:forEach var="i" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                    <c:if test="${pageMaker.page.pageNum eq i }">
                        <li class="page-item active">
                            <button class="page-link">${i }</button>
                        </li>
                    </c:if>
                    <c:if test="${pageMaker.page.pageNum ne i }">
                        <li class="page-item">
                            <button onclick="goPage(${i});" id="page${i}" class="page-link">${i }</button>
                        </li>
                    </c:if>
                </c:forEach>
                <li class="page-item ${pageMaker.page.pageNum eq pageMaker.realEnd ? 'disabled' : '' }">
                    <button id="next" onclick="goPage(${pageMaker.page.pageNum+1});"
                        class="page-link">Next</button>
                </li>
            </ul>
        </c:if>
    </nav>
</div>