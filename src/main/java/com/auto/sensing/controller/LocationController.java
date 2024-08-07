package com.auto.sensing.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.auto.sensing.dto.LocationDTO;
import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.service.LocationService;
import com.auto.sensing.service.ProjectManService;
import com.auto.sensing.service.ProjectService;
import com.auto.sensing.vo.LocationVO;
import com.auto.sensing.vo.PageVO;
import com.auto.sensing.vo.ProjectVO;
import com.auto.sensing.vo.SearchVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class LocationController {

	@Autowired
	ProjectService projectService;
	
	@Autowired
	ProjectManService projectManService;
	
	@Autowired
	LocationService locationService;
	
	@GetMapping("/location/list.do")
	public ModelAndView viewLocationList(@RequestParam("page") int num, PageVO page, HttpSession session, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView();
		UserInfoDTO ui = (UserInfoDTO)session.getAttribute("userinfo");

		if(num == 0) {
			num = 1;
		}
		
		page.setPageNum(num);
		page.setSearch(new SearchVO());
		
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			mav.setViewName("/login");
			return mav;
		}
		
		
		System.out.println(">>> ui : " + ui);
		List<ProjectVO> projectList = new ArrayList<ProjectVO>();
		if(ui.getGrade().equals("0001")) {
			//최고 관리자
			projectList.addAll(projectService.getProjectList(null));
		} else {
			// 프로젝트 관리자
			projectList.addAll(projectManService.selectProjectListAssign(ui.getUserid()));
		}
		
		List<LocationDTO> locationList = new ArrayList<LocationDTO>();
		
		System.out.println(projectList);
		
		for(ProjectVO project : projectList) {
			List<LocationVO> locations = locationService.selectLocationList(project.getProjectid());
			System.out.println("locations : " + project.getProjectid() +" : " + locations);
			if(locations == null)	continue;
			for(LocationVO location : locations) {
				LocationDTO tmp = new LocationDTO();
				tmp.setLocation_sn(location.getLocation_sn());
				tmp.setLocation_nm(location.getLocation_nm());
				tmp.setProjectid(project.getProjectid());
				tmp.setProjectname(project.getProjectname());
				locationList.add(tmp);
			}
		}
		
		System.out.println(locationList);
		// 우측 sidebar는 무조건 들어가므로 여기를 통과
		mav.addObject("username", ui.getUserid());
		mav.addObject("grade", ui.getGrade());
//		List<LocationVO> locationList = locationService.selectLocationList(ui.getProjectid());
		mav.addObject("locationList", locationList);
		mav.setViewName("location/locationlist");
		return mav;
	}
	
	@PostMapping("/location/list")
	public @ResponseBody List<LocationVO> getLocationList(@RequestParam("projectid") String projectid) {
		System.out.println("getLocationList > " + projectid);
		List<LocationVO> locationList = locationService.selectLocationList(projectid);
		System.out.println("getLocationList > locationList > " + locationList);
		return locationList;
	}
	
	@GetMapping("/location/add")
	public String viewRegisterLocation(HttpSession httpSession, Model model)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		model.addAttribute("username", ui.getUserid());
		model.addAttribute("grade", ui.getGrade());
		List<ProjectVO> projectList = projectService.getProjectList(null);
		System.out.println("projectList : " + projectList);
		model.addAttribute("projectlist", projectList);
		return "location/locationAdd";
	}
	
	@PostMapping("/location/register.do")
	public String registerLocation(@ModelAttribute("locationAddForm") LocationVO location, HttpSession session, Model model, RedirectAttributes re)	{
		UserInfoDTO ui = (UserInfoDTO)session.getAttribute("userinfo");
		
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		System.out.println("location : " + location);
		model.addAttribute("username", ui.getUserid());
		model.addAttribute("grade", ui.getGrade());
		List<ProjectVO> projectList = projectService.getProjectList(null);
		System.out.println("projectList : " + projectList);
		model.addAttribute("projectlist", projectList);
		
		locationService.insertLocation(location);
		String msg = "위치 정보를 추가하였습니다.";
		re.addFlashAttribute("successMsg", msg);
		
		return "redirect:/location/list.do?page=1&amount=10";
	}
	
	// 아이디 중복 검사
	@PostMapping("/location/duplication/check.do")
	public @ResponseBody int isDuplicated(@RequestParam("projectid") String projectid, @RequestParam("location_nm") String name) throws Exception {

		System.out.println(projectid + " : " + name);
		LocationVO param = new LocationVO();
		param.setLocation_nm(name);
		param.setProjectid(projectid);
		if (locationService.chaeckLocationName(param) > 0) {
			return 1;
		} else {
			return 0;
		}
	}
}
