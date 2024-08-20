<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
	var virCheck = true;
	
	const textareaEl = document.querySelector('.text_box textarea');
	if(textareaEl) textareaEl.addEventListener('keyup',function(el) {
		  var content = el.target.value;
		  document.querySelector('.text_box .count span').innerHTML = content.length;
		  if (content.length > 512){
		    alert("최대 512자까지 입력 가능합니다.");
		    el.target.value = content.substring(0, 512);
		    document.querySelector('.text_box .count span').innerHTML = 512;
		  }
		});
	
	function userListClick(id){
		console.log(id);
		
		const url = "/project/assign/" + id;
		$.ajax({
			type : "GET",
			url : url,
			/* data: {
				"projectid" : val
			}, */
			success : function(data) {
				const assignedList = data.assignedList;
				const notAssignedList = data.notAssignedList;
				
				console.log(document.getElementById("projectListCard"));
				
				
				var notassignedTag = '';
				
				for(var ii = 0; ii < notAssignedList.length; ii++) {
					console.log(notAssignedList[ii]);
					notassignedTag += `<button onClick="targetListClick('notAssignedList[ii].projectid')" id="notAssignedList[ii].projectid"` +
									`value="notAssignedList[ii].projectid" name="projectList"` + 
									`class="list-group-item list-group-item-action">` +
									notAssignedList[ii].projectname +
									`</button>`;
				}
				console.log(notassignedTag);
				document.getElementById("projectListCard").innerHTML = notassignedTag;
				
				console.log(document.getElementById("userProjectListCard"));
				
				var assignedTag = '';
				for(var ii = 0; ii < assignedList.length; ii++) {
					console.log(assignedList[ii]);
					assignedTag += `<button onClick="targetListClick('assignedList[ii].projectid')" id="assignedList[ii].projectid"` +
										`value="assignedList[ii].projectid" name="projectListn"` + 
										`class="list-group-item list-group-item-action">` +
										assignedList[ii].projectname +
										`</button>`;
				}
				console.log('assignedTag', assignedTag);
				document.getElementById("userProjectListCard").innerHTML = assignedTag;
			},
			error : function(error) {
				console.log('error', error);
			}
		});
		
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

	var projectidChk = false;
	var projectnameChk = false;
	var emnameChk = false;
	var projectidDupChk = false;
	var projectnameDupChk = false;
	var emnameDupChk = false;
	
	//유효성 검사 모두 통과시에만 버튼 활성화
	function changeBtn(){
		var flag_msg = '${from_controller}';
		const projectSubmitEl = document.querySelector('#projectSubmit');
		const submitBtnEl = document.querySelector('#submitBtn');
		if(flag_msg){
			if(projectSubmitEl) projectSubmitEl.disabled = false;
			if(submitBtnEl) submitBtnEl.disabled = false;
		}else if(projectidChk && projectnameChk && emnameChk && projectidDupChk && projectnameDupChk && emnameDupChk){
			if(projectSubmitEl) projectSubmitEl.disabled = false;
			if(submitBtnEl) submitBtnEl.disabled = false;
		}else{
			if(projectSubmitEl) projectSubmitEl.disabled = true;
			if(submitBtnEl) submitBtnEl.disabled = true;
		}
	}

	function resetprojectIdDuplicateChk(){
		projectidDupChk = false;
	}
	
	function resetprojectnameDuplicateChk(){
		projectnameDupChk = false;
	}
	
	function resetemnameDuplicateChk(){
		emnameDupChk = false;
	}

	//프로젝트 아이디 중복확인
	function projectIdDuplicationCheck(){
		var projectId = document.querySelector('#projectid').value;
		
		console.log(projectId);
		
		if(!document.querySelector('#projectid').value || projectId == '' || projectId == null){
			alert("아이디를 입력하세요!");
			document.querySelector('#projectid').focus();
			document.querySelector('#projectid').className = 'table_input is-invalid';
			document.querySelector('#projectidDuplicate_check').disabled = true;
		}
		
		$.ajax({
			type : "POST", 
			url : "/project/duplication/check.do", 
			data : { 
				"projectid" : projectId
			},
			success : function(data) {
			if(document.querySelector('#projectid').value){
				if (data == 1) { // 1이면 중복
					projectidDupChk = false;
					document.querySelector('#projectid').className = 'table_input is-invalid';
					document.querySelector('#projectidValidationFeedback').innerHTML = '중복된 아이디입니다.';
					document.querySelector('#projectidValidationFeedback').style.display = 'block';
					document.querySelector('#projectid').focus();
					changeBtn();
				} else { // 중복 아님
					projectidDupChk = true;
					projectidChk = true;
					changeBtn();
					document.querySelector('#projectidValidationFeedback').style.display = 'none';
			    	alert("사용 가능한 아이디 입니다!");
			    	document.querySelector('#projectid').className = 'table_input is-valid';
				}
			}}
		});
	}
	
	//프로젝트 한글 명칭 중복확인
	function projectnameDuplicationCheck(){
		var projectname = document.querySelector('#projectname').value;
		
		if(!document.querySelector('#projectname').value || projectname == '' || projectname == null){
			alert("한글 명칭을 입력하세요!");
			document.querySelector('#projectname').focus();
			document.querySelector('#projectname').className = 'table_input is-invalid';
			document.querySelector('#projectnameDuplicate_check').disabled = true;
		}
		
		$.ajax({
			type : "POST", 
			url : "/project/duplication/check.do", 
			data : { 
				"projectname" : projectname
			},
			success : function(data) {
				console.log(data);
			if(document.querySelector('#projectname').value){
				if (data == 1) { // 1이면 중복
					projectnameDupChk = false;
					document.querySelector('#projectname').className = 'table_input is-invalid';
					document.querySelector('#projectnameValidationFeedback').innerHTML = '중복된 프로젝트 한글 명칭입니다.';
					document.querySelector('#projectnameValidationFeedback').style.display = 'block';
					document.querySelector('#projectname').focus();
					changeBtn();
				} else { // 중복 아님
					projectnameDupChk = true;
					projectnameChk = true;
					changeBtn();
					document.querySelector('#projectnameValidationFeedback').style.display = 'none';
			    	alert("사용 가능한 프로젝트 한글 명칭입니다!");
			    	document.querySelector('#projectname').className = 'table_input is-valid';
				}
			}}
		});
	}
	
	//프로젝트 영문 명칭 중복확인
	function emnameDuplicationCheck(){
		var emname = document.querySelector('#emname').value;
		
		if(!document.querySelector('#emname').value || emname == '' || emname == null){
			alert("영문 명칭을 입력하세요!");
			document.querySelector('#emname').focus();
			document.querySelector('#emname').className = 'table_input is-invalid';
			document.querySelector('#emnameDuplicate_check').disabled = true;
		}
		
		$.ajax({
			type : "POST", 
			url : "/project/duplication/check.do", 
			data : {
				"emname" : emname
			},
			success : function(data) {
			if(document.querySelector('#emname').value){
				if (data == 1) { // 1이면 중복
					emnameDupChk = false;
					document.querySelector('#emname').className = 'table_input is-invalid';
					document.querySelector('#emnameValidationFeedback').innerHTML = '중복된 영문 명칭입니다.';
					document.querySelector('#emnameValidationFeedback').style.display = 'block';
					document.querySelector('#emname').focus();
					changeBtn();
				} else { // 중복 아님
					emnameDupChk = true;
					emnameChk = true;
					changeBtn();
					document.querySelector('#emnameValidationFeedback').style.display = 'none';
			    	alert("사용 가능한 영문 명칭입니다!");
			    	document.querySelector('#emname').className = 'table_input is-valid';
				}
			}}
		});
	}

	//프로젝트 아이디 확인
	if(document.querySelector('#projectid')) document.querySelector('#projectid').addEventListener('keyup',function(el) {
		let projectid = document.querySelector('#projectid').value;
		if(projectid != '') {
			document.querySelector('#projectidValidationFeedback').style.display = 'none';
			document.querySelector('#projectid').className = 'table_input is-valid';
			document.querySelector('#projectidDuplicate_check').disabled = false;
			projectidDupChk = true;
		} else {
			document.querySelector('#projectidValidationFeedback').style.display = 'none';
			document.querySelector('#projectid').className = 'table_input is-valid';
			document.querySelector('#projectidDuplicate_check').disabled = true;
			projectidDupChk = false;
		}
		changeBtn();
	});
	
	//프로젝트 명칭 한글
	if(document.querySelector('#projectname')) document.querySelector('#projectname').addEventListener('keyup',function(el) {
		let projectname = document.querySelector('#projectname').value;
		if(projectname != '') {
			document.querySelector('#projectnameValidationFeedback').style.display = 'none';
			document.querySelector('#projectname').className = 'table_input is-valid';
			document.querySelector('#projectnameDuplicate_check').disabled = false;
			projectnameDupChk = true;
		} else {
			document.querySelector('#projectnameValidationFeedback').style.display = 'none';
			document.querySelector('#projectname').className = 'table_input is-valid';
			document.querySelector('#projectnameDuplicate_check').disabled = true;
			projectnameDupChk = false;
		}
		changeBtn();
	});
	
	//프로젝트 명칭 영문
	if(document.querySelector('#emname')) document.querySelector('#emname').addEventListener('keyup',function(el) {
		let emname = document.querySelector('#emname').value;
		console.log(projectid);
		if(emname != '') {
			document.querySelector('#emnameValidationFeedback').style.display = 'none';
			document.querySelector('#emname').className = 'table_input is-valid';
			document.querySelector('#emnameDuplicate_check').disabled = false;
			emnameDupChk = true;
		} else {
			document.querySelector('#emnameValidationFeedback').style.display = 'none';
			document.querySelector('#emname').className = 'table_input is-valid';
			document.querySelector('#emnameDuplicate_check').disabled = true;
			emnameDupChk = false;
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
	
	function pop(img) {
		 var win = window.open('', 'Detail', 'width=0, height=0, menubar=0, toolbar=0, directories=0, scrollbars=1, status=0, location=0, resizable=1');
		 op="<html><head><title>크게 보기</title></head>";
		 op+="<body leftmargin='0' topmargin='0'>";
		 op+="<img src='"+ img.src +"' border='0' style='cursor:pointer' onclick='window.close();' onload='window.resizeTo(this.width+30, this.height+90); window.moveTo( (screen.width-this.width)/2 ,  (screen.height-this.height)/2-50 )'>";
		 op+="</body></html>";
		 win.document.write(op);
	}
	
	function execDaumPostcode() {
        new daum.Postcode( {
          oncomplete: function( data ) {
            document.getElementById( 'zipcode' ).value = data.zonecode;
            document.getElementById( 'address1' ).value = data.address;
          }
        } ).open();
      }
</script>
