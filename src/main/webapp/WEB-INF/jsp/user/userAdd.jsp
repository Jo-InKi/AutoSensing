<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800" style="font-family:'IBM Plex Sans KR';">츠로젝트 관리 > 센서 조회 > <span style="color:#0d6efd;">센서 추가</span></h1>
	<hr>
	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<form:form modelAttribute="projectAddForm" action="/sensor/register.do" method="post">
		<div class="card-body">
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable">
					<tbody>
					<tr>
						<th class="tg-0lax">사용자 등급&emsp;</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<select class="custom-select custom-select form-control form-control-sm" aria-label="Default select example" name="grade" id="grade" >
									<option value='0002'>프로젝트 관리자</option>
									<option value='0003'>일반 사용자</option>
							</select>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">아이디&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<input type="text" id="sensorid" name="userid" size="124" maxlength="24" value="${user.userid }" class="form-control" oninput="resetSensorIdDuplicateChk" placeholder="사용자 아이디">
							<button class="btn btn-outline-info" type="button" id="sensoridIDduplicate_check" onClick="sensorIdDuplicationCheck();">중복 확인</button>
							<div id="sensoridValidationFeedback" class="invalid-feedback"></div></div>
							<span style="color:red;">${valid_userid}</span>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">이름</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="username" name="username" size="80" maxlength="80" value="${user.username }" class="form-control" placeholder="이름 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">비밀번호</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="username" name="username" size="80" maxlength="80" value="${user.username }" class="form-control" placeholder="이름 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">비밀번호 확인</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="username" name="username" size="80" maxlength="80" value="${user.username }" class="form-control" placeholder="이름 입력">
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">E-mail</th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="email" id="email" name="email" size="80" maxlength="80" value="${user.email }" class="form-control" placeholder="이메일 입력">
								<button class="btn btn-outline-info" type="button" id="sensoridIDduplicate_check" onClick="sensorIdDuplicationCheck();">중복 확인</button>
								<div id="sensoridValidationFeedback" class="invalid-feedback"></div>
							</div>
							<span style="color:red;">${valid_email}</span>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">연락처</th>
							<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="phone" name="phone" size="80" maxlength="80" value="${user.phone }" class="form-control" oninput="autoHyphen2(this)" placeholder="연락처 입력">
								<button class="btn btn-outline-info" type="button" id="sensoridIDduplicate_check" onClick="sensorIdDuplicationCheck();">중복 확인</button>
								<div id="sensoridValidationFeedback" class="invalid-feedback"></div>
							</div>
							<span style="color:red;">${valid_phone}</span>
						</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div align="center">
				<button type="submit" class="btn btn-success btn-icon-split" id="sensorSubmit" onClick="initDetect();">
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
<%@ include file="./script_userSetting.jsp"%>
<%@ include file="../IncludeBottom.jsp"%>