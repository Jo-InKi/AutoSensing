<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	var virCheck = true;
	var daemonIPList = new Array();
	var idCheckString = setIdRules();

	function setIdRules() {
	    var element = document.querySelector('#idToolTip');
	    var checkString = "^";
	    var checkToolTip = "";
	    if("${idSet.id_upp}" == "TRUE") {
	        checkString += "(?=.*[A-Z])";
	        checkToolTip += "영문 대문자, ";
	    }
	    if("${idSet.id_num}" == "TRUE") {
	        checkString += "(?=.*[0-9])";
	        checkToolTip += "숫자, ";
	    }
	    if(checkToolTip != ""){
	        checkToolTip = checkToolTip.slice(0, -2);
	        checkToolTip += " 포함, ";
	    }
	    checkString += "[가-힣a-zA-Z0-9_\-]{" + ${idSet.id_len} + ",16}$";
	    checkToolTip += ${idSet.id_len} + "자리 이상";
	    
	    if (element != null){
	    	element.setAttribute('data-bs-title', checkToolTip);
	    }
	    return checkString;
	}
	
	document.addEventListener("DOMContentLoaded", function() { // 회원가입 유효성 검사 함수
		//비밀번호 확인
		document.querySelector("#passwordValidFeedback").style.display = 'none';
		document.querySelector("#passwordInvalidFeedback").style.display = 'none';
		
		const userPwdEl = document.querySelector('#passwd');
		if(userPwdEl) userPwdEl.addEventListener('keyup',function(el) {

			let firstPw = document.querySelector('#passwd').value;
			let id = document.querySelector('#userid').value;
			
			if(firstPw == id){
				document.querySelector("#passwordValidationFeedback").innerHTML = '비밀번호는 아이디와 같을 수 없습니다.';
				document.querySelector("#passwordConfirm").disabled = true;
			}else{
				document.querySelector("#passwd").className = 'form-control is-valid';
			}
		});
		
		
		const passwordConfirmEl = document.querySelector('#passwordConfirm');
		if(passwordConfirmEl) passwordConfirmEl.addEventListener('keyup',function(el) {
			let firstPw = document.querySelector('#passwd').value;
			let secondPw = document.querySelector('#passwordConfirm').value;
			if (firstPw != "" || secondPw != "") {
				if (firstPw == secondPw) {
					document.querySelector('#passwordValidFeedback').style.display = 'block';
					document.querySelector('#passwordInvalidFeedback').style.display = 'none';
					document.querySelector('#passwordConfirm').className = 'form-control is-valid';
				} else {
					document.querySelector('#passwordValidFeedback').style.display = 'none';
					document.querySelector('#passwordInvalidFeedback').style.display = 'block';
					document.querySelector('#passwordConfirm').className = 'form-control is-invalid';
				}
			}
			if (firstPw == "" || secondPw == "") {
				document.querySelector('#passwordValidFeedback').style.display = 'none';
				document.querySelector('#passwordInvalidFeedback').style.display = 'none';
				document.querySelector('#passwordConfirm').className = 'form-control is-invalid';
			}
		});
	});
</script>
<script type="text/javascript">
const textBox = document.getElementById("userid");
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
var idCheck = false;
var idDupChk = false;

//유효성 검사 모두 통과시에만 버튼 활성화
function changeBtn(){
	var flag_msg = '${from_controller}';
	const userSubmitEl = document.querySelector('#userSubmit');
	const submitBtnEl = document.querySelector('#submitBtn');
	
	if(flag_msg){
		if(userSubmitEl) userSubmitEl.disabled = false;
		if(submitBtnEl) submitBtnEl.disabled = false;
	}else if(idCheck && idDupChk){
		if(userSubmitEl) userSubmitEl.disabled = false;
		if(submitBtnEl) submitBtnEl.disabled = false;
	}else{
		if(userSubmitEl) userSubmitEl.disabled = true;
		if(submitBtnEl) submitBtnEl.disabled = true;
	}
}

function resetIdDuplicateChk(){
	idDupChk = false;
}

//아이디 중복확인
function userIdDuplicationCheck(){
	var userId = document.querySelector('#userid').value;
	var prv_userId = '${user.userid}';
	
	if(!document.querySelector('#userid').value || userId == '' || userId == null){
		alert("아이디를 입력하세요!");
		document.querySelector('#userid').focus();
		document.querySelector('#userid').className = 'table_input is-invalid';
		document.querySelector('#useridIDduplicate_check').disabled = true;
	}
	
	$.ajax({
		type : "POST", 
		url : "/vpn/settings/add/user/duplication/check.do", 
		data : { 
			"id" : userId,
			"prv_userId": prv_userId
		},
		success : function(data) {
		if(document.querySelector('#userid').value){
			if (data == 1) { // 1이면 중복
				idDupChk = false;
				document.querySelector('#userid').className = 'table_input is-invalid';
				document.querySelector('#useridValidationFeedback').innerHTML = '중복된 아이디입니다.';
				document.querySelector('#useridValidationFeedback').style.display = 'block';
				document.querySelector('#userid').focus();
				changeBtn();
				
			} else { // 중복 아님
				idDupChk = true;
				idCheck = true;
				changeBtn();
				if(userId == prv_userId){
			    	alert("현재 아이디와 동일합니다.");
			    	document.querySelector('#userid').className = 'table_input is-valid';
			    	return;
				}
					document.querySelector('#useridValidationFeedback').style.display = 'none';
			    	alert("사용 가능한 아이디 입니다!");
			    	document.querySelector('#userid').className = 'table_input is-valid';
				}
			}
		}
	});
}


//아이디 확인
if(document.querySelector('#userid')) document.querySelector('#userid').addEventListener('keyup',function(el) {
	var idCheck = RegExp(idCheckString);
	let id = document.querySelector('#userid').value;
	
	document.querySelector('#useridIDduplicate_check').disabled = false;
	if(!idCheck.test(id)){
		document.querySelector('#userid').className = 'table_input is-invalid';
		document.querySelector('#useridValidationFeedback').innerHTML = '아이디 형식을 확인하세요.';
		document.querySelector('#useridValidationFeedback').style.display = 'block';
		document.querySelector('#useridIDduplicate_check').disabled = true;
		idCheck = false;
	}else if(idDupChk == false){
		document.querySelector('#userid').className = 'table_input is-invalid';
		document.querySelector('#useridValidationFeedback').innerHTML = '아이디 중복 검사가 필요합니다.';
		document.querySelector('#useridValidationFeedback').style.display = 'block';
		document.querySelector('#useridIDduplicate_check').disabled = false;
		idCheck = false;
	}else{
		document.querySelector('#useridValidationFeedback').style.display = 'none';
		document.querySelector('#userid').className = 'table_input is-valid';
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
</script>
