<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<div class="headerWrap">
		<h3 class="h3">
			<span class="fc_888">센서 관리 &gt;</span> <strong>센서 설정</strong>
		</h3>
	</div>
	<div class="contentWrap">
		<div class="settingContainer align-items-stretch minHeight">
			<div class="settingWrap d-flex justify-content-between gap20 align-items-center width100">
				<div class="width50 devideWrap height100 d-flex flex-column">
					<h4 class="h4 fc_666">Project List</h4>
					<div class="searchWrap margin_t20">
						<input type="text" id="targetListSearchKeyword" class="search_input"
							placeholder="검색할 사용자 아이디를 입력하세요.">
						<button class="button bgc_PB1" type="button" onclick="destListSearch();"><i
								class="fas fa-search fa-sm"></i></button>
					</div>
					<div class="viewWrap margin_t20 flex-grow-1" id="targetListCard">
						<c:forEach var="project" items="${projectlist}">
							<button onClick="projectListClick('${project.projectid}')" id="${project.projectid }"
								value="${project.projectid}" name="targetList"
								class="list-group-item list-group-item-action">
								${project.projectname }
							</button>
						</c:forEach>
					</div>
				</div>
				<div class="width50 devideWrap height100 d-flex flex-column">
					<h4 class="h4 fc_666">Senser List</h4>
					<div class="searchWrap margin_t20">
						<input type="text" id="targetListSearchKeyword" class="search_input"
							placeholder="검색할 프로젝트 이름을 입력하세요.">
						<button class="button bgc_PB1" type="button" onclick="destListSearch();"><i
								class="fas fa-search fa-sm"></i></button>
					</div>
					<div class="viewWrap margin_t20 flex-grow-1" id="sensorListCard">
						<c:forEach var="dest" items="${destList}">
							<button onClick="targetListClick('${dest.DEST_SN}')" id="${dest.DEST_SN }"
								value="${dest.DEST_SN}" name="targetList"
								class="list-group-item list-group-item-action">
								${dest.DEST_NM }
							</button>
						</c:forEach>
					</div>
				</div>
				<div class="w_50">
					<button id="moveToRight" class="btn btn-secondary" onClick="moveElementToRight();" disabled>
						<i class="fa-solid fa-caret-right"></i>
					</button>
					<button id="moveToLeft" class="btn btn-secondary margin_t20" onClick="moveElementToLeft();" disabled>
						<i class="fa-solid fa-caret-left"></i>
					</button>
				</div>
				<div class="width50 devideWrap height100 d-flex flex-column">
					<h4 class="h4 fc_666" id="policyName">센서를 선택하세요.</h4>
					<div class="searchWrap margin_t20">
						<input type="text" class="search_input" placeholder="검색할 프로젝트 이름을 입력하세요."
							id="targetInPolicySearchKeyword">
						<button class="button bgc_PB1" type="button" onclick="destInPolicySearch();">
							<i class="fas fa-search fa-sm"></i>
						</button>
					</div>
					<div class="viewWrap margin_t20 flex-grow-1" id="projectSensorListCard"></div>
				</div>
			</div>
		</div>
		<div class="buttonWrap margin_t20 justify-content-center">
			<button type="submit" class="btn_iconSpritWrap bgc_PE1" onclick="saveTheChange();">
				<div class="icon"><i class="fas fa-check"></i></div>
				<span class="text">저장</span>
			</button>
		</div>
	</div>
</div>
<!-- /.container-fluid -->
<!-- End of Main Content -->
<script>
	document.addEventListener('DOMContentLoaded',function() {
		document.querySelector('#destination').className = 'collapse show';
		document.querySelector('#destTargetTab').className = 'collapse-item';
		document.querySelector('#policyTab').className = 'collapse-item active';
		document.querySelector('#policySettingTab').className = 'collapse-item';
	});
</script>
<%@ include file="./script_sensorSetting.jsp"%>
<%@ include file="../IncludeBottom.jsp"%>