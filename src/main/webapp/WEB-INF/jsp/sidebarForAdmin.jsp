<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>		<!-- Sidebar -->
		<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
			id="accordionSidebar">

			<!-- Sidebar - Brand -->
			<a class="sidebar-brand d-flex align-items-center justify-content-center"
				href="/construction/site">
				<div class="sidebar-brand-icon rotate-n-10">
					<img src="/img/ic_launcher_round.png" width="50px" height="50px"/>
				</div>
				<div class="sidebar-brand-text mx-3">Auto Sensing</div>
			</a>

			<!-- Divider -->
			<hr class="sidebar-divider my-0">

			<!-- Nav Item - Dashboard -->
			<li class="nav-item active"><a class="nav-link"
				href="/construction/site"><i class="fa-solid fa-chart-line"></i> <span>현장 정보</span></a></li>


			<div id="location">
				<c:forEach var="location" items="${manLocationList}">
					<!-- Divider -->
					<hr class="sidebar-divider">
					
					<!-- Heading -->
					<div class="sidebar-heading">${location.location_nm }</div>
					<li class="nav-item">
		                <a class="nav-link collapsed" href="#VpnSettings" data-bs-toggle="collapse" data-bs-target="#Location${location.location_sn }"
		                    aria-expanded="false" aria-controls="vpnSettings">
		                    <i class="fas fa-fw fa-cog"></i>
		                    <span>${location.location_nm }</span>
		                </a>
		                <div id="Location${location.location_sn }" class="collapse" aria-labelledby="heading" data-bs-parent="#accordionSidebar">
		                    <div class="bg-white py-2 collapse-inner rounded">
		                        <h6 class="collapse-header">${location.location_nm }</h6>
		                        <c:if test="${manSensorList[location.location_sn] == null }">
									<div class="bg-white collapse-inner" id="sensorlist" style="text-align: center;">
										<span style="color:red;font-weight:bold;">센서가 존재하지 않습니다.</span>
									</div>
								</c:if>
								<c:forEach var="sensor" items="${manSensorList[location.location_sn]}">
									<a id="sensorTab_${sensor.sensorid}_${sensor.channel}" class="collapse-item" href="/sensor/detail?sensorid=${sensor.sensorid}&channel=${sensor.channel}&page=1&amount=10">${sensor.sensorname}</a>
								</c:forEach>
		                    </div>
		                </div>
		            </li>
				</c:forEach>
			</div>
			<!-- Divider -->
			<hr class="sidebar-divider">
			
			<div class="sidebar-heading">프로젝트 관리</div>
			<li class="nav-item">
                <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#ProjectMan"
                    aria-expanded="true" aria-controls="destination">
                    <i class="fas fa-fw fa-tools"></i>
                    <span>프로젝트 관리</span>
                </a>
                <div id="ProjectMan" class="collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <h6 class="collapse-header">프로젝트 관리</h6>
                        <a id="ProjectTab" class="collapse-item" href="/project/list?page=1&amount=10">프로젝트 조회</a>
                        <a id="LocationTab" class="collapse-item" href="/location/list.do?page=1&amount=10">위치 조회</a>
                        <a id="SensorTab" class="collapse-item" href="/sensor/sensorlist?page=1&amount=10">센서 조회</a>
                    </div>
                </div>
            </li>

			<!-- Divider -->
			<hr class="sidebar-divider">
			<div class="sidebar-heading">사용자 관리</div>
			
			<li class="nav-item">
                <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#userManage"
                    aria-expanded="true" aria-controls="destination">
                  <i class="fa-solid fa-user-gear"></i>
                    <span>사용자 관리</span>
                </a>
                <div id="userManage" class="collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <h6 class="collapse-header">사용자 관리</h6>
                        <a id="userSettingTab" class="collapse-item" href="/user/list?page=1&amount=10">사용자 조회</a>
                        <a id="projectSettingTab" class="collapse-item" href="/user/project/setting">사용자 프로젝트 설정</a>
                    </div>
                </div>
            </li>

			<br/><br/>
			<!-- Sidebar Toggler (Sidebar) -->
			<div class="text-center d-none d-md-inline">
				<button class="rounded-circle border-0" id="sidebarToggle"></button>
			</div> 

		</ul>
		<!-- End of Sidebar -->