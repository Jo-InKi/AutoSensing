<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<div class="d-sm-flex align-items-center justify-content-between mb-4">
		<h1 class="h3 mb-2 text-gray-800"
			style="font-family: 'IBM Plex Sans KR';">
			목적지 및 정책 관리 > <span style="color: #0d6efd;">정책 관리</span>
		</h1>
	</div>
	<hr>

	<div class="card shadow mb-4">
		<div class="card-body">
			<div class="row">
				<table class="table table-borderless">
					<tr>
						<td rowspan="3"><div>
								<h4 style="color: black; font-family: 'IBM Plex Sans KR';"> 사용자 리스트</h4>
								<div class="card shadow mb-2">
									<div class="card-header">
										<table class="table table-bordered" id="projectManage">
											<tbody>
												<tr>
													<td>
														<div class="input-group mb-3">
															<input type="text" id="userListSearchKeyword"
																class="form-control bg-light border-0 small"
																placeholder="Search for...">
															<button class="btn btn-light" type="button" onclick="userListSearch();">
																<i class="fas fa-search fa-sm"></i>
															</button>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="card-body" id="userListCard"
										style="overflow: scroll; width: 100%; height: 450px;">
										<c:forEach var="user" items="${userList}">
											<button onClick="userListClick('${user.userid}')"
												id="${user.userid }" value="${user.userid}"
												name="userList"
												class="list-group-item list-group-item-action">
												${user.username }
												</button>
										</c:forEach>
									</div>
								</div>
							</div>
						</td>
						<td rowspan="3"><div>
								<h4 style="color: black; font-family: 'IBM Plex Sans KR';"> 설정 가능 사용자 목록</h4>
								<div class="card shadow mb-2">
									<div class="card-header">
										<table class="table table-bordered" id="notAssigned">
											<tbody>
												<tr>
													<td>
														<div class="input-group mb-3">
															<input type="text" id="targetListSearchKeyword"
																class="form-control bg-light border-0 small"
																placeholder="Search for...">
															<button class="btn btn-light" type="button" onclick="destListSearch();">
																<i class="fas fa-search fa-sm"></i>
															</button>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="card-body" id="notAssignedListCard"
										style="overflow: scroll; width: 100%; height: 450px;">
										<c:forEach var="dest" items="${destList}">
											<button onClick="notAssignedListClick('${dest.DEST_SN}')"
												id="${dest.DEST_SN }" value="${dest.DEST_SN}"
												name="targetList"
												class="list-group-item list-group-item-action">
												${dest.DEST_NM }
												</button>
										</c:forEach>
									</div>
								</div>
							</div>
						</td>
						<td></td>
						<td rowspan="3"><div>
								<h4 id="policyName"
									style="color: black; font-family: 'IBM Plex Sans KR';">사용자 목록</h4>

								<div class="card shadow mb-2">
									<div class="card-header">
										<table class="table table-bordered" id="policyManage">
											<tbody>
												<tr>
													<td>
														<div class="input-group mb-3">
															<input type="text"
																class="form-control bg-light border-0 small"
																placeholder="Search for..." id="targetInPolicySearchKeyword">
															<button class="btn btn-light" type="button" onclick="destInPolicySearch();">
																<i class="fas fa-search fa-sm"></i>
															</button>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div class="card-body" id="assignedListCard"
										style="overflow: scroll; width: 100%; height: 450px;"></div>
								</div>
							</div></td>
					</tr>
					<tr height="50px;">
						<td>
							<button id="moveToRight" class="btn btn-secondary"
								onClick="assignedProject();" disabled>
								<i class="fa-solid fa-caret-right"></i>
							</button> <br>
							<button id="moveToLeft" class="btn btn-secondary"
								onClick="notassignedProject();" disabled>
								<i class="fa-solid fa-caret-left"></i>
							</button>
						</td>
					</tr>
					<tr>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<!-- /.container-fluid -->
<!-- End of Main Content -->
<script>
	$(function() {
		$("#destination").attr('class', 'collapse show');
		$("#destTargetTab").attr('class', 'collapse-item');
		$("#policyTab").attr('class', 'collapse-item active');
		$("#policySettingTab").attr('class', 'collapse-item');
	});
</script>
<%@ include file="./script_projectManage.jsp"%>
<%@ include file="../IncludeBottom.jsp"%>