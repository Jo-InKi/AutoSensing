<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- Resources -->
<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
<script src="/assets/js/fonts.js"></script>

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
		
		console.log(chart.data.length);
		
		if(chart.data.length == 0) {
			var date_time_start = new Date(); 
			var date_time_end = new Date();
			console.log(date_time_start);
			console.log(date_time_start.getTimezoneOffset()/60);
			console.log(Intl.DateTimeFormat().resolvedOptions().timeZone)
			date_time_end.setHours(date_time_start.getHours() + 9);
			date_time_start.setHours(date_time_start.getHours() + 9);
			date_time_start.setDate(date_time_start.getDate() - 10);
			console.log(date_time_start.toISOString().replace("T", " ").substring(0, 14)+'00');
			console.log(date_time_end.toISOString().replace("T", " ").substring(0, 14)+'00');

	 		$("#date_time_start").val(date_time_start.toISOString().replace("T", " ").substring(0, 14)+'00');
			$("#date_time_end").val(date_time_end.toISOString().replace("T", " ").substring(0, 14)+'00');
		} else {
	 		$("#date_time_end").val(chart.data[chart.data.length-1].time);
			$("#date_time_start").val(chart.data[0].time);
		}
		
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
	
	function downloadExcel() {
		console.log('${sensor.sensorid}', '${sensor.channel}', '${sensor.sensorname}');
	    date_time_start = $('#date_time_start').val()
	    date_time_end = $('#date_time_end').val()
	    console.log(date_time_start, date_time_end);
	    
	    location.href = '/sensor/excel/download?sensorid=' + '${sensor.sensorid}' + '&channel=' + '${sensor.channel}';
	}
	
    /**
     * @ 전역 변수 
     */

    //고정 값
    const MARGIN_SIZE = 10;		//상하좌우 여백
    const LINE_HEIGHT = 3;		//행 너비 비율

    const IMG_SIZE_X = 5;
    const IMG_SIZE_Y = 5;

    //변동 값
    let FONT_SIZE = 10;		//폰트 크기
    let Y_LOC = MARGIN_SIZE;	//다음 행 시작 Y좌표(자동 계산 위함)

    const CELL_HEIGHT = 11.641666666666664;	//기본 셀 높이

    // Function to create the chart in an offscreen container
    function createChart() {
        // Create an offscreen div element to hold the chart
        var hiddenDiv = document.createElement("div");
        hiddenDiv.style.width = "1000px"; // Set your desired width
        hiddenDiv.style.height = "600px"; // Set your desired height
        hiddenDiv.style.position = "absolute";
        hiddenDiv.style.top = "-9999px";
        document.body.appendChild(hiddenDiv);

        // Create chart instance
        var chart = am4core.create(hiddenDiv, am4charts.XYChart);

        // Add data
        chart.data = [{
            "category": "One",
            "value": 120
        }, {
            "category": "Two",
            "value": 180
        }, {
            "category": "Three",
            "value": 100
        }];

        // Create axes
        var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
        categoryAxis.dataFields.category = "category";

        var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());

        // Create series
        var series = chart.series.push(new am4charts.ColumnSeries());
        series.dataFields.valueY = "value";
        series.dataFields.categoryX = "category";

        return chart;
    }

    function saveChartAsPDF() {
        var chart = createChart();

        // Export to image and then create PDF
        chart.exporting.getImage("png").then(function(imgData) {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF('p', 'mm', 'a4');
        const PAGE_HEIGHT = doc.internal.pageSize.height || doc.internal.pageSize.getHeight();
        const PAGE_WIDTH = doc.internal.pageSize.width || doc.internal.pageSize.getWidth();

        console.log(PAGE_WIDTH, PAGE_HEIGHT);

        doc.addFileToVFS('malgun.ttf', _fonts);
        doc.addFont('malgun.ttf', 'malgun', 'normal')
        doc.setFont('malgun')

        Y_LOC += MARGIN_SIZE;

        doc.setLineWidth(0.5); 
        doc.line(MARGIN_SIZE, Y_LOC, PAGE_WIDTH - (MARGIN_SIZE * 2) , Y_LOC);
        Y_LOC += 10.0;
        addText(doc, '센서명', {fontSize:30, align:'center', x:MARGIN_SIZE, y:Y_LOC});
        doc.line(MARGIN_SIZE, Y_LOC, PAGE_WIDTH - (MARGIN_SIZE * 2) , Y_LOC);
        Y_LOC += 10.0;
        addText(doc, '관리번호 : ', {fontSize:FONT_SIZE, align:'left', x:MARGIN_SIZE, y:Y_LOC});
        addText(doc, '현장명   : ', {fontSize:FONT_SIZE, align:'left', x:MARGIN_SIZE, y:Y_LOC});
        addText(doc, '설치위치 : ', {fontSize:FONT_SIZE, align:'left', x:MARGIN_SIZE, y:Y_LOC});
        addText(doc, '설치일자 : ', {fontSize:FONT_SIZE, align:'left', x:MARGIN_SIZE, y:Y_LOC});
        
        Y_LOC += 10.0;
        addText(doc, '차트', {fontSize:20, align:'left', x:MARGIN_SIZE, y:Y_LOC});

        // Add the chart image to the PDF
        doc.addImage(imgData, 'PNG', MARGIN_SIZE, Y_LOC, 190, 100);
        Y_LOC += 120;

        addText(doc, '데이터', {fontSize:20, align:'left', x:MARGIN_SIZE, y:Y_LOC});
        const head = [
            [
                {content: '측정일시', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '즉정치', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '변화량(MM)', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ]
        ];

        const body = [
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
            [
                {content: '데이터1', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터2', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}},
                {content: '데이터3', styles: {halign: 'center', lineColor: [0, 0, 0], lineWidth: 0.3}}
            ],
        ];
        addTable(doc, head, body, {width:0, align:'center', x:MARGIN_SIZE, y:Y_LOC});


        const addFooters = (doc) => {
            // 페이지 전체 높이
            const PAGE_HEIGHT = doc.internal.pageSize.height || doc.internal.pageSize.getHeight();
            // 페이지 전체 너비
            const PAGE_WIDTH = doc.internal.pageSize.width || doc.internal.pageSize.getWidth();
                
            const pageCount = doc.internal.getNumberOfPages();

            doc.setFontSize(10);
                
            for (var i = 1; i <= pageCount; i++) {
                doc.setPage(i);
                doc.text(`- ${i} -`, PAGE_WIDTH / 2, PAGE_HEIGHT - MARGIN_SIZE, {
                    align: 'center'
                });
            }
        };

        addFooters(doc);

        // Save the PDF
        //doc.save("SensorReport.pdf");

        // Open the New Window
        //doc.output("bloburl");
        window.open(doc.output("bloburl"), '_blank');

        // Cleanup: Dispose the chart and remove the hidden div
        chart.dispose();
        });
    }
    
    //text 추가 메소드
    function addText(doc, text, {fontSize = FONT_SIZE, align = 'left', x = MARGIN_SIZE, y = Y_LOC}) {
        //fontSize, align, x, y값은 지정하지 않을 시 기본 값으로 적용
        //add 메소드를 쓰는 방식 예1 (기본) : add(doc, '테스트', {});
        //add 메소드를 쓰는 방식 예2 (파라미터 추가) : add(doc, '테스트', {align: 'center'});
        
        if(align != 'left'){
            const PAGE_HEIGHT = doc.internal.pageSize.height || doc.internal.pageSize.getHeight();
            const PAGE_WIDTH = doc.internal.pageSize.width || doc.internal.pageSize.getWidth();
            
            //가운데 정렬 시, 기준점을 가로 중간으로
            if(align == 'center') x = PAGE_WIDTH / 2;
            //오른쪽 정렬 시,
            //가로 길이에서 좌우 여백값을 뺀 값이 되어야할 줄 알았지만,
            //아래의 계산 값이 결과가 일치하였음
            if(align == 'right') x = PAGE_WIDTH - (MARGIN_SIZE / 1.5);
        }

        doc.setFontSize(fontSize);

        //doc 에 텍스트를 추가
        doc.text(text, x, y, align);

        Y_LOC = y;  //텍스트가 입력된 y좌표를 저장
        if(fontSize != null) {
            Y_LOC += (LINE_HEIGHT + (fontSize / 100 * 1.2941) + (LINE_HEIGHT * 1.5)); 
        } else {
            Y_LOC += (LINE_HEIGHT + (FONT_SIZE / 100 * 1.2941) + (LINE_HEIGHT * 1.5)); 
        }
        //변경된 y좌표에 폰트와 줄 높이를 추가하여 저장
        //(생각했던 계산 값이 정확하지 않아 끼워맞추기 식으로 다시 구현한 식이므로 필요에 따라 변경)
        //1.2941은 기본 폰트 세로 사이즈 비율로 구글링을 통해 알게된 값을 임의 사용
    }

    function addTable(doc, head, body, {width = 0, align = 'center', x = MARGIN_SIZE, y = Y_LOC}) {
        const PAGE_WIDTH = doc.internal.pageSize.width || doc.internal.pageSize.getWidth();

        //전달된 width 값이 없을 시 테이블의 너비는 페이지 너비로 함
        //(페이지 전체 너비 - 좌우 여백)
        width = (width == 0 ? PAGE_WIDTH - (MARGIN_SIZE * 2) : width);
        
        const MARGIN = (PAGE_WIDTH - width) / 2;
        
        let MARGIN_LEFT = MARGIN;
        let MARGIN_RIGHT = MARGIN;
        
        // 좌,우 정렬 시 여백 처리
        if(align == 'left') {
            MARGIN_LEFT = MARGIN_SIZE;
            MARGIN_RIGHT = MARGIN_SIZE;
        } else if(align == 'right') {
            MARGIN_LEFT = PAGE_WIDTH - MARGIN_SIZE - width;
            MARGIN_RIGHT = MARGIN_SIZE;
        }
        
        doc.autoTable({
            theme: 'striped',
            startX: x,
            startY: y,
            tableWidth : width,
            margin: {
                left: MARGIN_LEFT, 
                right: MARGIN_RIGHT
            },
            head: head,
            body : body
        });
    }        

    function addTable(doc, head, body, {width = 0, align = 'center', x = MARGIN_SIZE, y = Y_LOC}){
        const PAGE_WIDTH = doc.internal.pageSize.width || doc.internal.pageSize.getWidth();

        width = (width == 0 ? PAGE_WIDTH - (MARGIN_SIZE * 2) : width);
        const MARGIN = (PAGE_WIDTH - width) / 2;
        
        let MARGIN_LEFT = MARGIN;
        let MARGIN_RIGHT = MARGIN;
        
        if(align == 'left') {
            MARGIN_LEFT = MARGIN_SIZE;
            MARGIN_RIGHT = MARGIN_SIZE;
        } else if(align == 'right') {
            MARGIN_LEFT = PAGE_WIDTH - MARGIN_SIZE - width;
            MARGIN_RIGHT = MARGIN_SIZE;
        }
        
        /// 페이지 잘림 계산
        const temp = Y_LOC;
        Y_LOC = (Y_LOC + (CELL_HEIGHT * (head.length + body.length)) > 287 ? MARGIN_SIZE + 1000 : Y_LOC);
        if(y == temp) y = Y_LOC;
        /// end of 페이지 잘림 계산
        
        doc.autoTable({
            theme: 'plain',
            startX: x,
            startY: y,
            tableWidth : width,
            margin: {
                left: MARGIN_LEFT, 
                right: MARGIN_RIGHT
            },
            styles : { font : 'malgun', fontStyle :'normal'},
            head: head,
            body : body
        });
    }

    function handleSubmit() {
    	console.log('handleSubmit()');
    }
</script>

