package com.auto.sensing.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.auto.sensing.service.LocationService;
import com.auto.sensing.service.ProjectManService;
import com.auto.sensing.service.ProjectService;
import com.auto.sensing.service.SensorService;
import com.auto.sensing.service.UserService;
import com.auto.sensing.vo.UserVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class UserController {

	@Autowired
	ProjectService projectService;
	
	@Autowired
	ProjectManService projectManService;
	
	@Autowired
	LocationService locationService;
	
	@Autowired
	SensorService sensorService;
	
	@Autowired
	UserService userService;
	
	@GetMapping("/user/project/setting")
	public ModelAndView ProjectSettingView(ModelAndView model, HttpSession session) {
		List<UserVO> userList = userService.selectUserListByGrade("0003");
		System.out.println(userList);
		model.addObject("userList", userList);
		model.setViewName("/user/projectManage");
		return model;
	}
	
	@GetMapping("/user/list")
	public ModelAndView UserListView(ModelAndView model, HttpSession session) {
		List<UserVO> userList = userService.selectAllUsers();
		System.out.println(userList);
		model.addObject("userList", userList);
		model.setViewName("/user/userlist");
		return model;
	}
}
