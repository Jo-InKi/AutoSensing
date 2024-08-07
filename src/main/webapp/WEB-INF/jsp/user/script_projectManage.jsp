<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
var currUser=null;

function userListClick(userid) {
	const url = "/project/assign/"+userid;
	$.ajax({
		type : "GET",
		url : url,
		success : function(data) {
			var assignedList = '';
			for(var ii = 0; ii < data.assignedList.length; ii++) {
				assignedList += '<button onClick="assignedListClick(this)" '
							+ 'id="'+ data.assignedList[ii].projectid +'"  value="' + data.assignedList[ii].projectid + '" name="assignedList"'
							+ 'class="list-group-item list-group-item-action">' + data.assignedList[ii].projectname + '</button>';
			}
			
			var notAssignedList = '';
			for(var ii = 0; ii < data.notAssignedList.length; ii++) {
				notAssignedList += '<button onClick="notAssignedListClick(this)"'
							+ 'id="'+ data.notAssignedList[ii].projectid +'" value="' + data.notAssignedList[ii].projectid + '" name="notAssignedList"'
							+ 'class="list-group-item list-group-item-action">' + data.notAssignedList[ii].projectname + '</button>';
			}
			
			document.querySelector('#assignedListCard').innerHTML = assignedList;
			document.querySelector('#notAssignedListCard').innerHTML = notAssignedList;
			
			currUser = userid;
			
		},
		error : function(error) {
			console.log('error', error);
			currUser = null;
		}
	});
	
}

var currentNotAssignedProject = null;
var currentAssignedProject = null;

function notAssignedListClick(project){
	var className =  project.getAttribute('class');
	var id =  project.getAttribute('id');
	
	if(currentNotAssignedProject != null) {
		console.log("이전 클릭 상태 Normal 로 변환");
		$("#"+currentNotAssignedProject.getAttribute('id')).attr('class', 'list-group-item list-group-item-action');
	}
	
	if(className == 'list-group-item list-group-item-action'){
		console.log("클릭 상태 Active 로 변환");
		$("#"+id).attr('class', 'list-group-item list-group-item-action active');
		$("#moveToRight").prop("disabled", false);
		$("#moveToLeft").prop("disabled", true);

	}
	
	if(className == 'list-group-item list-group-item-action active'){
		console.log("클릭 상태 Normal 로 변환");
		$("#"+id).attr('class', 'list-group-item list-group-item-action');
		$("#moveToRight").prop("disabled", true);
		$("#moveToLeft").prop("disabled", true);

	}
	
	currentNotAssignedProject = project;
}

function assignedListClick(project){
	console.log('assignedListClick', project);
	var className =  project.getAttribute('class');
	var id =  project.getAttribute('id');
	
	if(currentAssignedProject != null) {
		console.log("이전 클릭 상태 Normal 로 변환");
		$("#"+currentAssignedProject.getAttribute('id')).attr('class', 'list-group-item list-group-item-action');
	}
	
	if(className == 'list-group-item list-group-item-action'){
		console.log("클릭 상태 Active 로 변환");
		$("#"+id).attr('class', 'list-group-item list-group-item-action active');
		$("#moveToLeft").prop("disabled", false);
		$("#moveToRight").prop("disabled", true);

	}
	
	if(className == 'list-group-item list-group-item-action active'){
		console.log("클릭 상태 Normal 로 변환");
		$("#"+id).attr('class', 'list-group-item list-group-item-action');
		$("#moveToLeft").prop("disabled", true);
		$("#moveToRight").prop("disabled", true);

	}
	
	currentAssignedProject = project;
}

function assignedProject() {
	var className =  currentNotAssignedProject.getAttribute('class');
	var id =  currentNotAssignedProject.getAttribute('id');
	
	var userid = currUser;
	var projectid = id;
	var projectname = currentNotAssignedProject.value;
	
	$.ajax({
		type : "POST",
		url : "/project/assign",
		data : { 
			"userid" : userid,
			"projectid": projectid,
			"projectname": projectname
		},
		success : function(data) {
			console.log(data);
			currentNotAssignedProject.setAttribute('onclick', 'assignedListClick(this)');
			
			console.log("클릭 상태 Normal 로 변환");
			$("#"+id).attr('class', 'list-group-item list-group-item-action');
			
			
			document.getElementById("notAssignedListCard").removeChild(currentNotAssignedProject);
			document.getElementById("assignedListCard").appendChild(currentNotAssignedProject);
			
			currentNotAssignedProject = null;
			$("#moveToRight").prop("disabled", true);
			$("#moveToLeft").prop("disabled", true);
		},
		error : function(error) {
			console.log('error', error);
		}
	});
}

function notassignedProject() {
	
	var className =  currentAssignedProject.getAttribute('class');
	var id =  currentAssignedProject.getAttribute('id');
	
	var userid = currUser;
	var projectid = id;
	var projectname = currentAssignedProject.value;
	
	$.ajax({
		type : "POST",
		url : "/project/noassign",
		data : { 
			"userid" : userid,
			"projectid": projectid,
			"projectname": projectname
		},
		success : function(data) {
			console.log(data);
			currentAssignedProject.setAttribute('onclick', 'notAssignedListClick(this)');
			
			console.log("클릭 상태 Normal 로 변환");
			$("#"+id).attr('class', 'list-group-item list-group-item-action');
			
			
			document.getElementById("assignedListCard").removeChild(currentAssignedProject);
			document.getElementById("notAssignedListCard").appendChild(currentAssignedProject);
			
			
			currentAssignedProject = null;
			$("#moveToRight").prop("disabled", true);
			$("#moveToLeft").prop("disabled", true);
		},
		error : function(error) {
			console.log('error', error);
		}
	});

}

document.getElementById("notAssignedListCard").onclick = function(event) {
	$("#moveToRight").prop("disabled", false);
	$("#moveToLeft").prop("disabled", true);
}

document.getElementById("assignedListCard").onclick = function(event) {
	$("#moveToRight").prop("disabled", true);
	$("#moveToLeft").prop("disabled", false);
}
</script>