<%@ include file="../IncludeTop.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="/assets/css/uikit.min.css" />
<link rel="stylesheet" href="/assets/css/jquery.datetimepicker.css" />
<script src="/assets/js/uikit.min.js"></script>
<script src="/assets/js/uikit-icons.min.js"></script>
<script src="/assets/js/jquery.js"></script>
<script src="/assets/js/jquery.datetimepicker.full.min.js"></script>


<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.3/moment.min.js"></script>

<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800" style="font-family:'IBM Plex Sans KR';">${sensor.sensorname }</span></h1>
	<hr>
	<div class="col-sm-12">
	<form:form modelAttribute="userSearchForm" id="userSearchForm"
		action="/sensor/detail" method="get">
		<input type="hidden" name="pageNum" id="pageNum" value="1" />
		<table class="table table-bordered" id="SearchTable">
			<tbody>
				<tr>
					<td class="col-sm-1 text-center align-middle">시작일시</td>
					<td >
						<div class="uk-inline">
		                     <span class="uk-form-icon uk-icon" uk-icon="icon: calendar"><svg width="20" height="20" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M 2,3 2,17 18,17 18,3 2,3 Z M 17,16 3,16 3,8 17,8 17,16 Z M 17,7 3,7 3,4 17,4 17,7 Z"></path><rect width="1" height="3" x="6" y="2"></rect><rect width="1" height="3" x="13" y="2"></rect></svg></span>
	                        <input class="uk-input" type="text" id="date_time_start">
		                    </div>
					</td>
					<td class="col-sm-1 text-center align-middle">종료일시</td>
					<td >
						<div class="uk-margin-left">
		                    <div class="uk-inline">
		                        <span class="uk-form-icon uk-icon" uk-icon="icon: calendar"><svg width="20" height="20" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M 2,3 2,17 18,17 18,3 2,3 Z M 17,16 3,16 3,8 17,8 17,16 Z M 17,7 3,7 3,4 17,4 17,7 Z"></path><rect width="1" height="3" x="6" y="2"></rect><rect width="1" height="3" x="13" y="2"></rect></svg></span>
		                        <input class="uk-input" type="text" id="date_time_end">
		                    </div>
                		</div>
					</td>
					<td colspan="2">
						<select class="uk-select w-100" id="time">
	                        <option value="" selected>시각</option>
	                        <option value="01">1시</option>
	                        <option value="02">2시</option>
	                        <option value="03">3시</option>
	                        <option value="04">4시</option>
	                        <option value="05">5시</option>
	                        <option value="06">6시</option>
	                        <option value="07">7시</option>
	                        <option value="08">8시</option>
	                        <option value="09">9시</option>
	                        <option value="10">10시</option>
	                        <option value="11">11시</option>
	                        <option value="12">12시</option>
	                        <option value="13">13시</option>
	                        <option value="14">14시</option>
	                        <option value="15">15시</option>
	                        <option value="16">16시</option>
	                        <option value="17">17시</option>
	                        <option value="18">18시</option>
	                        <option value="19">19시</option>
	                        <option value="20">20시</option>
	                        <option value="21">21시</option>
	                        <option value="22">22시</option>
	                        <option value="23">23시</option>
	                        <option value="00">24시</option>
	                    </select>
					</td>
					<td colspan="2">
					<select class="uk-select w-100" id="intervalday">
	                       <option value="0" selected>평균</option>
	                       <option value="1">1일</option>
	                       <option value="2">2일</option>
	                       <option value="3">3일</option>
	                       <option value="4">4일</option>
	                       <option value="5">5일</option>
	                       <option value="6">6일</option>
	                       <option value="7">7일</option>
	                       <option value="8">8일</option>
	                       <option value="9">9일</option>
	                       <option value="10">10일</option>
	                       <option value="11">11일</option>
	                       <option value="12">12일</option>
	                       <option value="13">13일</option>
	                       <option value="14">14일</option>
	                       <option value="15">15일</option>
	                   </select>
	                   </td>
				</tr>
				<tr>
					<td colspan="8" class="col-sm-1 text-center align-middle">
						<button class="btn btn-primary" type="button" onClick="handleSubmit();">
							<i class="fas fa-search fa-sm"></i>
						</button>
						<button class="btn btn-primary" type="button"
							onClick="resetSearchForm();">
							<i class="fa-solid fa-rotate-left"></i>
						</button>
					</td>
				</tr>
			</tbody>
		</table>
	</form:form>
	</div>
	
	<div class="col-xl-12 col-lg-12">
		<div class="card shadow mb-4">
			<ul class="nav nav-tabs">
				<li class="nav-item" id="chartTab">
					<a class="nav-link" id="chartTab" onClick="changeTab(this);">CHART</a>
				</li>
				<li class="nav-item" id="dataTab">
					<a class="nav-link" id="dataTab" onClick="changeTab(this);">DATA</a>
				</li>
				<li class="nav-item" id="infoTab">
					<a class="nav-link" id="infoTab" onClick="changeTab(this);">INFO</a>
				</li>
			</ul>
			<div id="tab1" class="col-xl-12 col-lg-12">
				<div class="table-responsive">
					<div class="row margin_t20">
						<!-- 접속 사용자 추이 graph -->
						<div class="col-xl-12 col-lg-12">
							<div class="card shadow">
								<div align="left" class="text-gray-900">변화량(mm)</div>
								<div align="left" class="text-gray-900">Initial Date : ${sensor.initdate }</div>
								<!-- Card Body -->
								<div class="card-body">
									<div class="chart-area">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="tab2" class="col-xl-12 col-lg-12" hidden="true">
				<div class="table-responsive">
					<div class="row margin_t20">
						<!-- 접속 사용자 추이 graph -->
						<div class="col-xl-12 col-lg-12">
							<div class="card shadow">
								<hr>
								<div align="right">
									<button type="button" class="btn btn-primary" onclick="saveChartAsPDF()">REPORT</button>
									<button type="button" class="btn btn-secondary" onClick="downloadExcel();">EXCEL</button>
								</div>
								<!-- Card Body -->
								<div class="card-body">
									<div align="left" class="text-gray-900">Initial Date : ${sensor.initdate }</div>
									<div align="left" class="text-gray-900">총 ${pageMaker.realEnd}페이지 중 ${pageMaker.page.pageNum}</div>
									<hr />
											<span style="color: green;">${successMsg}</span>
											<span style="color: red;">${errorMsg}</span>
											<div class="table-responsive">
												<table class="table table-bordered" id="dataTable">
													<thead>
														<tr class="text-center">
															<th>번호</th>
															<th>시간</th>
															<th>평균값</th>
															<th>상태값</th>
														</tr>
													</thead>
													<tbody>
													 <c:if test="${destList.size() == 0 }">
						                                <tr>
						                                    <td class="tl_c" colspan="8">no data </td>
						                                </tr>
						                                </c:if>
						                            	<c:forEach var="report" items="${sensorReport}" varStatus="sensor_index">
															<tr>
																<td data-label="번호" class="text-left">${sensor_index.index + 1}</td>
																<td nowrap style="overflow:hidden;" data-label="센서ID">${report.time}</td>
																<td nowrap style="overflow:hidden;" data-label="Channel">
																	<fmt:formatNumber value="${report.aiv}" pattern="0.000"/>
																</td>
																<td nowrap style="overflow:hidden;" data-label="위치">
																	<fmt:formatNumber value="${report.value}" pattern="0.000"/>
																</td>
															</tr>
														</c:forEach>
						                            </tbody>
												</table>
											</div>
										</div>
						                <!-- Pagination -->
						                <div class="row- no-gutters">
						                    <nav aria-label="Page navigation">
						                        <c:if test="${not empty pageMaker}">
						                            <ul class="pagination justify-content-center" id="pagination">
						                                <li class="page-item ${pageMaker.page.pageNum eq 1 ? 'disabled' : '' }">
						                                    <a id="previous" class="page-link">Previous</a>
						                                </li>
						                                <c:forEach var="i" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
						                                    <c:if test="${pageMaker.page.pageNum eq i }">
						                                        <li class="page-item active">
						                                            <a class="page-link">${i }</a>
						                                        </li>
						                                    </c:if>
						                                    <c:if test="${pageMaker.page.pageNum ne i }">
						                                        <li class="page-item">
						                                            <a href="#" id="page${i}"class="page-link">${i }</a>
						                                        </li>
						                                    </c:if>
						                                </c:forEach>
						                                <li class="page-item ${(pageMaker.realEnd eq 0 || pageMaker.page.pageNum eq pageMaker.realEnd) ? 'disabled' : '' }">
						                                    <a id="next" class="page-link">Next</a>
						                                </li>
						                            </ul>
						                        </c:if>
						                    </nav>
						                </div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="tab3" class="col-xl-12 col-lg-12" hidden="true">
				<div class="table-responsive">
					<div class="row margin_t20">
						<!-- 접속 사용자 추이 graph -->
						<div class="col-xl-12 col-lg-12">
							<div class="card shadow">
								<!-- Card Body -->
								<div class="card-body">
											<div class="table-responsive">
												<table class="table table-bordered" id="dataTable">
													<tbody>
														<tr>
															<th class="tg-0lax">프로젝트</th>
															<td class="tg-0lax">
																${projectname }
															</td>
														</tr>
														<tr>
															<th class="tg-0lax"> 센서 아이디</th>
															<td class="tg-0lax">
																<div class="table_inputWrap">
																	${sensor.sensorid }
																</div>
															</td>
														</tr>
														<tr>
															<th class="tg-0lax">체널	</th>
															<td class="tg-0lax">
																<div class="table_inputWrap">
																	${sensor.channel }
																</div>
															</td>
														
														</tr>
														<tr>
															<th class="tg-0lax">설치 위치</th>
															<td class="tg-0lax">
																${sensor.sensorname }
															</td>
														</tr>
														<tr>
															<th class="tg-0lax">설치 일시</th>
															<td class="tg-0lax">
																${sensor.initdate }
															</td>
														</tr>
														<tr>
															<th class="tg-0lax">게이지 팩터</th>
															<td class="tg-0lax">
																${sensor.factor }
															</td>
														</tr>
														<tr>
															<th class="tg-0lax">최소가이드1~3</th>
															<td class="tg-0lax" data-label="회사명">
																1: ${sensor.guidel1min }
																2: ${sensor.guidel2min }
																3: ${sensor.guidel3min }
															</td>
														</tr>
														<tr>
															<th class="tg-0lax">최대가이드1~3</th>
															<td class="tg-0lax" data-label="회사명">
																1: ${sensor.guidel1max }
																2: ${sensor.guidel2max }
																3: ${sensor.guidel3max }
															</td>
														</tr>
														<tr>
															<th class="tg-0lax">계산식</th>
															<td class="tg-0lax" data-label="* E-mail">
																<div class="table_inputWrap">
																	${sensor.calcstring }
																</div>
															</td>
														</tr>
																						
						                            </tbody>
												</table>
											</div>
										</div>
						                <!-- Pagination -->
						                <div class="row- no-gutters">
						                    <nav aria-label="Page navigation">
						                        <c:if test="${not empty pageMaker}">
						                            <ul class="pagination justify-content-center" id="pagination">
						                                <li class="page-item ${pageMaker.page.pageNum eq 1 ? 'disabled' : '' }">
						                                    <a id="previous" class="page-link">Previous</a>
						                                </li>
						                                <c:forEach var="i" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
						                                    <c:if test="${pageMaker.page.pageNum eq i }">
						                                        <li class="page-item active">
						                                            <a class="page-link">${i }</a>
						                                        </li>
						                                    </c:if>
						                                    <c:if test="${pageMaker.page.pageNum ne i }">
						                                        <li class="page-item">
						                                            <a href="#" id="page${i}"class="page-link">${i }</a>
						                                        </li>
						                                    </c:if>
						                                </c:forEach>
						                                <li class="page-item ${(pageMaker.realEnd eq 0 || pageMaker.page.pageNum eq pageMaker.realEnd) ? 'disabled' : '' }">
						                                    <a id="next" class="page-link">Next</a>
						                                </li>
						                            </ul>
						                        </c:if>
						                    </nav>
						                </div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
<!-- End of Main Content -->
<script>

$('#date_time_start').datetimepicker({theme:'dark', step:60, format:'Y.m.d H:i', maxDate:'0'});
$('#date_time_end').datetimepicker({theme:'dark', step:60, format:'Y.m.d H:i', maxDate:'0'});

</script>
<%@ include file="./sensorCharts.jsp"%>
<%@ include file="../IncludeBottom.jsp"%>