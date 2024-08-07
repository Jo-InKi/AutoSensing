<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800" style="font-family:'IBM Plex Sans KR';">츠로젝트 관리 > 프로젝트 조회 > <span style="color:#0d6efd;">프로젝트 추가</span></h1>
	<hr>
	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<form:form modelAttribute="projectAddForm" action="/project/register.do" method="post" enctype="multipart/form-data">
		<div class="card-body">
			<div align="right">
				<a href="#"><button type="button"
						class="btn btn-info btn-icon-split" onClick="editProject();">
						<span class="icon text-white-50"><i
							class="fa-solid fa-user-pen"></i></span> <span class="text">수정</span>
					</button></a>
			</div>
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable">
					<tbody>
					<tr>
						<th class="tg-0lax">프로젝트 아이디&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<input type="text" id="projectid" name="projectid" size="12" maxlength="12" value="${project.projectid }" class="form-control" oninput="resetprojectIdDuplicateChk" placeholder="프로젝트 아이디 입력" disabled>
							<button class="btn btn-outline-info" type="button" id="projectidDuplicate_check" onClick="projectIdDuplicationCheck();" disabled>중복 확인</button>
							<div id="projectidValidationFeedback" class="invalid-feedback"></div></div>
							<span style="color:red;">${valid_projectid}</span>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">프로젝트 명칭(Kr)&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<input type="text" id="projectname" name="projectname" size="128" maxlength="128" value="${project.projectname }" class="form-control" oninput="resetprojectnameDuplicateChk" placeholder="프로젝트 한글명 입력" disabled>
							<button class="btn btn-outline-info" type="button" id="projectnameDuplicate_check" onClick="projectnameDuplicationCheck();" disabled>중복 확인</button>
							<div id="projectnameValidationFeedback" class="invalid-feedback"></div></div>
							<span style="color:red;">${valid_projectname}</span>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">프로젝트 명칭(En)&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<input type="text" id="emname" name="emname" size="128" maxlength="128" value="${project.emname }" class="form-control" oninput="resetemnameDuplicateChk" placeholder="프로젝트 한글명 입력" disabled>
							<button class="btn btn-outline-info" type="button" id="emnameDuplicate_check" onClick="emnameDuplicationCheck();" disabled>중복 확인</button>
							<div id="emnameValidationFeedback" class="invalid-feedback"></div></div>
							<span style="color:red;">${valid_emname}</span>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">회사명</th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="company" name="company" size="80" maxlength="80" value="${project.company }" class="form-control" placeholder="회사명 입력" disabled>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">E-mail</th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="email" id="email" name="email" size="80" maxlength="80" value="${project.email }" class="form-control" placeholder="이메일 입력" disabled>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">연락처</th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="phone" name="phone" size="80" maxlength="80" value="${project.phone }" class="form-control" oninput="autoHyphen2(this)" placeholder="연락처 입력" disabled>
							</div>
						</td>
					</tr>

					<c:if test="${grade == '0001' }">
					<tr>
						<th class="tg-0lax w-25 p-3">프로젝트 관리자&nbsp;<span style="color: Red">*</span></th>
						<td class="tg-0lax">
							<select class="custom-select custom-select form-control form-control-sm" aria-label="Default select example" name="userid" id="userid" disabled>
							<c:forEach var="manager" items="${managerList }" varStatus="projec_index">
								<option value='${manager.userid }'>${manager.username }</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					</c:if>
					<tr>
						<th class="tg-0lax">현장 이미지</th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="file" accept=".jpg, .jpeg, .png" id="siteImages" name="siteImages" multiple class="form-control" disabled >
							</div>
						</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div align="center">
				<button type="submit" class="btn btn-success btn-icon-split"
					id="submitBtn" onClick="initDetect();" disabled>
					<span class="icon text-white-50"> <i class="fas fa-check"></i>
					</span> <span class="text">적용</span>
				</button>&emsp;&emsp;
				<a href="/project/list?page=1&amount=10" class="btn btn-primary btn-icon-split">
                      <span class="icon text-white-50">
                          <i class="fas fa-list"></i>
                      </span>
                      <span class="text">목록으로</span>
                  </a>
			</div>

		</div>
</form:form>
	</div>
	<!-- /.container-fluid -->

</div>
<!-- End of Main Content -->
<script>
$(function() {
	$("#destination").attr('class', 'collapse show');
	$("#destTargetTab").attr('class', 'collapse-item active');	
	$("#policyTab").attr('class', 'collapse-item');
	$("#policySettingTab").attr('class', 'collapse-item');
});

function editProject() {
	$("#projectname").prop('disabled', false);
	$("#emname").prop('disabled', false);
	$("#company").prop('disabled', false);
	$("#email").prop('disabled', false);
	$("#phone").prop('disabled', false);
	$("#siteImages").prop('disabled', false);
	if(${grade} == 1) {
		$("#userid").prop('disabled', false);
	}
	$("#submitBtn").prop('disabled', false);
	
	var projectidChk = true;
	var projectnameChk = true;
	var emnameChk = true;
	var projectidDupChk = true;
	var projectnameDupChk = true;
	var emnameDupChk = true;
	}
</script>
<%@ include file="./script_projectSetting.jsp"%>
<%@ include file="../IncludeBottom.jsp"%>