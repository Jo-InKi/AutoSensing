package com.auto.sensing.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.service.ProjectManService;
import com.auto.sensing.vo.ProjectManVO;
import com.auto.sensing.vo.ProjectVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class ProjectManController {

	@Autowired
	ProjectManService projectManService;
	
	@GetMapping("project/assign/{id}")
	public @ResponseBody Map<String, List<ProjectVO>> getAssignProjectList(@PathVariable String id, Model model, HttpSession session) {
		Map<String, List<ProjectVO>> ret = new HashMap<String, List<ProjectVO>>();
		UserInfoDTO ui = (UserInfoDTO)session.getAttribute("userinfo");
		
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return null;
		}
		List<ProjectVO> assignedList = projectManService.selectProjectListAssign(id);
		List<ProjectVO> notAssignedList = projectManService.selectProjectListNotAssign(id);
		ret.put("assignedList", assignedList);
		ret.put("notAssignedList", notAssignedList);
		
		System.out.println(ret);
		
		return ret;
	}
	
	@PostMapping("project/assign")
	public @ResponseBody String assignProject(ProjectManVO projectMan, Model model, HttpSession session) {
		int ret = projectManService.assignProject(projectMan);
		
		if(ret > 0) {
			return "success";
		} else {
			return "faile";
		}
	}
	
	@PostMapping("project/noassign")
	public @ResponseBody String notassignProject(ProjectManVO projectMan, Model model, HttpSession session) {
		int ret = projectManService.deassignProject(projectMan);
		
		if(ret > 0) {
			return "success";
		} else {
			return "faile";
		}
	}
}
