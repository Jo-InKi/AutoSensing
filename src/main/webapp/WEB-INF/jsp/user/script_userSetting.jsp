<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	var virCheck = true;
	var daemonIPList = new Array();
	
	document.addEventListener('DOMContentLoaded',function() {
		$('#ip_1, #ip_2, #ip_3, #ip_4').on("propertychange change paste input", function() {
			var ip_1 = document.querySelector('#ip_1').value;
			var ip_2 = document.querySelector('#ip_2').value;
			var ip_3 = document.querySelector('#ip_3').value;
			var ip_4 = document.querySelector('#ip_4').value;
			var chk_ip = ip_1 + "." + ip_2 + "." + ip_3 + "." + ip_4
			var daemon_count = '${daemon_count}';
			var str = '<c:out value="${daemon_config}"/>';
			str = str.replaceAll("&#034;", "\"");
			var daemon_config = new Map(Object.entries(JSON.parse(str)));
			var vip = "";
			for (let ii = 0; ii < daemon_count; ii++) {
				var ip = daemon_config.get("vpn.server.daemon."+ii+".ip.addr");
				var subnet = CIDR2netmask(daemon_config.get("vpn.server.daemon."+ii+".ip.netbit"));
				daemonIPList.push(ip);
				if(ip_chk(ip, subnet, chk_ip)) {
					virCheck = true;
					console.log(daemon_config.get("vpn.server.daemon."+ii+".vip.addr"));
					vip = daemon_config.get("vpn.server.daemon."+ii+".vip.addr").split('.');
					document.getElementById('vip_1').value = vip[0];
					document.getElementById('vip_2').value = vip[1];
					document.getElementById('vip_3').value = ip_3;
					document.getElementById('vip_4').value = ip_4;
					break;
				}else{
					virCheck = false;
				}
			}
			if(virCheck){
				document.querySelector('#ipRangeValidationFeedback').style.display = 'none';
				document.querySelector('#userSubmit').disabled = false;
				if(document.querySelector('#submitBtn')) document.querySelector('#submitBtn').disabled =false;
			}else{
				document.querySelector('#ipRangeValidationFeedback').innerHTML = "SSL VPN 설정 > 데몬의 Real IP 대역에 맞게 입력하세요." + " (" + daemonIPList[0] + " ~ " + daemonIPList[daemonIPList.length-1] + ")";
				document.querySelector('#ipRangeValidationFeedback').style.display = 'block';
				document.querySelector('#userSubmit').disabled = true;
				if(document.querySelector('#submitBtn')) document.querySelector('#submitBtn').disabled = true;
				document.getElementById('vip_1').value = '';
				document.getElementById('vip_2').value = '';
				document.getElementById('vip_3').value = '';
				document.getElementById('vip_4').value = '';
			}
		});
	});
	
	function ip2long ( ip_address ) {  
	    var output = false;  
	    if ( ip_address.match ( /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/ ) ) {  
	      var parts = ip_address.split ( '.' );  
	      var output = 0;  
	      output = ( parts [ 0 ] * Math.pow ( 256, 3 ) ) +  
	               ( parts [ 1 ] * Math.pow ( 256, 2 ) ) +  
	               ( parts [ 2 ] * Math.pow ( 256, 1 ) ) +  
	               ( parts [ 3 ] * Math.pow ( 256, 0 ) );  
	    }  
	      
	    return output<<0;  
	}  

	function ip_chk( ip, subnet, chk_ip) {
	    long_ip = ip2long(ip);
	    long_subnet = ip2long(subnet);
	    long_max = ip2long('255.255.255.255');
	    long_chk_ip = ip2long(chk_ip);

	    range_from = long_ip & long_subnet;

	    range_bo = long_subnet ^ long_max;
	    range_to = long_ip | range_bo;
	    if( long_chk_ip > range_from && long_chk_ip < range_to ) return true;
	    else return false;
	}
	
	function CIDR2netmask( bitCount ) {
		  var mask=[];
		  for(var i=0;i<4;i++) {
		    var n = Math.min(bitCount, 8);
		    mask.push(256 - Math.pow(2, 8-n));
		    bitCount -= n;
		  }
		  return mask.join('.');
		}
	
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
var nmCheck = false;
var emailCheck = false;
var cpCheck = false;
var idDupChk = false;
var emailDupChk = false;
var ipCheck = false;

//유효성 검사 모두 통과시에만 버튼 활성화
function changeBtn(){
	var flag_msg = '${from_controller}';
	const userSubmitEl = document.querySelector('#userSubmit');
	const submitBtnEl = document.querySelector('#submitBtn');
	
	if(flag_msg){
		if(userSubmitEl) userSubmitEl.disabled = false;
		if(submitBtnEl) submitBtnEl.disabled = false;
	}else if(idCheck && nmCheck && emailCheck && cpCheck && ipCheck && idDupChk && emailDupChk){
		if(userSubmitEl) userSubmitEl.disabled = false;
		if(submitBtnEl) submitBtnEl.disabled = false;
	}else{
		if(userSubmitEl) userSubmitEl.disabled = true;
		if(submitBtnEl) submitBtnEl.disabled = true;
	}
}

//이메일 및 아이디 중복검사 후 저장 누르기 전에 수정하면 중복검사 다시 하게 해야함
function resetEmailDuplicateChk(){
	emailDupChk = false;
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
		document.querySelector('#IDduplicate_check').disabled = true;
	}
	
	$.ajax({
		type : "POST", 
		url : "/vpn/settings/add/user/duplication/check.do", 
		data : { 
			"id" : userId,
			"prv_userId": prv_userId
		},
		success : function(data) {
		if(document.querySelector('#USER_ID').value){
			if (data == 1) { // 1이면 중복
				idDupChk = false;
				document.querySelector('#USER_ID').className = 'table_input is-invalid';
				document.querySelector('#idValidationFeedback').innerHTML = '중복된 아이디입니다.';
				document.querySelector('#idValidationFeedback').style.display = 'block';
				document.querySelector('#USER_ID').focus();
				changeBtn();
				
			} else { // 중복 아님
				idDupChk = true;
				idCheck = true;
				changeBtn();
				if(userId == prv_userId){
			    	alert("현재 아이디와 동일합니다.");
			    	document.querySelector('#USER_ID').className = 'table_input is-valid';
			    	return;
				}
					document.querySelector('#idValidationFeedback').style.display = 'none';
			    	alert("사용 가능한 아이디 입니다!");
			    	document.querySelector('#USER_ID').className = 'table_input is-valid';
				}
			}
		}
	});
}
//이메일 중복 확인
function emailDuplicationCheck(){
var email = document.querySelector('#email').value;
var prv_email = '${user.email}';
	
	if(!document.querySelector('#email').value || email == '' || email == null){
		alert("이메일을 입력하세요!");
		document.querySelector('#email').focus();
		document.querySelector('#emailDuplicate_check').disabled = true;
	}
	
	$.ajax({
		type : "POST", 
		url : "/vpn/settings/add/user/email/duplication/check.do", 
		data : { 
			"email" : email,
			"prv_email" : prv_email
		},
		success : function(data) {
		if(document.querySelector('#email').value){
			if (data == 1) { // 1이면 중복
				emailDupChk = false;
				changeBtn();
				document.querySelector('#email').className = 'table_input is-invalid';
				document.querySelector('#emailValidationFeedback').innerHTML = '중복된 이메일 주소 입니다.';
				document.querySelector('#emailValidationFeedback').style.display = 'block';
				document.querySelector('#EMAIL').focus();
			} else { // 중복 아님
				emailDupChk = true;
			    emailCheck = true;
				changeBtn();
				if(email == prv_email){
			    	alert("현재 이메일과 동일합니다.");
			    	document.querySelector('#EMAIL').className = 'table_input is-valid';
			    	return;
				}
					document.querySelector('#emailValidationFeedback').style.display = 'none';
			    	alert("사용 가능한 이메일 주소 입니다!");
			    	document.querySelector('#EMAIL').className = 'table_input is-valid';
				}
			}
		}
	});
}


		//아이디 확인
		if(document.querySelector('#userid')) document.querySelector('#userid').addEventListener('keyup',function(el) {
			var idCheck = RegExp(idCheckString);
			let id = document.querySelector('#userid').value;
			
			document.querySelector('#IDduplicate_check').disabled = false;
			if(!idCheck.test(id)){
				document.querySelector('#USER_ID').className = 'table_input is-invalid';
				document.querySelector('#idValidationFeedback').innerHTML = '아이디 형식을 확인하세요.';
				document.querySelector('#idValidationFeedback').style.display = 'block';
				document.querySelector('#IDduplicate_check').disabled = true;
				idCheck = false;
			}else if(idDupChk == false){
				document.querySelector('#USER_ID').className = 'table_input is-invalid';
				document.querySelector('#idValidationFeedback').innerHTML = '아이디 중복 검사가 필요합니다.';
				document.querySelector('#idValidationFeedback').style.display = 'block';
				document.querySelector('#IDduplicate_check').disabled = false;
				idCheck = false;
			}else{
				document.querySelector('#idValidationFeedback').style.display = 'none';
				document.querySelector('#USER_ID').className = 'table_input is-valid';
				idCheck = true;
			}
			changeBtn();
		});
		
		//이름 확인
		if(document.querySelector('#username')) document.querySelector('#username').addEventListener('keyup',function(el) {
			var nameCheck = RegExp(/^[A-Za-z가-힣_\-0-9]{2,32}$/);
			let name = document.querySelector('#username').value;
			
			if(!nameCheck.test(name)){
				nmCheck = false;
				document.querySelector('#username').className = 'table_input is-invalid';
				document.querySelector('#usernameValidationFeedback').innerHTML = '이름 형식을 확인하세요.';
				// 				document.querySelector('#usernameValidationFeedback').style.display = 'block';
			}else{
				nmCheck = true;
				document.querySelector('#username').className = 'table_input is-valid';
				document.querySelector('#usernameValidationFeedback').innerHTML = '';
				document.querySelector('#userNMSecondValiation').style.display = 'none';
// 				document.querySelector('#usernameValidationFeedback').style.display = 'none';
			}
			changeBtn();
		});
		
		
		//이메일 확인
		if(document.querySelector('#email')) document.querySelector('#email').addEventListener('keyup',function(el) {
			var emailCheck = RegExp(/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i);
			var email = document.querySelector('#EMAIL').value;
			if(!emailCheck.test(email)){
				document.querySelector('#email').className = 'table_input is-invalid';
				document.querySelector('#emailValidationFeedback').innerHTML = '이메일 형식을 확인하세요.';
				document.querySelector('#emailValidationFeedback').style.display = 'block';
				document.querySelector('#emailDuplicate_check').disabled = true;
				emailCheck = false;
			}else if(emailDupChk == false){
				document.querySelector('#email').className = 'table_input is-invalid';
				document.querySelector('#emailValidationFeedback').innerHTML = '이메일 중복 검사가 필요합니다.';
				document.querySelector('#emailValidationFeedback').style.display = 'block';
				document.querySelector('#emailDuplicate_check').disabled = false;
				emailCheck = false;
			}else{
				document.querySelector('#emailValidationFeedback').style.display = 'none';
				document.querySelector('#email').className = 'table_input is-valid';
				emailCheck = true;
			}
			changeBtn();
		});
		
		//휴대폰 전화번호 확인
		if(document.querySelector('#phone')) document.querySelector('#phone').addEventListener('keyup',function(el) {
			var number = document.querySelector('#phone').value;
			if(!isTelFormat(number) && !isHpFormat(number)){
				document.querySelector('#phone').className = 'table_input is-invalid';
				document.querySelector('#cellPhoneValidationFeedback').innerHTML = '휴대전화번호 형식을 확인하세요.';
				document.querySelector('#cellPhoneValidationFeedback').style.display = 'block';
				cpCheck = false;
			}else{
				document.querySelector('#cellPhoneValidationFeedback').style.display = 'none';
				document.querySelector('#phone').className = 'table_input is-valid';
				cpCheck = true;
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
