package com.auto.sensing.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.auto.sensing.dto.LocationDTO;
import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.service.LocationService;
import com.auto.sensing.service.ProjectManService;
import com.auto.sensing.service.ProjectService;
import com.auto.sensing.service.SensorService;
import com.auto.sensing.service.UserService;
import com.auto.sensing.vo.PageDTO;
import com.auto.sensing.vo.PageVO;
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
	public String ProjectSettingView(Model model, HttpSession session) {
		List<UserVO> userList = userService.selectUserListByGrade("0003");
		System.out.println(userList);
		model.addAttribute("userList", userList);

		return "/user/projectManage";
	}
	
	@GetMapping("/user/list")
	public String UserListView(@RequestParam("page") int num, @RequestParam("amount") int amount, PageVO page, Model model, HttpSession session) {
		
		UserInfoDTO ui = (UserInfoDTO)session.getAttribute("userinfo");

		if(ui== null) {
			return "redirect:/";
		}
		
		if (num == 0) {
			num = 1;
		}

		page.setPageNum(num);
		page.setAmount(amount);
		
		List<UserVO> userList = userService.selectUserListByPage(page);
		System.out.println(userList);
		model.addAttribute("userList", userList);
		model.addAttribute("pageMaker", new PageDTO(userService.selectUserCntByPage(page), 5, page));


		return "/user/userlist";
	}
	
	@GetMapping("/user/register")
	public String UserAddView(Model model, HttpSession session) {
		
		UserInfoDTO ui = (UserInfoDTO)session.getAttribute("userinfo");

		if(ui== null) {
			return "redirect:/";
		}

		return "/user/userAdd";
	}
	
	@GetMapping("/user/edit")
	public String UserEditView(@RequestParam("userid") String userid,Model model, HttpSession session) {
		
		UserInfoDTO ui = (UserInfoDTO)session.getAttribute("userinfo");

		if(ui== null) {
			return "redirect:/";
		}
		
		UserVO userinfo = userService.selectUSerByUserID(userid);
		
		model.addAttribute("user", userinfo);

		return "/user/userEdit";
	}
	
	// 아이디 중복 검사
	@PostMapping("/user/duplication/check.do")
	public @ResponseBody int isDuplicated(@RequestParam(value = "userid") String userid) throws Exception {
		System.out.println("isDuplicated : " + userid);

		if (userService.selectUSerByUserID(userid) != null) {
			return 1;
		} else {
			return 0;
		}
	}

}
