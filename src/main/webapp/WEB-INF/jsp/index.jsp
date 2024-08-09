<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Auto Sensing</title>

<!-- Custom fonts for this template-->
<link href="/assets/vendor/fontawesome-free/css/all.min.css"
	rel="stylesheet" type="text/css">
<link
	href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
	rel="stylesheet">
<!-- Custom styles for this template-->
<link href="/assets/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body class="bg-gradient-primary">

	<div class="container">
		<input type="hidden" name="loginFailMessage"
			value="<c:out value='${LoginFailMessage}' />" />
		<!-- Outer Row -->
		<div class="row justify-content-center">

			<div class="col-xl-10 col-lg-12 col-md-9">

				<div class="card o-hidden border-0 shadow-lg my-5">
					<div class="card-body p-0">
						<!-- Nested Row within Card Body -->
						<div class="row">
							<div class="col-lg-6" style="margin: 0 auto;">
								<div class="p-5">
									<div class="text-center">
										<img src="/img/ic_launcher_round.png" width="50px"
											height="50px" /> <br />
										<br />
										<h3 style="color: black;"><b>Auto Sensing</b></h3>
									</div>
									<hr />
									<br />
									<form action="/login" method="POST">

										<c:if test="${LoginFailMessage ne null}">
											<div class="alert alert-danger" role="alert"
												id="loginFailAlert">
												<c:out value="${LoginFailMessage}" />
											</div>
										</c:if>
										<c:if test="${ChangeSuccessMessage ne null}">
											<div class="alert alert-success" role="alert"
												id="ChangeSuccessMessage">
												<c:out value="${ChangeSuccessMessage}" />
											</div>
										</c:if>
										<div class="form-group">
											<input type="text" class="form-control form-control-user"
												id="userid" name="userid" aria-describedby="usernameHelp"
												placeholder="ID" required />
											<!-- required autofocus -->
										</div>
										<div class="form-group">
											<input type="password" class="form-control form-control-user"
												id="password" name="password" placeholder="Password"
												required />
											<!-- required autofocus-->
										</div>
										<c:choose>
											<c:when test="${active_time ne null}">
												<button id="loginButton" type="submit"
													class="btn btn-primary btn-user btn-block" disabled>Login</button>
											</c:when>
											<c:otherwise>
												<button id="loginButton" type="submit"
													class="btn btn-primary btn-user btn-block">Login</button>
											</c:otherwise>
										</c:choose>
									</form>
									<p></p>
									<c:if test="${active_time ne null}">
										<div id="showRemainTime">
											<i style="color: Grey;" class="fas fa-clock fa-fw"></i>&nbsp;
											<span style="color: FireBrick;" id="showClockText"></span>
										</div>
									</c:if>
									<br/>
									<hr/>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- JavaScript -->

	<footer class="sticky-footer">
		<div class="container">
			<div class="copyright text-center my-auto">
				<div class="h5 fc_666">
<!-- 
					<img class="logo_white" src="/img/norma_logo.png" alt="My Image" height="17px" /> 
					<span class="text-gray-200 small">Copyright &copy; NORMA, Inc. All rights reserved.</span>
 -->
					<span class="text-gray-500 small"> <span>Auto Sensing v1.0.0</span> 
					</span>
				</div>
			</div>
		</div>
	</footer>
	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i></a>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script src="/assets/vendor/jquery/jquery.min.js"></script>
	<script src="/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="/assets/vendor/bootstrap/js/bootstrap.bundle.js"></script>

	<!-- Core plugin JavaScript-->
	<script src="/assets/vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for all pages-->
	<script src="/assets/js/sb-admin-2.min.js"></script>

	<script src="/assets/js/demo/jquery-3.6.4.min.js"></script>

	<script src="/assets/js/demo/jquery-3.6.4.min.js"></script>
	<script src="/assets/js/demo/jquery.min.js"></script>
	
	<!-- SHA 256 script -->
	<script src="/assets/vendor/crypto-js/4.1.1/core.min.js" type="text/javascript"></script>
	<script src="/assets/vendor/crypto-js/4.1.1/sha256.js" type="text/javascript"></script>
	
	<link rel="stylesheet" href="/assets/css/style.min.css" />

	<!-- <script src="/assets/js/jquery.min.js"></script>
<script src="/assets/js/jquery.js"></script> -->
</body>

</html>