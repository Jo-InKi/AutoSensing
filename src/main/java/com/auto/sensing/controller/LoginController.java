package com.auto.sensing.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.dto.UserLoginDTO;
import com.auto.sensing.service.UserService;
import com.auto.sensing.vo.UserVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class LoginController {
	
	@Autowired
	private UserService userService;
	

	@GetMapping("/")
	public String home(Model model, HttpSession session) throws Exception {
		//세션에 저장된 사용자 정보
		UserInfoDTO user = (UserInfoDTO) session.getAttribute("userinfo");
		if (user != null) {
			return "redirect:/construction/site"; //최고 관리자 & 일반 관리자 페이지 이동
		}
		return "index";
	}
	
	@PostMapping("/login")
	public String LoginCheck (@ModelAttribute("logincheck") UserLoginDTO login, Model model, HttpSession session)	{
		
		System.out.println(login);
		
		UserVO user = userService.checkPassword(login);
		
		System.out.println("result : " + user);
		
		if(login != null && login.getUserid() != null && login.getPassword() != null && login.getPassword().equals(user.getPasswd())) {
			UserInfoDTO userInfo = new UserInfoDTO();
			userInfo.setUserid(login.getUserid());
			userInfo.setGrade(user.getGrade());
			session.setAttribute("userinfo", userInfo);
			System.out.println("Login OK: " + userInfo);
			return "redirect:/construction/site";
		} else {
			System.out.println("Login Failed");
			return "redirect:/";
		}
	}
	
	@GetMapping("/logout")
	public String Logout (Model model, HttpSession session)	{
		System.out.println("Logout......");
		session.removeAttribute("userinfo");
		return "redirect:/";
	}

}
