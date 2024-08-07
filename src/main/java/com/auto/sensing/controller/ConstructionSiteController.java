package com.auto.sensing.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.service.LocationService;
import com.auto.sensing.service.ProjectManService;
import com.auto.sensing.service.ProjectService;
import com.auto.sensing.service.SensorService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class ConstructionSiteController {

	@Autowired
	ProjectService projectService;

	@Autowired
	LocationService locationService;
	
	@Autowired
	SensorService sensorService;
	
	@Autowired
	ProjectManService projectManService;
	
	@GetMapping("/construction/site")
	public String viewProjectList(HttpSession session, HttpServletRequest request) {
		
		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		System.out.println("User Info : " + ui);

		return "construction/site";
	}
}
