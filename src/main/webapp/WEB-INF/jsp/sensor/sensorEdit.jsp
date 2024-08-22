<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800" style="font-family:'IBM Plex Sans KR';">츠로젝트 관리 > 센서 조회 > <span style="color:#0d6efd;">센서 수정</span></h1>
	<hr>
	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<form:form modelAttribute="projectAddForm" action="/sensor/update.do" method="post">
		<div class="card-body">
			<div align="right">
				<a href="#"><button type="button"
						class="btn btn-info btn-icon-split" onClick="editSensor();">
						<span class="icon text-white-50"><i
							class="fa-solid fa-user-pen"></i></span> <span class="text">수정</span>
					</button></a>
			</div>
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable">
					<tbody>
					<tr>
						<th class="tg-0lax">프로젝트&emsp;</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<select class="custom-select custom-select form-control form-control-sm" aria-label="Default select example" name="projectid" id="projectid" onchange="projectChange(this.value)" disabled>
								<c:forEach var="project" items="${manProjectlist}" varStatus="projec_index">
									<option value='${project.projectid }'>${project.projectname }</option>
								</c:forEach>
							</select>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">설치 위치&emsp;</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<select class="custom-select custom-select form-control form-control-sm" aria-label="Default select example" name="location_sn" id="location_sn" disabled>
								<option>위치 없음</option>
								<c:forEach var="location" items="${locationList }">
									<option value='${location.location_sn }'>${location.location_nm }</option>
								</c:forEach>
							</select>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">아이디 및 채널&emsp; <a style="color:darkgrey;" data-bs-toggle="tooltip" data-bs-title="한글, 영문 및 숫자 3자~128자, 특수문자(-,_)만 허용, 중복 불가"><i class="fa-solid fa-circle-info"></i></a></th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
							<input type="text" id="sensorid" name="sensorid" size="124" maxlength="24" value="${sensor.sensorid }" class="form-control" oninput="resetSensorIdDuplicateChk" placeholder="센서아이디" disabled>
							<input type="number" name="channel" id="channel" min="1" value="${sensor.channel }" oninput="resetSensorIdDuplicateChk" placeholder="0" disabled >
							<button class="btn btn-outline-info" type="button" id="sensoridIDduplicate_check" onClick="sensorIdDuplicationCheck();" disabled>중복 확인</button>
							<div id="sensoridValidationFeedback" class="invalid-feedback"></div></div>
							<span style="color:red;">${valid_sensorid}</span>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">센서명</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="sensorname" name="sensorname" size="80" maxlength="80" value="${sensor.sensorname }" class="form-control" placeholder="센서명 입력" disabled>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">설치 일시</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
<%-- 								<input type="datetime-local" id="initdate" name="initdate" value="${project.email }" class="form-control"> --%>
								<input type="date" data-date-format="YYYYMMDD" id="initdate" name="initdate" value="${sensor.initdate }" class="form-control" disabled>
							</div>
						</td>
					</tr>
					<tr>
						<th class="tg-0lax">최소가이드1~3</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								1:&nbsp;<input id="guidel1min" type="number" step="0.1" class="table_input w_100" id="company" name="company" size="20" maxlength="20" value="${sensor.guidel1min }" disabled>&nbsp;
								2:&nbsp;<input id="guidel2min" type="number" step="0.1" class="table_input w_100" id="company" name="company" size="20" maxlength="20" value="${sensor.guidel2min }"disabled>&nbsp;
								3:&nbsp;<input id="guidel3min" type="number" step="0.1" class="table_input w_100" id="company" name="company" size="20" maxlength="20" value="${sensor.guidel3min }"disabled>
							</div>
						</td>
					</tr>
					
					<tr>
						<th class="tg-0lax">최대가이드1~3</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								1:&nbsp;<input id="guidel1max" type="number" step="0.1" class="table_input w_100" id="company" name="company" size="20" maxlength="20" value="${sensor.guidel1max }" disabled>&nbsp;
								2:&nbsp;<input id="guidel2max" type="number" step="0.1" class="table_input w_100" id="company" name="company" size="20" maxlength="20" value="${sensor.guidel2max }" disabled>&nbsp;
								3:&nbsp;<input id="guidel3max" type="number" step="0.1" class="table_input w_100" id="company" name="company" size="20" maxlength="20" value="${sensor.guidel3max }" disabled>
							</div>
						</td>
					</tr>
					<tr>
					<th class="tg-0lax">계산식</th>
						<td class="tg-0lax" colspan="2">
							<div class="input-group mb-3">
								<input type="text" id="calcstring" name="calcstring" size="80" maxlength="80" value="${sensor.calcstring }" class="form-control" placeholder="계산식 입력" disabled>
							</div>
						</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div align="center">
				<button type="submit" class="btn btn-success btn-icon-split" id="sensorSubmit" onClick="initDetect();">
						<span class="icon text-white-50"> <i class="fas fa-check"></i>
						</span> <span class="text">수정</span>
					</button>&emsp;&emsp;
				<a href="/sensor/sensorlist?page=1&amount=10" class="btn btn-primary btn-icon-split">
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

function editSensor() {
/* 	
	$("#sensorid").prop('disabled', false);
	$("#channel").prop('disabled', false);
	$("#sensoridIDduplicate_check").prop('disabled', false);
 */	
	$("#sensorname").prop('disabled', false);
	$("#initdate").prop('disabled', false);
	$("#guidel1max").prop('disabled', false);
	$("#guidel1min").prop('disabled', false);
	$("#guidel2max").prop('disabled', false);
	$("#guidel2min").prop('disabled', false);
	$("#guidel3max").prop('disabled', false);
	$("#guidel3min").prop('disabled', false);
	$("#calcstring").prop('disabled', false);
	$("#projectid").prop('disabled', false);
	$("#location_sn").prop('disabled', false);

	
	//유효성 검사 결과 저장 변수
	var sensoridCheck = true;
	var sensoridDupChk = true;
}
</script>
<%@ include file="./script_sensorSetting.jsp"%>
<%@ include file="../IncludeBottom.jsp"%>