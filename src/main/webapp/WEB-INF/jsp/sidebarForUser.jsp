<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
    <li>
        <a class="sidebar-brand d-flex align-items-center justify-content-center" href="/construction/site">
            <div class="sidebar-brand-icon logoWrap rotate-n-10">
                <img src="/img/ic_launcher_round.png" alt="launcher round icon">
            </div>
            <div class="sidebar-brand-text margin_l10 h4">Auto Sensing</div>
        </a>
    </li>
    <li class="sidebarToggleWrap text-right">
        <button class="rounded-circle border-0" id="sidebarToggle" aria-label="sidebarToggle"></button>
    </li>
	
    <li class="nav-item">
        <a class="nav-link" href="/construction/site">
            <i class="fa-solid fa-chart-line"></i><span>현장 정보</span>
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link collapsed" href="#SensorList" data-bs-toggle="collapse" data-bs-target="#SensorList"
            aria-expanded="false" aria-controls="vpnSettings">
            <i class="fas fa-fw fa-cog"></i><span>센서 정보</span>
        </a>
        <div id="SensorList" class="collapse animated--grow-in" aria-labelledby="heading" data-bs-parent="#accordionSidebar">
            <div class="toggled">
                <i class="fas fa-fw fa-cog"></i><span>센서 정보</span>
            </div>
            <div class="bg-white collapse-inner" id="sensorlist">
				<c:forEach var="sensor" items="${sensorlist}">
					<a id="interfaceTab" class="collapse-item" href="/vpn/settings/interface.do"> ${sensor.sensorname} </a>
				</c:forEach>
            </div>
        </div>
 
    </li>
</ul>
