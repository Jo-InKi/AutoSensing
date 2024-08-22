package com.auto.sensing.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.service.LocationService;
import com.auto.sensing.service.ProjectManService;
import com.auto.sensing.service.ProjectService;
import com.auto.sensing.service.SensorService;
import com.auto.sensing.vo.LocationVO;
import com.auto.sensing.vo.ProjectVO;
import com.auto.sensing.vo.SensorVO;

@ControllerAdvice
public class GlobalControllerAdvice {
	@Autowired
	ProjectService projectService;

	@Autowired
	ProjectManService projectManService;

	@Autowired
	LocationService locationService;

	@Autowired
	SensorService sensorService;
	
    @ModelAttribute
    public void addAttributes(Model model, HttpSession session) {
        UserInfoDTO userinfo = (UserInfoDTO) session.getAttribute("userinfo");
        System.out.println("GlobalControllerAdvice Userinfo : " + userinfo);
        
        if(userinfo != null) {
        	List<ProjectVO> projectList = new ArrayList<ProjectVO>();

			if (userinfo.getGrade().equals("0001")) {
				// 최고 관리자
				projectList.addAll(projectService.getProjectList(null));
			} else if (userinfo.getGrade().equals("0002")) {
				// 프로젝트 관리자
				projectList.addAll(projectService.getProjectList(userinfo.getUserid()));
			} else {
				// 일반 사용자
				projectList.addAll(projectManService.selectProjectListAssign(userinfo.getUserid()));
			}

			model.addAttribute("manProjectlist", projectList);
			
			if(userinfo.getProjectid() == null || userinfo.getProjectid().isEmpty()) {
				userinfo.setProjectid(projectList.get(0).getProjectid());
				session.setAttribute("userinfo", userinfo);
			}
			
			model.addAttribute("currProjectid", userinfo.getProjectid());
			model.addAttribute("currProject", projectService.selectProject(userinfo.getProjectid(), null, null));
			
			List<LocationVO> locationList = locationService.selectLocationList(userinfo.getProjectid());
			System.out.println("manLocationList" + locationList);
			model.addAttribute("manLocationList", locationList);
			
			Map<Integer, List<SensorVO>> sensorList = new HashMap<Integer, List<SensorVO>>();
			for(LocationVO location : locationList) {
				List<SensorVO> sensors = sensorService.getSensorList(location.getLocation_sn());
				sensorList.put(location.getLocation_sn(), sensors);
			}
			System.out.println("manSensorList" + sensorList);
			// 우측 sidebar는 무조건 들어가므로 여기를 통과
			model.addAttribute("manSensorList", sensorList);
			
			model.addAttribute("username", userinfo.getUserid());
			model.addAttribute("grade", userinfo.getGrade());
        }
    }
}