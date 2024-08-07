<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	document.addEventListener('DOMContentLoaded', function(){
		const cpuGraphButton = document.getElementById('cpuGraphButton');
		if(cpuGraphButton) cpuGraphButton.style.display = 'none';
		
		getMemGraph();
		getCPUGraph();
		getDiskGraph();
		getUserConStatus();
		getVPNTraffic();
		
		var renewal_time = Number('${renewalTime}');
		if(renewal_time > 0){
			document.getElementById('isRenewal').innerText = "* 자동 갱신 ON (" + renewal_time + "s)";
			setInterval(function () { Update(); }, (renewal_time * 1000));
		}else{
			document.getElementById('isRenewal').innerText = "* 자동 갱신 OFF";
		}
	});
	
	function getTimeStamp() {
	    var d = new Date(); 

	    var s =
	        leadingZeros(d.getFullYear(), 4) + '-' +
	        leadingZeros(d.getMonth() + 1, 2) + '-' +
	        leadingZeros(d.getDate(), 2); 

	    return s;
	} 

	function leadingZeros(n, digits) {
	    var zero = '';
	    n = n.toString(); 

	    if (n.length < digits) {
	        for (i = 0; i < digits - n.length; i++)
	            zero += '0';
	    }

	    return zero + n;
	}
	
	// 데이터 갱신
	function Update() {
        $.getJSON('/vpn/dashboard/data.do',
			function (results) {
				var userConStatusList = results.userConStatusList;
				var cpuUsage = results.cpuUsage;
				var memoryUsage = results.memoryUsage;
				var diskUsage = results.diskUsage;
				var traffic = results.traffic;
				var nicInfo = results.nicInfo;

				//상단 업데이트
				cpuUse = cpuUsage.length ? cpuUsage[cpuUsage.length-1].avg1Min : 0;
				cpuUse = cpuUse.toFixed(2);
				
				//console.log('cpuUsage : ', cpuUsage)
				document.getElementById('cpuUsage').innerText = cpuUse + ' %';
				
				//memUsage = (memoryUsage[memoryUsage.length - 1].available + memoryUsage[memoryUsage.length - 1].buffered)*100/memoryUsage[memoryUsage.length - 1].total;
				memUsage = memoryUsage[memoryUsage.length - 1].total == 0 ? 0 : (memoryUsage[memoryUsage.length - 1].total - memoryUsage[memoryUsage.length - 1].used - memoryUsage[memoryUsage.length - 1].cached - memoryUsage[memoryUsage.length - 1].buffered)*100/memoryUsage[memoryUsage.length - 1].total;
				memUsage = memUsage.toFixed(2);
				document.getElementById('memFree').innerText = memUsage + ' %';

				diskUse = diskUsage.length ? diskUsage[diskUsage.length - 1].storageUsed * 100 / diskUsage[diskUsage.length - 1].storageSize : 0;
				diskUse = diskUse.toFixed(2);
				//console.log('diskUse : ', diskUse);
				document.getElementById('diskUse').innerText = diskUse + ' %';
				
				conUser = userConStatusList.length !== 0 ? userConStatusList[userConStatusList.length-1].avg_CON_CNT : 0;
// 				console.log('conUser : ', conUser);
				document.getElementById('conUser').innerText = conUser + ' 명';
				
				var monDateTime = cpuUsage[cpuUsage.length-1].monTime;
				
				if(document.getElementById('cpuInfoTabA').classList.contains('active')) {
					window.CPUChart.set(Math.round(cpuUse) == 0? 1 : Math.round(cpuUse));
					document.querySelector('span[id=cpuCaption]').innerText = '모니터링 시간: ' + getMonTime(cpuUsage[cpuUsage.length-1].monTime);
				}
				
				if(document.getElementById('memInfoTabA').classList.contains('active')) {
					//console.log(window.MemoryChart.data.datasets);
					window.MemoryChart.data.datasets.forEach((dataset) => {
						//console.log(dataset.data);
						if(memoryUsage[memoryUsage.length-1].total == 0){
							dataset.data = [0,0,0,0];
						}else{
							dataset.data = [
								Math.floor((memoryUsage[memoryUsage.length-1].total - (memoryUsage[memoryUsage.length-1].used + memoryUsage[memoryUsage.length-1].buffered + memoryUsage[memoryUsage.length-1].cached))/1024),
								Math.floor(memoryUsage[memoryUsage.length-1].used/1024),
								Math.floor(memoryUsage[memoryUsage.length-1].buffered/1024),
								Math.floor(memoryUsage[memoryUsage.length-1].cached/1024)
							];
						}
				    });
					document.querySelector('span[id=memCaption]').innerText = '모니터링 시간: ' + getMonTime(memoryUsage[memoryUsage.length-1].monTime);
				}

				window.DiskChart.data.datasets.forEach((dataset) => {
					//console.log(dataset.data);
					dataset.data = [
						diskUsage.length ? Math.floor(diskUsage[diskUsage.length-1].storageSize*4096/(1024*1024)*100)/100 : 0,
						diskUsage.length ? Math.floor((diskUsage[diskUsage.length-1].storageSize - diskUsage[diskUsage.length-1].storageUsed)*4096 / (1024 * 1024) *100) / 100 : 0
					];
			    });
				document.querySelector('span[id=diskCaption]').innerText = '모니터링 시간: ' + getMonTime(diskUsage.length ?  diskUsage[diskUsage.length-1].monTime : 0);

				if(document.getElementById('cpuHisTabA').classList.contains('active') || document.getElementById('memHisTabA').classList.contains('active')) {
					var labels;
					
					if(document.getElementById('cpuHisTabA').classList.contains('active')) {
						labels = window.CPUHisChart.data.labels;
					} else if(document.getElementById('memHisTabA').classList.contains('active')) {
						labels = window.MemoryChart.data.labels;
					}
					
					cpuUsage.forEach((data) => {
						if(document.getElementById('cpuHisTabA').classList.contains('active')) {
							window.CPUHisChart.data.labels.shift();
							window.CPUHisChart.data.datasets.forEach((dataset) => {
						        dataset.data.shift();
						    });
							window.CPUHisChart.data.labels.push(getMonTime2(new Date(data.monTime)));
							window.CPUHisChart.data.datasets.forEach((dataset) => {
						        dataset.data.push(data ? data.avg1Min.toFixed(2) : 0);
						    });
							
							window.CPUHisChart.update();
						}
					});
					
					memoryUsage.forEach((data) => {
						if(document.getElementById('memHisTabA').classList.contains('active')) {
							window.MemoryChart.data.labels.shift();
							window.MemoryChart.data.datasets.forEach((dataset) => {
						        dataset.data.shift();
						    });
							window.MemoryChart.data.labels.push(getMonTime2(new Date(data.monTime)));
							window.MemoryChart.data.datasets.forEach((dataset) => {
						        dataset.data.push(Math.floor(data.total == 0 ? 0 : (data.total - (data.used - data.cached - data.buffered)) / 1024 * 100 / 100));
						    });
							
							window.MemoryChart.update();
						}
					});
				}
				
				var labelsUser = window.userConStatusChart.data.labels;
				userConStatusList.forEach((data) => {
					if(labelsUser.includes(data.stats_DTTM.substr(11, 17))){
						;
					} else {
						window.userConStatusChart.data.labels.shift();
						window.userConStatusChart.data.datasets.forEach((dataset) => {
					        dataset.data.shift();
					    });
						
						window.userConStatusChart.data.labels.push(data.stats_DTTM.substr(11, 17));
						window.userConStatusChart.data.datasets.forEach((dataset) => {
					        dataset.data.push(data.avg_CON_CNT);
					    });
						
						window.userConStatusChart.update();
					}
				});
		        
				var colorCode = ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850", ];
		        var labels = new Array();
		        window.trafficChart.data.labels = new Object();
		        window.trafficChart.data.datasets = new Array();

		        
				for(var ii = 0; ii < results.nicInfo.length; ii ++) {
					var tmp = results[results.nicInfo[ii].if_Name];
 					for(var jj = 1; jj < tmp.length; jj ++) {
						if( labels.find(element => element === getMonTime2(tmp[jj].monTime)) == undefined) {
							labels.push(getMonTime2(tmp[jj].monTime));
							window.trafficChart.data.labels = labels;
						}
					}
				}

				for(var ii = 0; ii < results.nicInfo.length; ii ++) {
					var tmp = results[results.nicInfo[ii].if_Name];
					var traffic  = new Object();
					var trafficData = new Array();
					var bps = 0.0;
 					for(var jj = 1; jj < tmp.length; jj ++) {
						if( labels.find(element => element === getMonTime2(tmp[jj].monTime)) != undefined) {
							const diffMin = ((new Date(tmp[jj].monTime)).getTime() - ( new Date(tmp[jj-1].monTime)).getTime()) / (60 * 1000);
							if(diffMin == 1) {
								var change = tmp[jj].rx -  tmp[jj - 1].rx;
								if(change == 0 ) {
									bps = 0;
								} else {
									bps = change/60;
								}
							}
							trafficData.push(bps);
						}
					}
 					traffic.data = trafficData;
 					traffic.label = results.nicInfo[ii].if_Name;
 					traffic.borderColor = colorCode[ii];
 					traffic.fill = false;
 					window.trafficChart.data.datasets.push(traffic);
				}
				window.trafficChart.update();
        });
	}
	/* YYYY-MM-DD HH:mm:ss  */
	function getMonTime(monTime) {
		var MonTime = new Date(monTime);
		var year = MonTime.getFullYear();
		var month = ('0' + (MonTime.getMonth() + 1)).slice(-2);
		var day = ('0' + MonTime.getDate()).slice(-2);
		var hours = ('0' + MonTime.getHours()).slice(-2); 
		var minutes = ('0' + MonTime.getMinutes()).slice(-2);
		var seconds = ('0' + MonTime.getSeconds()).slice(-2); 
		MonTimeFormat = year + '-' + month  + '-' + day + ' ' + hours + ':' + minutes  + ':' + seconds;
		return MonTimeFormat;
	}
	
	/* HH:mm  */
	function getMonTime2(monTime) {
		var MonTime = new Date(monTime);
		var hours = ('0' + MonTime.getHours()).slice(-2); 
		var minutes = ('0' + MonTime.getMinutes()).slice(-2);
		MonTimeFormat = hours + ':' + minutes;
		return MonTimeFormat;
	}
	
	//cpu 정보 그래프
	function getCPUGraph() {
		let cpuUsage = 0;
		let url = '/vpn/cpu/chart.do';
		
		const graphCpuGraphButton = document.getElementById('cpuGraphButton');
		const graphCpuCaption = document.getElementById('cpuCaption');
		const graphPercentage = document.getElementById('percentage');
		const graphPreviewTextfield = document.getElementById('preview-textfield');
		const graphCpuAvgCaption = document.getElementById('cpuAvgCaption');
		const graphClockIconCpu = document.getElementById('clockIcon_cpu');
		
		if(graphCpuGraphButton) graphCpuGraphButton.style.display = 'none';
		if(graphCpuCaption) graphCpuCaption.style.display = ''
		if(graphPercentage) graphPercentage.style.display = '';
		if(graphPreviewTextfield) graphPreviewTextfield.style.display = '';
		if(graphCpuAvgCaption) graphCpuAvgCaption.style.display = '';
		document.getElementById('cpuInfoTabA').className = 'nav-link active';
		document.getElementById('cpuHisTabA').className = 'nav-link';
		if(graphClockIconCpu) graphClockIconCpu.style.display = ''
		
		$.ajax({
			url : url,
			type : 'GET', // GET or POST 방식
			success : function(data) {
				// 그래프로 나타낼 자료 리스트에 담기
				cpuUsage = data.length ? data[data.length - 1].avg1Min : 0;
				if (window.CPUHisChart != undefined) {
					window.CPUHisChart.destroy();
				}
				cpuUsage = Math.ceil(cpuUsage);
				
				// 그래프
				var opts = {
					 angle: 0.001, // 게이지의 각도
		  			//  lineWidth: 0.42, // 게이지의 굵기
		  			 lineWidth: 0.5, // 게이지의 굵기
		  			 pointer: {
		   				 length: 0.5, // 포인터 길이
		   				//  strokeWidth: 0.05, // The rotation offset
		   				 strokeWidth: 0.01, // The rotation offset
		    			//  color: '#000000' // 포인터 색
		  				},
		  				 renderTicks: {
		  				    // divisions: 10,
		  				    divisions: 5,
		  				    // divWidth: 1.1,
		  				    divWidth: 0.1,
		  				    // divLength: 0.7,
		  				    divLength: 0.1,
		  				    // divColor: '#333333',
		  				    divColor: '#666',
		  				    // subDivisions: 3,
		  				    // subLength: 0.5,
		  				    // subWidth: 0.6,
		  				    // subColor: '#666666'
		  				  },
		  				staticLabels: {
		  				  font: "10px sans-serif",  // Specifies font
		  				//   labels: [0, 20, 40, 60, 80, 100],  // Print labels at these values
		  				  labels: [],  // Print labels at these values
		  				//   color: "#000000",  // Optional: Label text color
		  				},
		  				staticZones: [
		  				//    {strokeStyle: "rgba(41, 144, 255, 0.85)", min: 0, max: 25}, 
		  				//    {strokeStyle: "rgba(81, 209, 17, 0.85)", min: 25, max: 50}, // green
		  				//    {strokeStyle: "rgba(252, 176, 0, 0.85)", min: 50, max: 70}, // yellow
		  				//    {strokeStyle: "rgba(242, 75, 41, 0.85)", min: 70, max: 100} // Red
							{strokeStyle: "rgba(128, 164, 248, 0.1)", min: 0, max: 10}, 
							{strokeStyle: "rgba(128, 164, 248, 0.2)", min: 10, max: 20}, 
							{strokeStyle: "rgba(128, 164, 248, 0.3)", min: 20, max: 30}, 
							{strokeStyle: "rgba(128, 164, 248, 0.4)", min: 30, max: 40}, 
							{strokeStyle: "rgba(128, 164, 248, 0.5)", min: 40, max: 50}, 
							{strokeStyle: "rgba(128, 164, 248, 0.6)", min: 50, max: 60}, 
		  					{strokeStyle: "rgba(128, 164, 248, 0.7)", min: 60, max: 70}, 
		  					{strokeStyle: "rgba(128, 164, 248, 0.8)", min: 70, max: 80}, 
		  					{strokeStyle: "rgba(128, 164, 248, 0.9)", min: 80, max: 90}, 
		  					{strokeStyle: "rgba(128, 164, 248, 1)", min: 90, max: 100}
		  				],
		  				
		  				generateGradient: true,
		  			    highDpiSupport: true,    
		  				limitMax: 'true',   // If true, the pointer will not go past the end of the gauge
		 				colorStart: '#6FADCF',   // 시작 색
		  				colorStop: '#668cff',    // 끝날때의 색
		  				strokeColor: '#E0E0E0',   // to see which ones work best for you
					};
				var target = document.getElementById("cpuChart"); 
				window.CPUChart = new Gauge(target).setOptions(opts);
				window.document.getElementById("preview-textfield").className = "preview-textfield";
				window.CPUChart.setTextField(document.getElementById("preview-textfield"));
				window.CPUChart.maxValue = 100; // set max gauge value
				window.CPUChart.animationSpeed = 22; // set animation speed (32 is default value)
				window.CPUChart.set(cpuUsage); // set actual value
				//console.log("AVG: " + cpuUsage);
				document.querySelector('span[id=cpuCaption]').innerText = '모니터링 시간: ' + getMonTime(data[data.length - 1].monTime);
			}
		});
	}
	
	//CPU 히스토리 그래프 (area-line)
	function getCPUHisGraph() {
		let url = '/vpn/cpu/chart.do';
		const hisGraphCpuGraphButton = document.getElementById('cpuGraphButton');
		const hisGraphCpuCaption = document.getElementById('cpuCaption');
		const hisGraphPreviewTextfield = document.getElementById('preview-textfield');
		const hisGraphPercentage = document.getElementById('percentage');
		const hisGraphCpuAvgCaption = document.getElementById('cpuAvgCaption');
		const hisGraphClockIconCpu = document.getElementById('clockIcon_cpu');
		
		if(hisGraphCpuGraphButton) hisGraphCpuGraphButton.style.display = 'none';
		if(hisGraphCpuCaption) hisGraphCpuCaption.style.display = 'none';
		if(hisGraphPreviewTextfield) hisGraphPreviewTextfield.style.display = 'none';
		if(hisGraphPercentage) hisGraphPercentage.style.display = 'none';
		if(hisGraphCpuAvgCaption) hisGraphCpuAvgCaption.style.display = 'none';
		document.getElementById('cpuHisTabA').className = 'nav-link active';
		if(hisGraphClockIconCpu) hisGraphClockIconCpu.style.display = 'none';
		document.getElementById('cpuInfoTabA').className = 'nav-link';
		
		$.ajax({
			url : url,
			type : 'GET', // GET or POST 방식
			success : function(data) {
				if (window.CPUHisChart != undefined) {
					window.CPUHisChart.destroy();
				}

				//그래프
				var ctx = document.getElementById("cpuChart");
				window.CPUHisChart = new Chart(
						ctx,
						{
							type : 'line',
							data : {
								labels : data.map(row => getMonTime2(new Date(row.monTime))),
								datasets : [ {
									label : "사용률",
									lineTension : 0.3,
									backgroundColor : "rgba(78, 115, 223, 0.05)",
									// borderColor : "#0875cf",
									borderColor : "#80A4F8",
									pointRadius : 1,
									// pointBackgroundColor : "rgba(78, 115, 223, 1)",
									// pointBorderColor : "rgba(78, 115, 223, 1)",
									pointHoverRadius : 3,
									// pointHoverBackgroundColor : "#3aa5fc",
									pointHoverBackgroundColor : "#4E73DF",
									// pointHoverBorderColor : "#3aa5fc",
									pointHoverBorderColor : "#4E73DF",
									pointHitRadius : 10,
									pointBorderWidth : 2,
									data : data.map(row => row ? (row.avg1Min).toFixed(2) : 0)
								} ],
							},
							options : {
								maintainAspectRatio : false,
								title : {
									display : true,
									text : 'CPU 히스토리 (' + getMonTime(data[0].monTime) + ')',
									// fontSize : 16,
									// fontColor : 'rgba(46, 49, 49, 1)'
								},
								layout : {
									padding : {
										// left : 10,
										// right : 10,
										top : 0,
										bottom : 0
									}
								},
								scales : {
									xAxes : [ {
										time : {
											unit : 'date'
										},
										gridLines : {
											display : false,
											drawBorder : false
										},
										ticks : {
											maxTicksLimit : 15,
										}
									} ],
									yAxes : [ {
										ticks : {
											maxTicksLimit : 7,
											max:50,
											// padding : 5,
											padding : 10,
											// Include a dollar sign in the ticks
											callback : function(value,
													index, values) {
												return value + ' %';
											}
										},
										gridLines : {
											color : "rgb(234, 236, 244)",
											zeroLineColor : "rgb(234, 236, 244)",
											drawBorder : false,
											borderDash : [ 3 ],
											zeroLineBorderDash : [ 2 ]
										}
									} ],
								},
								legend : {
									display : false
								},
								tooltips : {
									backgroundColor : "rgb(255,255,255)",
									// bodyFontColor : "#858796",
									bodyFontColor : "#888",
									titleMarginBottom : 10,
									// titleFontColor : '#6e707e',
									titleFontColor : '#888',
									titleFontSize : 14,
									// borderColor : '#dddfeb',
									borderColor : '#eee',
									borderWidth : 1,
									xPadding : 15,
									yPadding : 15,
									displayColors : false,
									intersect : false,
									mode : 'index',
									caretPadding : 10,
									callbacks : {
										label : function(tooltipItem,
												chart) {
											var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label
													|| '';
											return datasetLabel
													+ ': '
													+ tooltipItem.yLabel
													+ ' %';
										}
									}
								}
							}
						});
			}
		});
	}

	// Memory Info Graph (doughnut)
	function getMemGraph() {
		let url = '/vpn/memory/chart.do';
		
		const memGraphCpuGraphButton = document.getElementById('cpuGraphButton');
		const memGraphMemCaption = document.getElementById('memCaption');
		const memGraphClockIconMem = document.getElementById('clockIcon_mem');
		//const memGraphMemmemTabA = document.getElementById('memmemTabA');
	
		if(memGraphCpuGraphButton) memGraphCpuGraphButton.style.display = 'none';
		if(memGraphMemCaption) memGraphMemCaption.style.display = '';
		//if(memGraphMemmemTabA) memGraphMemmemTabA.className = 'nav-link';
		document.getElementById('memHisTabA').className = 'nav-link';
		if(memGraphClockIconMem) memGraphClockIconMem.style.display = '';
		document.getElementById('memInfoTabA').className = 'nav-link active';
		
		$.ajax({
			url : url,
			type : 'GET', // GET or POST 방식
			success : function(data) {
				// 그래프
				if (window.MemoryChart != undefined) {
					window.MemoryChart.destroy();
				}
				window.MemoryChart = new Chart(
						document.getElementById("memoryChart"),
						{
							type : 'doughnut',
							data : {
// 								labels : [ "Remaining", "Used", "Buffered", "Cached" ],
								labels : [ "사용 가능", "사용중", "버퍼", "캐시" ],
								datasets : [ {
									data : [
										data[data.length-1].total == 0 ? 0 : Math.floor((data[data.length-1].total - (data[data.length-1].used + data[data.length-1].buffered + data[data.length-1].cached))/1024),
										data[data.length-1].total == 0 ? 0 : Math.floor(data[data.length-1].used/1024),
										data[data.length-1].total == 0 ? 0 : Math.floor(data[data.length-1].buffered/1024),
										data[data.length-1].total == 0 ? 0 : Math.floor(data[data.length-1].cached/1024)
									],
									// backgroundColor : [ '#3cbd00', '#595c5a'],
									backgroundColor : [ '#D196F9', '#888', '#293623', "#FFACB7", "#de3163", "#ffff99"],
									// hoverBackgroundColor : [ '#48e300','#293623'],
									hoverBackgroundColor : [ '#D196F9','#888','#293623', "#FFACB7", "#de3163", "#ffff99"],
									// hoverBorderColor : "#48e300",
									hoverBorderColor : "#D196F9",
								} ]
							},
							options : {
								title : {
									display : true,
									text : '메모리 정보',
									// fontSize : 16,
									fontSize : 14,
									fontColor : '#888'
								},
								maintainAspectRatio : false,
								tooltips : {
									backgroundColor : "rgb(255,255,255)",
									// bodyFontColor : "#858796",
									bodyFontColor : "#888",
									// borderColor : '#dddfeb',
									borderColor : '#eee',
									borderWidth : 1,
									xPadding : 15,
									yPadding : 15,
									displayColors : false,
									// caretPadding : 10,
									caretPadding : 20,
								},
								cutoutPercentage : 70,
								// cutoutPercentage : 50,
								responsive : false,
								layout: {
									padding: {
										// top: 20
									}
								},
							},
						}); //그래프
			},
			error : function() {
				alert("그래프 로딩 실패");
			}
		});
	}

	//Memory 히스토리 그래프 (area-line)
	function getMemoryHisGraph() {
		let url = '/vpn/memory/chart.do';
		
		const memHisGraphCpuGraphButton = document.getElementById('cpuGraphButton');
		const memHisGraphMemCaption = document.getElementById('memCaption');
		const memHisGraphClockIconMem = document.getElementById('clockIcon_mem');
		
		if(memHisGraphCpuGraphButton) memHisGraphCpuGraphButton.style.display = 'none';
		if(memHisGraphMemCaption) memHisGraphMemCaption.style.display = 'none';
		document.getElementById('memHisTabA').className = 'nav-link active';
		if(memHisGraphClockIconMem) memHisGraphClockIconMem.style.display = 'none';
		document.getElementById('memInfoTabA').className = 'nav-link';
		
		$.ajax({
			url : url,
			type : 'GET', // GET or POST 방식
			success : function(data) {
				
				if (window.MemoryChart != undefined) {
					window.MemoryChart.destroy();
				}
				//그래프
				var ctx = document.getElementById("memoryChart");
				window.MemoryChart = new Chart(
						ctx,
						{
							type : 'line',
							data : {
								labels : data.map(row => getMonTime2(new Date(row.monTime))),
								datasets : [ {
									label : "사용률",
									lineTension : 0.3,
									// backgroundColor : "rgba(50, 99, 35, 0.06)",
									backgroundColor : "rgba(0, 0, 0, 0.05)",
									// borderColor : "#11660f",
									borderColor : "#D196F9",
									pointRadius : 1,
									// pointBackgroundColor : "#205210",
									pointBackgroundColor : "#94E1C2",
									// pointBorderColor : "#205210",
									pointBorderColor : "#D196F9",
									pointHoverRadius : 2,
									// pointHoverBackgroundColor : "#2fb806",
									pointHoverBackgroundColor : "#5DA689",
									// pointHoverBorderColor : "#2fb806",
									pointHoverBorderColor : "#5DA689",
									pointHitRadius : 10,
									pointBorderWidth : 2,
									data : data.map(row => Math.floor(row.total == 0 ? 0 : (row.total - (row.used - row.cached - row.buffered)) / 1024 * 100 / 100)),
								} ],
							},
							options : {
								maintainAspectRatio : false,
								title : {
									display : true,
									text : '메모리 사용률 히스토리 (' + getMonTime(new Date(data[data.length - 1].monTime))
											+ ')',
									// fontSize : 16,
									fontSize : 14,
									// fontColor : 'rgba(46, 49, 49, 1)'
									fontColor : '#888'
								},

								layout : {
									padding : {
										left : 10,
										right : 10,
										// top : 0,
										top : 10,
										// bottom : 0
										bottom : 10
									}
								},
								scales : {
									xAxes : [ {
										time : {
											unit : 'date'
										},
										gridLines : {
											display : true,
											drawBorder : true
										},
										ticks : {
											maxTicksLimit : 15
										}
									} ],
									yAxes : [ {
										ticks : {
											maxTicksLimit : 10,
											padding : 10,
											// Include a dollar sign in the ticks
											callback : function(value,
													index, values) {
												return value + ' MB';
											}
										},
										gridLines : {
											color : "rgb(234, 236, 244)",
											zeroLineColor : "rgb(234, 236, 244)",
											drawBorder : false,
											borderDash : [ 2 ],
											zeroLineBorderDash : [ 2 ]
										}
									} ],
								},
								legend : {
									display : false
								},
								tooltips : {
									backgroundColor : "rgb(255,255,255)",
									// bodyFontColor : "#858796",
									bodyFontColor : "#888",
									// titleMarginBottom : 40,
									titleMarginBottom : 20,
									// titleFontColor : '#6e707e',
									titleFontColor : '#888',
									titleFontSize : 14,
									// borderColor : '#dddfeb',
									borderColor : '#eee',
									borderWidth : 1,
									xPadding : 15,
									yPadding : 15,
									displayColors : false,
									intersect : false,
									mode : 'index',
									caretPadding : 10,
									callbacks : {
										label : function(tooltipItem,
												chart) {
											var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label
													|| '';
											return datasetLabel
													+ ': '
													+ tooltipItem.yLabel
													+ ' MB';
										}
									}
								}
							}
						});
			}
		});
	}

	//디스크 그래프
	function getDiskGraph() {
		let url = '/vpn/disk/chart.do';
		
		const diskGraphCpuGraphButton = document.getElementById('cpuGraphButton');
		const diskGraphMemCaption = document.getElementById('memCaption');

		if(diskGraphCpuGraphButton) diskGraphCpuGraphButton.style.display = 'none';
		if(diskGraphMemCaption) diskGraphMemCaption.style.display = '';
		document.getElementById('memHisTabA').className = 'nav-link';
		document.getElementById('memInfoTabA').className = 'nav-link active';
		
		$.ajax({
			url : url,
			type : 'GET', // GET or POST 방식
			success : function(data) {
				// 그래프로 나타낼 자료 리스트에 담기
				window.DiskChart = new Chart(
						document.getElementById("diskChart"),
						{
							type : 'doughnut',
							data : {
								labels : [ "사용 가능", "사용 중" ],
								datasets : [ {
									data : [
										data.length ? Math.floor((data[data.length-1].storageSize - data[data.length-1].storageUsed) * 4096 / (1024 * 1024)) : 0,
										data.length ? Math.floor(data[data.length-1].storageUsed * 4096 / (1024 * 1024)) : 0
									],
									// backgroundColor : [ '#1bc2f5', '#595c5a'],
									backgroundColor : [ '#79DAB3', '#888'],
									// hoverBackgroundColor : [ '#6eddff', '#293623'],
									hoverBackgroundColor : [ '#79DAB3', '#888'],
									// hoverBorderColor : "rgba(110, 221, 255, 1)",
									hoverBorderColor : "#79DAB3",
								} ]
							},
							options : {
								title : {
									display : true,
									text : '디스크 정보',
									fontSize : 14,
									// fontColor : 'rgba(46, 49, 49, 1)'
									fontColor : '#888',
								},
								maintainAspectRatio : false,
								tooltips : {
									backgroundColor : "rgb(255,255,255)",
									bodyFontColor : "#858796",
									borderColor : '#dddfeb',
									borderWidth : 1,
									xPadding : 15,
									yPadding : 15,
									displayColors : false,
									caretPadding : 10,
								},
								cutoutPercentage : 70,
								layout: {
									padding: {
										// top: 20
									}
								},
							},
							responsive : false
						}); //그래프
			},
			error : function() {
				alert("그래프 로딩 실패");
			}
		});
	}
	
	//사용자 접속 현황 그래프
	function getUserConStatus() {
		var monDate = "";
		let url = '/vpn/status/chart.do';
		
		$.ajax({
			url : url,
			type : 'GET', // GET or POST 방식
			success : function(data) {
				
				//그래프
				var ctx = document.getElementById("myAreaChart");
				window.userConStatusChart = new Chart(
						ctx,
						{
							type : 'line',
							data : {
								labels : data.map(row => row.stats_DTTM.substr(11, 17)),
								datasets : [
									{
										label : "접속 사용자 수",
										lineTension : 0.3,
										backgroundColor : "rgba(30, 151, 232, 0.125)",
										// borderColor : "#1e97e8",
										borderColor : "#F6C23E",
										pointRadius : 2,
										// pointBackgroundColor : "#027dcf",
										pointBackgroundColor : "#F6C23E",
										// pointBorderColor : "#027dcf",
										pointBorderColor : "#F6C23E",
										pointHoverRadius : 5,
										// pointHoverBackgroundColor : "#4ab2f7",
										pointHoverBackgroundColor : "#C29930",
										// pointHoverBorderColor : "#4ab2f7",
										pointHoverBorderColor : "#C29930",
										pointHitRadius : 10,
										pointBorderWidth : 2,
										data : data.map(row => row.avg_CON_CNT),
									}
								],
							},
							options : {
								maintainAspectRatio : false,
								title : {
									display : true,
									text : '사용자 접속 추이',
									// fontSize : 17,
									fontSize : 14,
									// fontColor : 'rgba(46, 49, 49, 1)'
									fontColor : '#888'
								},
								layout : {
									padding : {
										left : 10,
										right : 25,
										top : 25,
										bottom : 0
									}
								},

								scales : {
									xAxes : [ {
										time : {
											unit : 'date'
										},
										gridLines : {
											display : false,
											drawBorder : false
										},
										ticks : {
											maxTicksLimit : 150
										}
									} ],
									yAxes : [ {
										ticks : {
											beginAtZero: true,
											suggestedMax: 10,
											steps:5,
											// Include a dollar sign in the ticks
											callback : function(value,
													index, values) {
												return number_format(value)
														+ ' 명';
											}
										},
										gridLines : {
											color : "rgb(234, 236, 244)",
											zeroLineColor : "rgb(234, 236, 244)",
											drawBorder : false,
											borderDash : [ 2 ],
											zeroLineBorderDash : [ 2 ]
										}
									} ],
								},
								legend : {
									display : false
								},
								tooltips : {
									backgroundColor : "rgb(255,255,255)",
									// bodyFontColor : "#858796",
									bodyFontColor : "#888",
									titleMarginBottom : 10,
									// titleFontColor : '#6e707e',
									titleFontColor : '#888',
									titleFontSize : 14,
									// borderColor : '#dddfeb',
									borderColor : '#eee',
									borderWidth : 1,
									xPadding : 15,
									yPadding : 15,
									displayColors : false,
									intersect : false,
									mode : 'index',
									caretPadding : 10,
									callbacks : {
										label : function(tooltipItem,
												chart) {
											var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label
													|| '';
											return datasetLabel
													+ ': '
													+ number_format(tooltipItem.yLabel)
													+ ' 명';
										}
									}
								}
							}
						});
					}
				});
		window.scroll(0,0);
	}
	
	function getVPNTraffic() {
		var monDate = "";
		let url = '/vpn/traffic/chart.do';
		var colorCode = ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850", ];
		
		$.ajax({
			url : url,
			type : 'GET', // GET or POST 방식
			success : function(data) {
				
				var labels = new Array();

				var ctx = document.getElementById("trafficChart");
				window.trafficChart = new Chart(
						ctx,
						{
							type : 'line',
							data : {
								labels : data.nicInfo.map(row => row.if_Name),
								datasets : [
									{
										label : "데이터 전송 속도",
										lineTension : 0.3,
										backgroundColor : "rgba(30, 151, 232, 0.125)",
										borderColor : "#75CFDC",
										pointRadius : 2,
										pointBackgroundColor : "#75CFDC",
										pointBorderColor : "#75CFDC",
										pointHoverRadius : 5,
										pointHoverBackgroundColor : "#C29930",
										pointHoverBorderColor : "#C29930",
										pointHitRadius : 10,
										pointBorderWidth : 2,
										data : data.nicInfo.map(row => row.if_Name),
									}
								],
							},
							options : {
								maintainAspectRatio : false,
								title : {
									display : true,
									text : 'VPN Network Traffic(Bps)',
									fontSize : 14,
									fontColor : '#888'
								},
								layout : {
									padding : {
										left : 10,
										right : 25,
										top : 25,
										bottom : 0
									}
								},

								scales : {
									xAxes : [ {
										time : {
											unit : 'date'
										},
										gridLines : {
											display : false,
											drawBorder : false
										},
										ticks : {
											maxTicksLimit : 150
										}
									} ],
									yAxes : [ {
										ticks : {
											beginAtZero: true,
											suggestedMax: 100000,
											steps:10,
											// Include a dollar sign in the ticks
											callback : function(value,
													index, values) {
												return number_format(value)
														+ ' Bps';
											}
										},
										gridLines : {
											color : "rgb(234, 236, 244)",
											zeroLineColor : "rgb(234, 236, 244)",
											drawBorder : false,
											borderDash : [ 2 ],
											zeroLineBorderDash : [ 2 ]
										}
									} ],
								},
								legend : {
									display : false
								},
								tooltips : {
									backgroundColor : "rgb(255,255,255)",
									bodyFontColor : "#888",
									titleMarginBottom : 10,
									titleFontColor : '#888',
									titleFontSize : 14,
									borderColor : '#eee',
									borderWidth : 1,
									xPadding : 15,
									yPadding : 15,
									displayColors : false,
									intersect : false,
									mode : 'index',
									caretPadding : 10,
									callbacks : {
										label : function(tooltipItem,
												chart) {
											var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label
													|| '';
											return datasetLabel
													+ ': '
													+ number_format(tooltipItem.yLabel)
													+ ' Bps';
										}
									}
								}
							}
				});
				
				
				for(var ii = 0; ii < data.nicInfo.length; ii ++) {
					var tmp = data[data.nicInfo[ii].if_Name];
 					for(var jj = 1; jj < tmp.length; jj ++) {
						if( labels.find(element => element === getMonTime2(tmp[jj].monTime)) == undefined) {
							labels.push(getMonTime2(tmp[jj].monTime));
							window.trafficChart.data.labels = labels;
						}
					}
				}
				
				for(var ii = 0; ii < data.nicInfo.length; ii ++) {
					var tmp = data[data.nicInfo[ii].if_Name];
					var traffic  = new Object();
					var trafficData = new Array();
					var bps = 0.0;
 					for(var jj = 1; jj < tmp.length; jj ++) {
						if( labels.find(element => element === getMonTime2(tmp[jj].monTime)) != undefined) {
							const diffMin = ((new Date(tmp[jj].monTime)).getTime() - ( new Date(tmp[jj-1].monTime)).getTime()) / (60 * 1000);
							if(diffMin == 1) {
								var change = tmp[jj].rx -  tmp[jj - 1].rx;
								if(change == 0 ) {
									bps = 0;
								} else {
									bps = change/60;
								}
							}
							trafficData.push(bps);
						}
					}
 					traffic.data = trafficData;
 					traffic.label = data.nicInfo[ii].if_Name;
 					traffic.borderColor = colorCode[ii];
 					traffic.fill = false;
 					
 					window.trafficChart.data.datasets.push(traffic);
				}
				
				window.trafficChart.update();
			}
		});
		window.scroll(0,0);
	}
	
</script>
