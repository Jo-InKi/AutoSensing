package com.auto.sensing.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import com.auto.sensing.dto.MessageDTO;
import com.auto.sensing.dto.ProjectDTO;
import com.auto.sensing.dto.SensorDTO;
import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.service.LocationService;
import com.auto.sensing.service.ProjectManService;
import com.auto.sensing.service.ProjectService;
import com.auto.sensing.service.SensorService;
import com.auto.sensing.service.UserService;
import com.auto.sensing.vo.LocationVO;
import com.auto.sensing.vo.PageDTO;
import com.auto.sensing.vo.PageVO;
import com.auto.sensing.vo.ProjectVO;
import com.auto.sensing.vo.SearchVO;
import com.auto.sensing.vo.UserVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class ProjectController {

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

	@Value("${autosensing.project.uploadpath}")
	private String uploadpath;
	
	@GetMapping("project/register")
	public String ViewRegisterPage(Model model, HttpSession session) {
		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");

		if (ui == null) {
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}

		List<ProjectVO> projectList = new ArrayList<ProjectVO>();
		if (ui.getGrade().equals("0001")) {
			// 최고 관리자
			projectList.addAll(projectService.getProjectList(null));
		} else {
			// 프로젝트 관리자
			projectList.addAll(projectManService.selectProjectListAssign(ui.getUserid()));
		}

		ui.setProjectid(projectList.get(0).getProjectid());
		session.setAttribute("userinfo", ui);
		model.addAttribute("projectlist", projectList);

		List<LocationVO> locationList = locationService.selectLocationList(ui.getProjectid());
		System.out.println(locationList);
		model.addAttribute("locationList", locationList);

		Map<Integer, List<SensorDTO>> sensorList = new HashMap<Integer, List<SensorDTO>>();
		for (LocationVO location : locationList) {
			List<SensorDTO> sensors = sensorService.getSensorList(location.getLocation_sn());
			sensorList.put(location.getLocation_sn(), sensors);
		}

		// 우측 sidebar는 무조건 들어가므로 여기를 통과
		model.addAttribute("sensorList", sensorList);

		model.addAttribute("username", ui.getUserid());
		model.addAttribute("grade", ui.getGrade());

		List<UserVO> managerList = userService.selectUserListByGrade("0002");

		model.addAttribute("managerList", managerList);

		return "project/projectAdd";
	}

	@GetMapping("project/change")
	public String ProjectChange(@RequestParam("projectid") String projectid, HttpServletRequest request, Model model, HttpSession session) {
		
		
		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		ui.setProjectid(projectid);
		session.setAttribute("userinfo", ui);
		
		if (ui == null)	{
			return "redirect:/";
		} else {
			ProjectVO currentProject = projectService.selectProject(projectid, null, null);
			
			model.addAttribute("currProject", currentProject);
			System.out.println(currentProject);
			model.addAttribute("currProjectid", projectid);
			return "redirect:/construction/site";
		}
	}

	@GetMapping("/project/list")
	public String viewProjectList(@RequestParam("page") int num, @RequestParam("amount") int amount, PageVO page, HttpSession session, HttpServletRequest request, Model model) {

		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		
		if(ui== null) {
			return "redirect:/";
		}
		
		if (num == 0) {
			num = 1;
		}

		page.setPageNum(num);
		page.setAmount(amount);

		if (ui.getGrade().equals("0002")){
			// 프로젝트 관리자
			SearchVO search = new SearchVO();
			search.setKeywordType("userid");
			search.setKeyword(ui.getUserid());
			page.setSearch(search);
		}

		List<ProjectDTO> projectList = projectService.selectProjectListByPage(page);
		model.addAttribute("projectlist", projectList);
		model.addAttribute("pageMaker", new PageDTO(projectService.selectProjectCntByPage(page), 5, page));
		return "project/projectlist";
	}
	
	@GetMapping("/project/edit")
	public String viewProjectEdit(@RequestParam("projectid") String projectid, HttpSession session, HttpServletRequest request, Model model) {

		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		if(ui== null) {
			return "redirect:/";
		}
		
		ProjectVO project =  projectService.selectProject(projectid, null, null);
		List<UserVO> managerList = userService.selectUserListByGrade("0002");

		model.addAttribute("editProject", project);
		model.addAttribute("managerList", managerList);
		
		return "/project/projectEdit";
	}

	// 아이디 중복 검사
	@PostMapping("/project/duplication/check.do")
	public @ResponseBody int isDuplicated(@RequestParam(value = "projectid", required = false) String projectid,
			@RequestParam(value = "projectname", required = false) String projectname,
			@RequestParam(value = "emname", required = false) String emname) throws Exception {
		System.out.println("isDuplicated : " + projectid + " , " + projectname + " , " + emname);

		if (projectService.selectProject(projectid, projectname, emname) != null) {
			return 1;
		} else {
			return 0;
		}
	}

	@GetMapping("/project/detail")
	public @ResponseBody HashMap<String, Object> viewProjectDetailView(HttpSession session,
			@RequestParam(value = "projectid", required = true) String projectid) {
		HashMap<String, Object> ret = new HashMap<String, Object>();

		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		if (ui == null) {
			// login전이므로 접근실패 처리해야함
			return null;
		}

		System.out.println("userinfo : " + ui);
		System.out.println("projectid : " + projectid);
		session.setAttribute("userinfo", ui);

		// sidebar start
		List<SensorDTO> sl = sensorService.getSensorList(projectid);

		System.out.println(">>>>" + sl.toString());
		// 우측 sidebar는 무조건 들어가므로 여기를 통과
		ret.put("sensorlist", sl);
		// sidebar end

		// image이름 가져오기 .extanded때문에 Query를 해야 함
		ui.setProjectid(projectid);
		ProjectVO projectInfo = projectService.selectProject(ui.getProjectid(), null, null);

		ret.put("projectInfo", projectInfo);

		session.setAttribute("userinfo", ui);

		return ret;
	}

	@PostMapping("project/register.do")
	public String RegisterProject(MultipartHttpServletRequest request,
			@ModelAttribute("projectAddForm") ProjectVO projectListDTO, Model model, HttpSession session, RedirectAttributes re) {

		System.out.println(">>>>>>>>>>>>>>>>>RegisterProject" + request);
		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		if (ui == null) {
			// login전이므로 접근실패 처리해야함
			return "login";
		}

		System.out.println("projectListDTO >>>> " + projectListDTO);
		List<MultipartFile> siteImages = request.getFiles("siteImages");
		System.out.println("siteImages >>>> " + siteImages.size());

		if (uploadpath == null || uploadpath.isEmpty()) {
			uploadpath = System.getProperty("user.dir") + File.separatorChar + "image";
		}
		System.out.println("uploadpath : " + uploadpath);

		String basePath = uploadpath + File.separatorChar + projectListDTO.getProjectid();
		System.out.println("basePath : " + basePath);

		File baseDir = new File(basePath);
		if (!baseDir.exists()) {
			try {
				baseDir.mkdir();
			} catch (Exception e) {
				e.getStackTrace();
			}
		}

		StringJoiner mappath = new StringJoiner(",");

		for (MultipartFile file : siteImages) {
			if(file.isEmpty()) continue;
			String filePath = basePath + File.separatorChar + file.getOriginalFilename();
			System.out.println("filePath >>>> " + filePath);
			mappath.add(file.getOriginalFilename());
			try {
				file.transferTo(new File(filePath));
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}

		projectListDTO.setMappath(mappath.toString());

		projectService.insertProjectRegister(projectListDTO);
		
		String msg = "프로젝트를 추가하였습니다.";
		re.addFlashAttribute("successMsg", msg);

		return "redirect:/project/list?page=1&amount=10";
	}

	@GetMapping("project/update")
	public String ViewUpdateProject(@ModelAttribute("projectid") String projectid, Model model, HttpSession session) {
		ProjectVO projectListDTO;
		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		if (ui == null) {
			// login전이므로 접근실패 처리해야함
			return "login";
		}
		try {
			projectListDTO = projectService.selectProject(projectid, null, null);
			System.out.println(projectListDTO.toString());
		} catch (Exception e) {
			MessageDTO messageDTO = new MessageDTO("프로젝트를 찾을수 없습니다.", "/project/list", RequestMethod.GET, null);
			model.addAttribute("params", messageDTO);
			return "message";
		}
		model.addAttribute("title", "Project Modify");
		model.addAttribute("titlelink", "/project/list");
		model.addAttribute("project", projectListDTO);
		return "project/update";
	}

	@PostMapping("project/update.do")
	public String UpdateProject(MultipartHttpServletRequest req,
			@ModelAttribute("updateproject") ProjectVO projectListDTO, Model model, HttpSession session) {
		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		if (ui == null) {
			// login전이므로 접근실패 처리해야함
			return "login";
		}
		String saveFileName = null;
		if (req.getFiles("files").size() > 0) {
			System.out.println("file get size : " + req.getFiles("files").size());
			for (MultipartFile file : req.getFiles("files")) {
				if (file.getOriginalFilename() == "")
					continue;
				System.out.println("ORG:" + file.getOriginalFilename() + "End");
				// image 하나만 들어오는게 정상이다.
				String Extension = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
				saveFileName = projectListDTO.getProjectid() + Extension;
				File savefile = new File(saveFileName);
				System.out.println("SAVE:" + savefile);
				try {
					file.transferTo(savefile);
				} catch (IOException e) {
					e.printStackTrace();
					// 예외 처리
					System.out.println("file write failed");
				}
			}
		}
		// todo : 맵을 안바꾸게 되면 어찌 될까?
		projectListDTO.setMappath(saveFileName);
		try {
			projectListDTO.setUserid(ui.getUserid());
			System.out.println("update:" + projectListDTO.toString());
			projectService.updateProject(projectListDTO);
		} catch (Exception e) {
			MessageDTO messageDTO = new MessageDTO("프로젝트를 변경에 실패하였습니다", "/project/list", RequestMethod.GET, null);
			model.addAttribute("params", messageDTO);
			return "message";
		}
		MessageDTO messageDTO = new MessageDTO("프로젝트를 성공적으로 변경하였습니다.", "/project/list", RequestMethod.GET, null);
		model.addAttribute("params", messageDTO);
		return "message";
	}

	@GetMapping("project/delete.do")
	public String DeleteProject(@ModelAttribute("projectid") String projectid, Model model, HttpSession session) {
		UserInfoDTO ui = (UserInfoDTO) session.getAttribute("userinfo");
		if (ui == null) {
			// login전이므로 접근실패 처리해야함
			return "login";
		}
		try {
			System.out.println(projectid + "|" + ui.getUserid());
			projectService.deleteProject(projectid);
		} catch (Exception e) {
			MessageDTO messageDTO = new MessageDTO("프로젝트를 삭제에 실패하였습니다.", "/project/list", RequestMethod.GET, null);
			model.addAttribute("params", messageDTO);
			return "message";
		}
		MessageDTO messageDTO = new MessageDTO("프로젝트를 성공적으로 삭제하였습니다.", "/project/list", RequestMethod.GET, null);
		model.addAttribute("params", messageDTO);
		return "message";
	}

}
