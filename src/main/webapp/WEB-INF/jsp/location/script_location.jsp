<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	var virCheck = true;
	
	function projectListClick(id){
		console.log(id);
		const url = "/sensor/list/";
		$.ajax({
			type : "GET",
			url : url,
			/* data: {
				"projectid" : val
			}, */
			success : function(data) {
				var sensorListCard = '';
				var projectSensorListCard = '';
				for(var ii = 0; ii < data.length; ii++) {
					if(id === data[ii].projectid) {
						projectSensorListCard += `<button onClick="targetListClick('data[ii].sensorid')" id="data[ii].sensorid"` +
										`value="data[ii].sensorid" name="sensorList"` + 
										`class="list-group-item list-group-item-action">` +
										data[ii].location +
										`</button>`;
					} else if('' === data[ii].projectid) {
						sensorListCard += `<button onClick="targetListClick('data[ii].sensorid')" id="data[ii].sensorid"` +
										`value="data[ii].sensorid" name="sensorList"` + 
										`class="list-group-item list-group-item-action">` +
										data[ii].location +
										`</button>`;
					}
				}
				
				document.getElementById("sensorListCard").innerHTML = sensorListCard;
				document.getElementById("projectSensorListCard").innerHTML = projectSensorListCard;

			},
			error : function(error) {
				console.log('error', error);
			}
		});
	}
	
	const tabList = (e) =>{
		currentTab = e.innerText.toLowerCase();
		let tabLink = e.getAttribute("data-tab");
		let tabContent = document.getElementById(tabLink);
		let currents = e.closest(".tabWrap").querySelectorAll(".current");
	    
	    for(let i = 0; i < currents.length; i++){
	        currents[i].classList.remove("current");
	    }
		e.classList.add("current");
		tabContent.classList.add("current");
	}
</script>
<script type="text/javascript">
	//유효성 검사 결과 저장 변수
	var locationChk = false;
	var locationDupChk = false;

	//유효성 검사 모두 통과시에만 버튼 활성화
	function changeBtn(){
		var flag_msg = '${from_controller}';
		const locationSubmitEl = document.querySelector('#locationSubmit');
		const submitBtnEl = document.querySelector('#submitBtn');
		
		if(flag_msg){
			if(locationSubmitEl) locationSubmitEl.disabled = false;
			if(submitBtnEl) submitBtnEl.disabled = false;
		}else if(locationDupChk&&locationChk){
			if(locationSubmitEl) locationSubmitEl.disabled = false;
			if(submitBtnEl) submitBtnEl.disabled = false;
		}else{
			if(locationSubmitEl) locationSubmitEl.disabled = true;
			if(submitBtnEl) submitBtnEl.disabled = true;
		}
	}

	function resetLocationDuplicateChk(){
		locationDupChk = false;
	}

	//아이디 중복확인
	function locationDuplicationCheck(){
		var location_nm = document.querySelector('#location_nm').value;
		var projectid = document.querySelector('#projectid').value;

		if(location_nm == '' || location_nm == null){
			alert("위치 입력하세요!");
			document.querySelector('#location_nm').focus();
			document.querySelector('#location_nm').className = 'table_input is-invalid';
			document.querySelector('#locationduplicate_check').disabled = true;
		}
		
		$.ajax({
			type : "POST", 
			url : "/location/duplication/check.do", 
			data : { 
				"location_nm" : location_nm,
				"projectid" : projectid
			},
			success : function(data) {
			if(document.querySelector('#location_nm').value){
				if (data == 1) { // 1이면 중복
					locationDupChk = false;
					document.querySelector('#location_nm').className = 'table_input is-invalid';
					document.querySelector('#locationValidationFeedback').innerHTML = '중복된 위치명입니다.';
					document.querySelector('#locationValidationFeedback').style.display = 'block';
					document.querySelector('#location_nm').focus();
					changeBtn();
					
				} else { // 중복 아님
					locationDupChk = true;
					locationChk = true;
					changeBtn();

					document.querySelector('#locationValidationFeedback').style.display = 'none';
			    	alert("사용 가능한 위치명 입니다!");
			    	document.querySelector('#location_nm').className = 'table_input is-valid';
				}
			}}
		});
	}

	//아이디 확인
	if(document.querySelector('#location_nm')) document.querySelector('#location_nm').addEventListener('keyup',function(el) {
		let location_nm = document.querySelector('#location_nm').value;
		if(location_nm != '') {
			document.querySelector('#locationValidationFeedback').style.display = 'none';
			document.querySelector('#location_nm').className = 'table_input is-valid';
			document.querySelector('#locationDuplicate_check').disabled = false;
			locationDupChk = true;
		} else {
			document.querySelector('#locationValidationFeedback').style.display = 'none';
			document.querySelector('#location_nm').className = 'table_input is-valid';
			document.querySelector('#locationDuplicate_check').disabled = true;
			locationDupChk = false;
		}
		changeBtn();
	});
		
	changeBtn();
	
	const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
	const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
</script>
