<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800" style="font-family:'IBM Plex Sans KR';">프로젝트 관리 > 위치 조회 > <span style="color:#0d6efd;">위치 추가</span></h1>
	<hr>
	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<form:form modelAttribute="projectAddForm" action="/location/register.do" method="post">
		<div class="card-body">
			<div align="right">
				<a href="#"><button type="button"
						class="btn btn-info btn-icon-split" onClick="editLocation();">
						<span class="icon text-white-50"><i
							class="fa-solid fa-user-pen"></i></span> <span class="text">수정</span>
					</button></a>
			</div>
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable">
					<tbody>
					<tr hidden="true">
						<th class="tg-0lax">프로젝트&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="location_sn" name="location_sn" size="124" maxlength="24" value="${location.location_sn }" class="form-control" disabled>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">프로젝트&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<select class="custom-select custom-select form-control form-control-sm" aria-label="Default select example" name="projectid" id="projectid" disabled>
								<c:forEach var="project" items="${manProjectlist}" varStatus="projec_index">
									<c:choose>
										<c:when test="">
										<option value='${project.projectid == location.projectid}' selected>${project.projectname }</option>
										</c:when>
										<c:otherwise>
											<option value='${project.projectid }'>${project.projectname }</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax"><span style="color: Red">*</span>&nbsp;위치명&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<input type="text" id="location_nm" name="location_nm" size="124" maxlength="24" value="${location.location_nm }" class="form-control" oninput="resetLocationDuplicateChk" placeholder="위치 한글명 입력" disabled>
							<button class="btn btn-outline-info" type="button" id="locationDuplicate_check" onClick="locationDuplicationCheck();" disabled>중복 확인</button>
							<div id="locationValidationFeedback" class="invalid-feedback"></div></div>
							<span style="color:red;">${valid_sensorid}</span>
						</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div align="center">
				<button type="submit" class="btn btn-success btn-icon-split" id="locationSubmit" onClick="initDetect();">
						<span class="icon text-white-50"> <i class="fas fa-check"></i>
						</span> <span class="text">추가</span>
					</button>&emsp;&emsp;
				<a href="/location/list.do?page=1&amount=10" class="btn btn-primary btn-icon-split">
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

function editLocation() {
	$("#location_sn").prop('disabled', false);
	$("#location_nm").prop('disabled', false);
	$("#projectid").prop('disabled', false);

	var locationChk = true;
	var locationDupChk = true;
}

</script>
<%@ include file="./script_location.jsp"%>
<%@ include file="../IncludeBottom.jsp"%>