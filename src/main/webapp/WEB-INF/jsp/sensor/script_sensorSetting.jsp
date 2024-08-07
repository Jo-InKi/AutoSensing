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
	const textBox = document.getElementById("USER_ID");
	if(textBox){
		textBox.onpaste = (e) => { //붙여 넣기 막기
		  e.preventDefault();
		  return false;
		};
		textBox.oncopy = (e) => { //복사 막기
		  e.preventDefault();
		  return false;
		};
		textBox.oncut = (e) => { //잘라내기 막기
		  e.preventDefault();
		  return false;
		};
	}
	const autoHyphen2 = (target) => {
		target.value = target.value
		 .replace(/[^0-9]/g, '')
		 .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
	}
	//유효성 검사 결과 저장 변수
	var sensoridCheck = false;
	var sensoridDupChk = false;
	
	//유효성 검사 모두 통과시에만 버튼 활성화
	function changeBtn(){
		var flag_msg = '${from_controller}';
		const sensorSubmitEl = document.querySelector('#sensorSubmit');
		const submitBtnEl = document.querySelector('#submitBtn');
		
		if(flag_msg){
			if(sensorSubmitEl) sensorSubmitEl.disabled = false;
			if(submitBtnEl) submitBtnEl.disabled = false;
		}else if(sensoridCheck && sensoridCheck){
			if(sensorSubmitEl) sensorSubmitEl.disabled = false;
			if(submitBtnEl) submitBtnEl.disabled = false;
		}else{
			if(sensorSubmitEl) sensorSubmitEl.disabled = true;
			if(submitBtnEl) submitBtnEl.disabled = true;
		}
	}

	function resetSensorIdDuplicateChk(){
		sensoridDupChk = false;
	}

	//아이디 중복확인
	function sensorIdDuplicationCheck(){
		var sensorid = document.querySelector('#sensorid').value;
		var channel = document.querySelector('#channel').value;
		
		console.log(document.querySelector('#channel'));
		
		console.log(sensorid, channel);
		if(channel == '') channel=0;
		
		if(!document.querySelector('#sensorid').value || sensorid == '' || sensorid == null){
			alert("아이디를 입력하세요!");
			document.querySelector('#sensorid').focus();
			document.querySelector('#sensorid').className = 'table_input is-invalid';
			document.querySelector('#sensoridIDduplicate_check').disabled = true;
		}
		
		$.ajax({
			type : "POST", 
			url : "/sensor/duplication/check.do", 
			data : { 
				"sensorid" : sensorid,
				"channel" : channel
			},
			success : function(data) {
			if(document.querySelector('#sensorid').value){
				console.log('sensorid duplication check', data)
				if (data == 1) { // 1이면 중복
					sensoridDupChk = false;
					document.querySelector('#sensorid').className = 'table_input is-invalid';
					document.querySelector('#sensoridValidationFeedback').innerHTML = '중복된 아이디입니다.';
					document.querySelector('#sensoridValidationFeedback').style.display = 'block';
					document.querySelector('#sensorid').focus();
					changeBtn();
					
				} else { // 중복 아님
					sensoridCheck = true;
					sensoridDupChk = true;
					changeBtn();

					document.querySelector('#sensoridValidationFeedback').style.display = 'none';
			    	alert("사용 가능한 아이디 입니다!");
			    	document.querySelector('#sensorid').className = 'table_input is-valid';
				}
			}}
		});
	}


	//아이디 확인
	if(document.querySelector('#projectid')) document.querySelector('#projectid').addEventListener('keyup',function(el) {
		var idCheck = RegExp(idCheckString);
		let id = document.querySelector('#projectid').value;
		console.log('idCheckString',id, idCheckString, idCheck.test(id));
		
		document.querySelector('#IDduplicate_check').disabled = false;
		if(!idCheck.test(id)){
			document.querySelector('#projectid').className = 'table_input is-invalid';
			document.querySelector('#idValidationFeedback').innerHTML = '아이디 형식을 확인하세요.';
			document.querySelector('#idValidationFeedback').style.display = 'block';
			document.querySelector('#IDduplicate_check').disabled = true;
			idCheck = false;
		}else if(idDupChk == false){
			document.querySelector('#projectid').className = 'table_input is-invalid';
			document.querySelector('#idValidationFeedback').innerHTML = '아이디 중복 검사가 필요합니다.';
			document.querySelector('#idValidationFeedback').style.display = 'block';
			document.querySelector('#IDduplicate_check').disabled = false;
			idCheck = false;
		}else{
			document.querySelector('#idValidationFeedback').style.display = 'none';
			document.querySelector('#projectid').className = 'table_input is-valid';
			idCheck = true;
		}
		changeBtn();
	});
		
	changeBtn();
	
	function isTelFormat(tel) {
		if(tel == ""){
			return false;
		}
		var phoneRule = RegExp(/^(070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/);
		return phoneRule.test(tel);
	}
	
	function isHpFormat(hp){
		if(hp == ""){
			return false;
		}
		var phoneRule = RegExp(/^(01[016789]{1})-[0-9]{3,4}-[0-9]{4}$/);
		return phoneRule.test(hp);
	}
	
	function stck(str, limit) {
	    var o, d, p, n = 0, l = limit == null ? 4 : limit;
	    for (var i = 0; i < str.length; i++) {
	        var c = str.charCodeAt(i);
	        if (i > 0 && (p = o - c) > -2 && p < 2 && (n = p == d ? n + 1 : 0) > l - 3) 
	            return false;
	            d = p, o = c;
	    }
	    return true;
	}

	const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
	const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
	
	function projectChange(val) {
		$.ajax({
			type : "POST", 
			url : "/location/list", 
			data : { 
				"projectid" : val
			},
			success : function(data) {
				var location_tag = '';
				for(var ii = 0; ii < data.length; ii++ ) {
					location_tag += '<option value="'+ data[ii].location_sn + '">' + data[ii].location_nm + '</option>';
				}
				
				document.querySelector('#location_sn').innerHTML = location_tag;
			}
		});
	}
</script>
