<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- Begin Page Content -->
<div class="container-fluid">
	<!-- Page Heading -->
	<div class="headerWrap">
		<h3 class="h3"><strong>현장 정보 ( ${currProject.projectname} )</strong></h3>
	</div>
	<div class="contentWrap dashboard">
		<div class="fc_888">
			<div class="fc_888 divide" id="isRenewal"></div>
		</div>
		<div class="siteImage">

			<c:choose>
			    <c:when test="${empty currProject.mappath}">
			        <img alt="Not MapFile" src="/img/no-image-icon.png" height="640px">
			    </c:when>
			    <c:otherwise>
					<c:set var="images" value="${fn:split(currProject.mappath,',')}" />
					<c:forEach var="image" items="${images}" varStatus="varStatus">
						<img alt="MapFile" src="/map/${currProjectid }/${image}" height="640px">
						<br>
				    </c:forEach> 
			    </c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<!-- Page level plugins -->
<script src="/assets/vendor/chart.js/Chart.min.js"></script>
<script src="/assets/vendor/chart.js/gauge.min.js"></script>
<!-- Page level custom scripts -->
<script src="/assets/js/demo/chart-area-demo.js"></script>
<script src="/assets/js/demo/chart-pie-demo.js"></script>
<script src="/assets/js/demo/chart-bar-demo.js"></script>
<%@ include file="../IncludeBottom.jsp"%>