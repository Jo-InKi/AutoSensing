<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Begin Page Content -->
<div class="container-fluid">
	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800" style="font-family:'IBM Plex Sans KR';">사용자 관리 > <span style="color:#0d6efd;">사용자 조회</span></h1>
	<hr>
	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<div class="card-body">

			<div align="right">
			<form action="/vpn/settings/dest/search.do" name="searchForm" id="destSearchForm">
			<input type="hidden" name="page" value="1">
			<div class="input-group mb-3">
				<input type="text" class="form-control" name="keyword" id="keyword" placeholder="검색어를 입력하세요."
				value="${pageMaker.page.search.keyword eq '' ? '' : pageMaker.page.search.keyword }">
  				<button class="btn btn-primary" type="button" onclick="handleSubmit();"><i class="fas fa-search fa-sm"></i></button>
			</div>
			</form>
				<a href="/sensor/register"><button type="button"
						class="btn btn-primary">사용자 추가</button></a> <button
						type="button" class="btn btn-secondary" onClick="deleteDest();">사용자 삭제</button>
			</div>
			<div align="left" class="text-gray-900">총 ${pageMaker.realEnd}페이지 중 ${pageMaker.page.pageNum}</div>
			<hr />
					<span style="color: green;">${successMsg}</span>
					<span style="color: red;">${errorMsg}</span>
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr class="text-center">
									<th>&emsp;&emsp;<input class="form-check-input"
										type="checkbox" value="" id="allCheck" name="allCheck"></th>
									<th>번호</th>
									<th>아이디</th>
									<th>이름</th>
									<th>이메일</th>
									<th>연락처</th>
									<th>권한</th>
								</tr>
							</thead>
							<tbody>
							 <c:if test="${destList.size() == 0 }">
                                <tr>
                                    <td class="tl_c" colspan="8">no data </td>
                                </tr>
                                </c:if>
                            	<c:forEach var="user" items="${userList}" varStatus="user_index">
									<tr>
										<td class="col-sm-1 text-center align-middle">&emsp;&emsp;
											<c:if test="${user.grade!='0001'}">
												<input class="form-check-input" type="checkbox" value="${user.userid}" id="rowCheck" name="rowCheck">
											</c:if>
										</td>
										<td data-label="번호" class="text-left">${user_index.index + 1}</td>
										<td nowrap style="overflow:hidden;" data-label="사용자아이디">
										<c:choose>
										    <c:when test="${user.grade=='0001'}">
										        ${user.userid}
										    </c:when>
										    <c:otherwise>
												<a href="/project/edit?projectid=${user.userid}&page=${pageMaker.page.pageNum}&amount=${pageMaker.page.amount}">${user.userid}</a>
										    </c:otherwise>
										</c:choose>
										</td>
										<td nowrap style="overflow:hidden;" data-label="이름">${user.username}</td>
										<td nowrap style="overflow:hidden;" data-label="이메일">${user.email}</td>
										<td nowrap style="overflow:hidden;" data-label="연락처">${user.phone}</td>
										<td nowrap style="overflow:hidden;" data-label="사용자 등급">
										<c:choose>
										    <c:when test="${user.grade=='0001'}">
										        최고관리자
										    </c:when>
										    <c:when test="${user.grade=='0002'}">
										        프로젝트관리자
										    </c:when>
										    <c:otherwise>
										        일반사용자
										    </c:otherwise>
										</c:choose>
										</td>
									</tr>
								</c:forEach>
                            </tbody>
						</table>
					</div>
				</div>
                <!-- Pagination -->
                <div class="row- no-gutters">
                    <nav aria-label="Page navigation">
                        <c:if test="${not empty pageMaker}">
                            <ul class="pagination justify-content-center" id="pagination">
                                <li class="page-item ${pageMaker.page.pageNum eq 1 ? 'disabled' : '' }">
                                    <a id="previous" class="page-link">Previous</a>
                                </li>
                                <c:forEach var="i" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                    <c:if test="${pageMaker.page.pageNum eq i }">
                                        <li class="page-item active">
                                            <a class="page-link">${i }</a>
                                        </li>
                                    </c:if>
                                    <c:if test="${pageMaker.page.pageNum ne i }">
                                        <li class="page-item">
                                            <a href="#" id="page${i}"class="page-link">${i }</a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                                <li class="page-item ${(pageMaker.realEnd eq 0 || pageMaker.page.pageNum eq pageMaker.realEnd) ? 'disabled' : '' }">
                                    <a id="next" class="page-link">Next</a>
                                </li>
                            </ul>
                        </c:if>
                    </nav>
                </div>
                <!-- Pagination End-->
<!-- /.container-fluid -->
</div>
<!-- End of Main Content -->
<% if (request.getAttribute("errorMsg") != null) { %>
<script>
            alert("<%= request.getAttribute("errorMsg") %>");
           
</script>
<% } %>

<% if (request.getAttribute("successMsg") != null) { %>
<script>
            alert("<%= request.getAttribute("successMsg") %>");
</script>
<% } %>
<script>
    function escapeHTML(input) {
        return input
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\\(", "&#40;")
            .replace("\\)", "&#41;")
            .replace("'", "&#x27;")
            .replace(/<script[^>]*>([\S\s]*?)<\/script>/gmi, '')
            .replace(/<\/?\w(?:[^"'>]|"[^"]*"|'[^']*')*>/gmi, '');
    }

    function handleSubmit() {
        var userInput = document.getElementById('keyword').value;
        var safeInput = escapeHTML(userInput);

        document.getElementById('keyword').value = safeInput; // 숨겨진 필드에 안전한 입력 값 설정
        document.getElementById('destSearchForm').submit(); // 폼 제출
    }
</script>
<script>
  $(function() {
		$("#destination").attr('class', 'collapse show');
		$("#destTargetTab").attr('class', 'collapse-item active');	
		$("#policyTab").attr('class', 'collapse-item');
		$("#policySettingTab").attr('class', 'collapse-item');
		
	});
    $(function navigationSetting(){
        //파라미터 추출
        var params = new URLSearchParams(location.search);
        //파리미터 중 pageNum만 수정하여 Pagination 링크에 설정
        params.set('page', ${pageMaker.page.pageNum}-1);
        $("#previous").attr('href', location.pathname + '?' + params.toString());
        for(var i = ${pageMaker.startPage}; i <=${pageMaker.endPage}; i++){
            params.set('page', i);
            var idName = '#page' + i;
            $(idName).attr('href', location.pathname + '?' + params.toString());
        }
        params.set('page', ${pageMaker.page.pageNum}+1);
        $("#next").attr('href', location.pathname + '?' + params.toString());
    });
    
    function deleteDest(){
    	var url = "/vpn/settings/dest/delete.do";   
    	var destArr = new Array();
        var list = $("input[name='rowCheck']");
        
        for(var i = 0; i < list.length; i++){
            if(list[i].checked){ 
            	destArr.push(list[i].value);
            }
        }
        if (destArr.length == 0){
        	alert("선택된 항목이 없습니다.");
        }
        else{
    		var chk = confirm("선택된 항목을 삭제하시겠습니까?");				 
    		if(chk == true){
    		$.ajax({
    		    url : url,                    
    		    type : 'POST',              
    		    traditional : true,
    		    data : {
    		    	destArr : destArr       
    		    },
                success: function(result){
                	var err = result.code;
        			var msg = result.msg;
                	
                    alert(msg);
                }
    		});
    	}
        }
    }
    
</script>
<%@ include file="../IncludeBottom.jsp"%>