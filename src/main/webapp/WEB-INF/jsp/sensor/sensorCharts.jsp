<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- Resources -->
<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>

<script type="text/javascript">

	am4core.ready(function() {
		
	    // Themes begin
	    am4core.useTheme(am4themes_animated);
	    // Themes end

	    // Create chart instance
	    var chart = am4core.create("chart-area", am4charts.XYChart);

	    
		<c:forEach var="report" items="${sensorReport}" varStatus="status">
			var item${status.index} = new Object();
			item${status.index}.time = "${report.time}";
			item${status.index}.aiv = ${report.aiv}.toFixed(3);
			item${status.index}.value = ${report.value}.toFixed(3);
			chart.data.push(item${status.index});
		</c:forEach>
		
 		$("#date_time_start").val(chart.data[chart.data.length-1].time);
		$("#date_time_end").val(chart.data[0].time);

	    // Set input format for the dates
	    chart.dateFormatter.inputDateFormat = "yyyy-MM-dd HH";

	    // Create axes
	    var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
	    var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());

	    
	    dateAxis.periodChangeDateFormats.setKey("minute", "MMM dd\nHH:mm");

	    
	    dateAxis.tooltipDateFormat = "yyyy-MM-dd HH:00";

	    // Create series
	    var series = chart.series.push(new am4charts.LineSeries());
	    series.dataFields.valueY = "value";
	    series.dataFields.dateX = "time";
	    series.tooltipText = "{value}"
	    series.strokeWidth = 2;
	    series.minBulletDistance = 15;

	    // Drop-shaped tooltips
	    series.tooltip.background.cornerRadius = 20;
	    series.tooltip.background.strokeOpacity = 0;
	    series.tooltip.pointerOrientation = "vertical";
	    series.tooltip.label.minWidth = 40;
	    series.tooltip.label.minHeight = 40;
	    series.tooltip.label.textAlign = "middle";
	    series.tooltip.label.textValign = "middle";

	    // Make bullets grow on hover
	    var bullet = series.bullets.push(new am4charts.CircleBullet());
	    bullet.circle.strokeWidth = 2;
	    bullet.circle.radius = 4;
	    bullet.circle.fill = am4core.color("#fff");

	    var bullethover = bullet.states.create("hover");
	    bullethover.properties.scale = 1.3;

	    // Make a panning cursor
	    chart.cursor = new am4charts.XYCursor();
	    chart.cursor.behavior = "panXY";
	    chart.cursor.xAxis = dateAxis;
	    chart.cursor.snapToSeries = series;

	    chart.logo.disabled = true;
	    dateAxis.keepSelection = true;

	    // 타겟 라인 추가 함수
	    function addTargetLine(value, color) {
	        var range = valueAxis.axisRanges.create();
	        range.value = value;
	        range.grid.stroke = am4core.color(color);
	        range.grid.strokeWidth = 2;
	        range.grid.strokeOpacity = 1;
	        range.label.inside = true;
	        range.label.text = "Target: " + value;
	        range.label.fill = range.grid.stroke;
	    }

	    // 타겟 라인 추가 (세 개)
	    addTargetLine(55, "#FF0000"); // 빨간색 라인
	    addTargetLine(60, "#00FF00"); // 초록색 라인
	    addTargetLine(65, "#0000FF"); // 파란색 라인


	}); // end am4core.ready()

	function changeTab(tabID) {
		console.log("tabID", tabID, tabID.getAttribute('id'));
		
		var tabid = tabID.getAttribute('id');
		
		if(tabid == 'chartTab') {
			$("#tab1").prop("hidden", false);
			$("#tab2").prop("hidden", true);
			$("#tab3").prop("hidden", true);
		} else if(tabid == 'dataTab') {
			$("#tab1").prop("hidden", true);
			$("#tab2").prop("hidden", false);
			$("#tab3").prop("hidden", true);
		} else {
			$("#tab1").prop("hidden", true);
			$("#tab2").prop("hidden", true);
			$("#tab3").prop("hidden", false);
		}
/* 		
		console.log(document.querySelector('#tab1'));
		console.log(document.querySelector('#tab2'));
		console.log(document.querySelector('#tab3')); */
	}
</script>
