package com.auto.sensing.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.auto.sensing.dto.MessageDTO;
import com.auto.sensing.dto.SensorCompanyDTO;
import com.auto.sensing.dto.SensorDTO;
import com.auto.sensing.dto.SensorReportDTO;
import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.service.LocationService;
import com.auto.sensing.service.ProjectService;
import com.auto.sensing.service.SensorService;
import com.auto.sensing.vo.LocationVO;
import com.auto.sensing.vo.PageVO;
import com.auto.sensing.vo.ProjectVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class SensorController {

	@Autowired
	ProjectService projectService;
	
	@Autowired
	LocationService locationService;
	
	@Autowired
	private SensorService sensorService;
	
	@GetMapping("/sensor/sensorlist")
	public String ViewSensorList (@RequestParam("page") int num, PageVO page, Model model, HttpSession httpSession)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		List<SensorDTO> sl = sensorService.getSensorList(null);
		model.addAttribute("username", ui.getUserid());
		model.addAttribute("grade", ui.getGrade());
		model.addAttribute("sensorList", sl);

		return "sensor/sensorlist";
	}
	
	@GetMapping("/sensor/list")
	public @ResponseBody List<SensorDTO> getSensorList (Model model, HttpSession httpSession)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		List<SensorDTO> sl = sensorService.getSensorList(null);
		model.addAttribute("username", ui.getUserid());
		model.addAttribute("grade", ui.getGrade());
		model.addAttribute("sensorList", sl);

		return sl;
	}
	
	// 아이디 중복 검사
	@PostMapping("/sensor/duplication/check.do")
	public @ResponseBody int isDuplicated(@RequestParam(value = "sensorid") String sensorid, @RequestParam(value = "channel") String channel) throws Exception {
		System.out.println("isDuplicated : " + sensorid);

		if (sensorService.selectSensor(null, sensorid, Integer.parseInt(channel)) != null) {
			return 1;
		} else {
			return 0;
		}
	}
	
	@GetMapping("sensor/setting")
	public String SensorSettingView(Model model, HttpSession session) {
		UserInfoDTO ui = (UserInfoDTO)session.getAttribute("userinfo");
		
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		
		
		model.addAttribute("username", ui.getUserid());
		model.addAttribute("grade", ui.getGrade());
		
		List<SensorDTO> sl = sensorService.getSensorList(null);
		// 우측 sidebar는 무조건 들어가므로 여기를 통과
		model.addAttribute("sensorlist", sl);
		List<ProjectVO> projectList = projectService.getProjectList(null);
		model.addAttribute("projectlist", projectList);

		return "sensor/sensorManage";
	}
	
	@GetMapping("/sensor/register")
	public ModelAndView viewRegisterSensor(HttpSession httpSession, ModelAndView model)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			model.setViewName("redirect:/");
			return model;
		}

		List<ProjectVO> projectList = new ArrayList<ProjectVO>();

		if (ui.getGrade().equals("0001")) {
			// 최고 관리자
			projectList.addAll(projectService.getProjectList(null));
		} else if (ui.getGrade().equals("0002")) {
			// 프로젝트 관리자
			projectList.addAll(projectService.getProjectList(ui.getUserid()));
		}

		List<LocationVO> locationList = locationService.selectLocationList(projectList.get(0).getProjectid());
		System.out.println("sensorAdd > locationList : " + locationList);
		model.addObject("locationList", locationList);
		model.setViewName("sensor/sensorAdd");
		
		return model;
	}
	@PostMapping("/sensor/register.do")
	public String RegisterSensor (@ModelAttribute("registersensor") SensorDTO sensorDTO, Model model, HttpSession httpSession, RedirectAttributes re)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");

		System.out.println("sensorDTO : " + sensorDTO);

		try {
			long ret = sensorService.insertSensor(sensorDTO);
			System.out.println("ret : " + ret);
		} catch (Exception e)	{
			e.printStackTrace();
			String msg = "센서 등록에 실패하였습니다.";
			re.addFlashAttribute("errorMsg", msg);
			return "redirect:/sensor/sensorlist?page=1&amount=10";
		}

		String msg = "센서를 성공적으로 등록하였습니다..";
		re.addFlashAttribute("successMsg", msg);
		return "redirect:/sensor/sensorlist?page=1&amount=10";
	}
	
	
	@GetMapping("/sensor/update")
	public String viewUpdateSensor (@ModelAttribute("sensorid") String sensorid, @ModelAttribute("channel") long channel, Model model, HttpSession httpSession)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		model.addAttribute("title", "Sensor Update("+sensorid+":"+channel+")");
		model.addAttribute("titlelink", "/sensor/sensorlist?projectid="+ui.getProjectid());
		SensorDTO sensorDTO = sensorService.selectSensor(ui.getProjectid(), sensorid, channel);
		model.addAttribute("sensors", sensorDTO);
		return "sensor/update";
	}
	@PostMapping ("/sensor/update.do")
	public String UpdateSensor (@ModelAttribute("updatesensor") SensorDTO sensorDTO, Model model, HttpSession httpSession)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		try {
			sensorDTO.setProjectid(ui.getProjectid());
			sensorService.updateSensor(sensorDTO);
		} catch (Exception e)	{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("sensorid", sensorDTO.getSensorid());
			map.put("channel", sensorDTO.getChannel());
			
			MessageDTO messageDTO = new MessageDTO("센서 수정에 실패하였습니다.", "/sensor/update", RequestMethod.GET, map);
			model.addAttribute("params", messageDTO);
			return "message";
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put ("projectid", ui.getProjectid());

		MessageDTO messageDTO = new MessageDTO("센서를 성공적으로 수정하였습니다..", "/sensor/sensorlist", RequestMethod.GET, map);
		model.addAttribute("params", messageDTO);
		return "message";
	}
	
	@GetMapping("/sensor/delete.do")
	public String DeleteSensor(@ModelAttribute("sensorid") String sensorid, @ModelAttribute("channel") long channel, Model model, HttpSession httpSession)	{

		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("projectid", ui.getProjectid());
		try {
			System.out.println(ui.getProjectid() + "|" + ui.getUserid());
			sensorService.deleteSensor(ui.getProjectid(), sensorid, channel);
		} catch (Exception e)	{
			MessageDTO messageDTO = new MessageDTO("센서 삭제에 실패하였습니다.", "/sensor/sensorlist", RequestMethod.GET, map);
			model.addAttribute("params", messageDTO);
			return "message";
		}
		MessageDTO messageDTO = new MessageDTO("센서를 성공적으로 삭제하였습니다.", "/sensor/sensorlist", RequestMethod.GET, map);
		model.addAttribute("params", messageDTO);

		return "message";
	}
	
	@GetMapping("/sensor/detail")
	public String viewDetailDashBoard(@RequestParam(value = "sensorid", required = true) String sensorid,
			@RequestParam(value = "channel", required = true) Long channel, Model model, HttpSession httpSession) {
		System.out.println("viewDetailDashBoard >>>>>>>> " + sensorid + " : " + channel);
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "login";
		}
		String projectid = ui.getProjectid();
		

		SensorDTO sensor = sensorService.selectSensor(null, sensorid, channel);
		System.out.println(">>>>("+projectid+")" + sensor);
		// 우측 sidebar는 무조건 들어가므로 여기를 통과
		model.addAttribute("sensor", sensor);

		String name = sensor.getSensorname();
		String calcString = sensor.getCalcstring();
		model.addAttribute("sensorname", name);
		// sensor하나에 대한 내용 표기 해야 함
		System.out.println(sensorid + "+" + channel);
		
		ProjectVO project = projectService.selectProject(projectid, null, null);
		
		model.addAttribute("projectname", project.getProjectname());
		
		LocalDateTime now = LocalDateTime.now().plus(-1, ChronoUnit.HOURS);
		// todo : 현재는 DEFAULT상태 filter가 들어오면 들어온 STRING을사용해야함
		String edatetime = now.format (DateTimeFormatter.ofPattern("yyyy-MM-dd HH:00:00"));
		String sdatetime = now.plus(-10, ChronoUnit.DAYS).format (DateTimeFormatter.ofPattern("yyyy-MM-dd HH:00:00"));
		List<SensorReportDTO> sensorReport = sensorService.getSensorReport(sensorid, channel, sdatetime, edatetime);
		System.out.println(sensorReport.toString());
		System.out.println("sensorReport : " + sensorid + ", "+ channel + ", "+ sdatetime + ", "+ edatetime + ", " + calcString);
		
		List<SensorReportDTO> report = new ArrayList<SensorReportDTO>();

		ScriptEngineManager mgr = new ScriptEngineManager();
		ScriptEngine engine = mgr.getEngineByName("JavaScript");
		for (SensorReportDTO sr : sensorReport)	{
			if (calcString == null)	sr.setValue(sr.getAiv());
			else	{
				String calcStr = calcString.replaceAll("\\$X", Double.toString(sr.getAiv()));
				try {
					double calcValue = Double.parseDouble(engine.eval(calcStr).toString());
					sr.setValue(calcValue);
				} catch (ScriptException e)	{
					e.printStackTrace();
					sr.setValue(sr.getAiv());
				}
			}
			report.add(sr);
		}
		System.out.println(report.toString());
		model.addAttribute("username", ui.getUserid());
		model.addAttribute("grade", ui.getGrade());
		model.addAttribute("sensorReport", report);
		return "sensor/sensorDetail";
	}
	
	@GetMapping("/sensor/companysensor")
	@ResponseBody
	public List<SensorCompanyDTO> viewCompanySensorList(@RequestParam(value = "name", required = true) String companycode, Model model) {
		System.out.println ("company code : "+companycode);
		List <SensorCompanyDTO> sensorCompany = sensorService.selectCompanySensor(companycode);
//		model.addAttribute("sensorlist", sensorCompany);
		System.out.println (sensorCompany);
		return sensorCompany;
	}

}
