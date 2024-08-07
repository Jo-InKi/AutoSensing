<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">
<!-- Custom fonts for this template-->
<link href="/assets/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
<link href="/assets/css/Nunito.css" rel="stylesheet">
<link href="/assets/css/IBM-Plex-Sans-KR.css" rel="stylesheet">
<!-- Custom styles for this template-->
<link href="/assets/css/sb-admin-2.min.css" rel="stylesheet" type="text/css">
<!-- <link href="/assets/css/tab.css" rel="stylesheet" type="text/css"> -->
<!-- <script src="/assets/js/plotly-2.18.0.min.js"></script> -->
<script src="/assets/vendor/jquery/jquery.min.js"></script>
<script src="/assets/js/demo/jquery-3.6.4.min.js"></script>
<link rel="stylesheet" href="/assets/css/style.min.css" />
<script src="/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- sockJS -->
<script src="/assets/js/demo/sockjs.min.js"></script>
<script src="/assets/js/demo/stomp.min.js"></script>
<script src="/assets/js/sockjs.min.js"></script>

<script type="text/javaScript">
var maxNotifications = 4; // 최대 표시할 알림 개수
var notifications = []; // 알림을 저장할 배열
var temp = [];
// 자체 시험 결과 출력
function showResults(messages) {
	$(document).ready(function() {
	  messages.forEach(function(msg){
	   if(msg.code == '1'){
		   $("#modal-health-result").html(msg.result);
		   var str = msg.content.replace(/(?:\r\n|\r|\n)/g, '<br />');
		   
		    $("#modal-health-msg").html(str);
		    
		   if(msg.result == '실패'){
			   $("#modal-health-result").css("color", "red");
		   }else{
			   $("#modal-health-result").css("color", "green");
		   }
	   }else if(msg.code == '0'){
		   $("#modal-integrity-result").html(msg.result);
		   
		   var str = msg.content.replace(/(?:\r\n|\r|\n)/g, '<br />');
		   
		    $("#modal-integrity-msg").html(str);
		    
		    if(msg.result == '실패'){
				   $("#modal-integrity-result").css("color", "red");
			   }else{
				   $("#modal-integrity-result").css("color", "green");
			   }
	   }
	  });
		$('#testResultModal').modal("show");
	});
}
</script>
<script type="text/javascript">
// 툴팁 제어
$(function() {
	const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
	const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
});


</script>
<script type="text/javascript">
$(function(){
	//체크 박스 제어
	var chkObj = document.getElementsByName("rowCheck");
	var rowCnt = chkObj.length;
	
	$("input[name='allCheck']").click(function(){
		var chk_listArr = $("input[name='rowCheck']");
		for (var i=0; i<chk_listArr.length; i++){
			chk_listArr[i].checked = this.checked;
		}
	});
	$("input[name='rowCheck']").click(function(){
		if($("input[name='rowCheck']:checked").length == rowCnt){
			$("input[name='allCheck']")[0].checked = true;
		}
		else{
			$("input[name='allCheck']")[0].checked = false;
		}
	});
});

function changeProject(val) {
	const url = "/project/change";
	$.ajax({
		type : "GET",
		url : url,
		data: {
			"projectid" : val
		},
		success : function(data) {
			console.log(data);
			/* console.log('projectInfo', data.projectInfo);
			console.log('sensorlist', data.sensorlist);
			document.querySelector('.headerWrap').innerHTML = <"h3 class='h3'><strong>현장 정보 ( "+ data.projectInfo.projectname +" )</strong></h3>";
			
			console.log('location', document.querySelector('#location'));
			var sensorlist = '';
			for(var ii = 0; ii < data.sensorlist.length; ii++ ) {
				console.log('sensor', data.sensorlist[ii]);
				sensorlist += '<a id="interfaceTab" class="collapse-item" href=""> '+ data.sensorlist[ii].location +' </a>\n';
			}
			console.log('sensorlist', sensorlist);
			document.querySelector('#sensorlist').innerHTML = sensorlist; */
		},
		error : function(error) {
			console.log('error', error);
		}
	});

	
	//document.querySelector('.headerWrap').innerHTML = "<div class='headerWrap'> <h3 class='h3'><strong>현장 정보 ( "+ str +" )</strong></h3> </div>";

}

</script>
<style>
 h1, h2, h4, h5{
     color: black;
    font-family:'IBM Plex Sans KR';
    }

</style>

<title>Auto Sensing</title>
</head>

<body id="page-top" oncontextmenu="return false" ondragstart="return false">

	<!-- Page Wrapper -->
	<div id="wrapper">
		<!-- 사용자 권한 별 Sidebar 처리 -->
		<c:if test="${grade eq '0001'}">
				<%@ include file="sidebarForAdmin.jsp"%>
		</c:if>
		<c:if test="${grade eq '0002'}">
				<%@ include file="sidebarForManager.jsp"%>
		</c:if>
				<c:if test="${grade eq '0003'}">
			<%@ include file="sidebarForUser.jsp"%>
		</c:if>
		<!-- End of Sidebar -->
		
		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">
			<!-- Main Content -->
			<div id="content">
				<!-- Topbar -->
				<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
					<!-- Sidebar Toggle (Topbar) -->
					<button id="sidebarToggleTop"
						class="btn btn-link d-md-none rounded-circle mr-3">
						<i class="fa fa-bars"></i>
					</button>
          			<div class="searchWrap">
						<select aria-label="Default select example" name="ProjectList" id="ProjectList"
							class="custom-select search_select w_500" onchange="if(this.value) location.href=(this.value);">
							<c:forEach var="project" items="${manProjectlist}">
								<c:choose>
									<c:when test="${project.projectid eq currProjectid}">
										<option value='/project/change?projectid=${project.projectid}' selected>${project.projectname} </option>
									</c:when>
									<c:otherwise>
										<option value='/project/change?projectid=${project.projectid}'>${project.projectname} </option>
									</c:otherwise>
								</c:choose>
							
							</c:forEach>
						</select>

					</div>
          			
					<!-- Topbar Navbar -->
					<ul class="navbar-nav ml-auto">	
						<!-- Nav Item - User Information -->
						<li class="nav-item dropdown no-arrow">
						<a
							class="nav-link dropdown-toggle"
							role="button" aria-haspopup="true" href="/vpn/admin/mypage.do?userId=${username }"
							aria-expanded="false"> <i class="fas fa-user fa-fw"></i>&nbsp;<span
								class="mr-2 d-none d-lg-inline text-gray-900 small">${username }</span>
						</a>
						</li>
					

						<!-- Nav Item - 로그아웃 버튼 -->
						<li class="nav-item dropdown no-arrow mx-1">
							<div class="nav-link dropdown-toggle">
								<a href="#" data-bs-toggle="modal" data-bs-target="#logoutModal"
									class="btn btn-light btn-icon-split btn-sm"> <span
									class="icon text-white-60"> <i
										class="fas fa-sign-out-alt"></i>
								</span> <span class="text">Logout</span>
								</a>
							</div>
					</ul>
				</nav>
				<!-- Logout Modal-->
				<div class="modal fade" id="logoutModal" data-bs-backdrop="static" data-bs-keyboard="false"  tabindex="-1" role="dialog"
					aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">로그아웃</h5>
							</div>
							<div class="modal-body">세션을 종료하고 로그아웃 하시겠습니까?</div>
							<div class="modal-footer">
								<button class="btn btn-secondary" type="button"
									data-bs-dismiss="modal">Cancel</button>
								<sec:authorize access="isAuthenticated()"><a class="btn btn-primary" href="/logout">Logout</a></sec:authorize>
							</div>
						</div>
					</div>
				</div>