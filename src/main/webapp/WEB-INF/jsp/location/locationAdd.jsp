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
		<form:form modelAttribute="projectAddForm" action="/location/register.do" method="post">
		<div class="card-body">
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable">
					<tbody>
					<tr>
						<th class="tg-0lax">프로젝트&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<select class="custom-select custom-select form-control form-control-sm" aria-label="Default select example" name="projectid" id="projectid">
								<c:forEach var="project" items="${projectlist}" varStatus="projec_index">
									<option value='${project.projectid }'>${project.projectname }</option>
								</c:forEach>
							</select>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax"><span style="color: Red">*</span>&nbsp;위치명&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<input type="text" id="location_nm" name="location_nm" size="124" maxlength="24" value="${sensor.sendorid }" class="form-control" oninput="resetLocationDuplicateChk" placeholder="프로젝트 한글명 입력">
							<button class="btn btn-outline-info" type="button" id="locationDuplicate_check" onClick="locationDuplicationCheck();">중복 확인</button>
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
				<a href="/sensor/list?page=1&amount=10" class="btn btn-primary btn-icon-split">
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
</script>
<%@ include file="./script_location.jsp"%>
<%@ include file="../IncludeBottom.jsp"%>