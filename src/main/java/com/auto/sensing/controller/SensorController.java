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
import javax.servlet.http.HttpServletResponse;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.auto.sensing.dto.ExcelReportDTO;
import com.auto.sensing.dto.MessageDTO;
import com.auto.sensing.dto.SensorCompanyDTO;
import com.auto.sensing.dto.UserInfoDTO;
import com.auto.sensing.service.LocationService;
import com.auto.sensing.service.ProjectService;
import com.auto.sensing.service.SensorService;
import com.auto.sensing.utils.ExcelUtils;
import com.auto.sensing.vo.LocationVO;
import com.auto.sensing.vo.PageDTO;
import com.auto.sensing.vo.PageVO;
import com.auto.sensing.vo.ProjectVO;
import com.auto.sensing.vo.SearchVO;
import com.auto.sensing.vo.SensorVO;
import com.auto.sensing.vo.SensorReportVO;

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
	
	@Autowired
    private final ExcelUtils excelUtils;

	
	@GetMapping("/sensor/sensorlist")
	public String ViewSensorList (@RequestParam("page") int num, @RequestParam("amount") int amount, PageVO page, Model model, HttpSession httpSession)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		
		if (num == 0) {
			num = 1;
		}

		page.setPageNum(num);
		page.setAmount(amount);
		
		List<SensorVO> sl = sensorService.selectSensorListByPage(page);
		model.addAttribute("sensorList", sl);
		model.addAttribute("pageMaker", new PageDTO(sensorService.selectSensorCntByPage(page), 5, page));

		return "sensor/sensorlist";
	}
	
	@GetMapping("/sensor/list")
	public @ResponseBody List<SensorVO> getSensorList (Model model, HttpSession httpSession)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		List<SensorVO> sl = sensorService.getSensorList(null);
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
		
		List<SensorVO> sl = sensorService.getSensorList(null);
		// 우측 sidebar는 무조건 들어가므로 여기를 통과
		model.addAttribute("sensorlist", sl);
		List<ProjectVO> projectList = projectService.getProjectList(null);
		model.addAttribute("projectlist", projectList);

		return "sensor/sensorManage";
	}
	
	@GetMapping("/sensor/register")
	public String viewRegisterSensor(HttpSession httpSession, Model model)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
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
		model.addAttribute("locationList", locationList);
		
		return "/sensor/sensorAdd";
	}
	@PostMapping("/sensor/register.do")
	public String RegisterSensor (@ModelAttribute("registersensor") SensorVO sensorDTO, Model model, HttpSession httpSession, RedirectAttributes re)	{
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
		SensorVO sensorDTO = sensorService.selectSensor(ui.getProjectid(), sensorid, channel);
		model.addAttribute("sensors", sensorDTO);
		return "sensor/update";
	}
	
	@GetMapping("/sensor/edit")
	public String viewEditSensor (@RequestParam("sensorid") String sensorid, @RequestParam("channel") long channel, Model model, HttpSession httpSession)	{
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		SensorVO sensor = sensorService.selectSensor(ui.getProjectid(), sensorid, channel);
		model.addAttribute("sensor", sensor);
		
		List<LocationVO> locationList = locationService.selectLocationList(sensor.getProjectid());
		System.out.println("sensorAdd > locationList : " + locationList);
		
		model.addAttribute("locationList", locationList);
		
		return "/sensor/sensorEdit";
	}
	
	
	@PostMapping ("/sensor/update.do")
	public String UpdateSensor (@ModelAttribute("updatesensor") SensorVO sensorDTO, Model model, HttpSession httpSession)	{
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
	public String viewDetailDashBoard(@RequestParam(value = "sensorid", required = true) String sensorid, @RequestParam(value = "channel", required = true) Long channel,
			@RequestParam(value = "sdatetime", required = false) String sdatetime, @RequestParam(value = "edatetime", required = false) String edatetime,
			@RequestParam(value = "time", required = false, defaultValue = "") String time, @RequestParam(value = "intervalday", required = false, defaultValue = "0") Integer intervalday,
			@RequestParam("page") int num, @RequestParam("amount") int amount, PageVO page, Model model, HttpSession httpSession) {
		System.out.println("viewDetailDashBoard >>>>>>>> " + sensorid + " : " + channel);
		UserInfoDTO ui = (UserInfoDTO)httpSession.getAttribute("userinfo");
		if (ui == null)	{
			// login전이므로 접근실패 처리해야함
			return "redirect:/";
		}
		
		if (num == 0) {
			num = 1;
		}

		page.setPageNum(num);
		page.setAmount(amount);
		
		System.out.println("<><><>" + time + " : " + intervalday);
		
		// 센서 정보
		SensorVO sensor = sensorService.selectSensor(null, sensorid, channel);
		System.out.println(">>>>("+ui.getProjectid()+")" + sensor);
		model.addAttribute("sensor", sensor);
		String calcString = sensor.getCalcstring();


		// 조회기간 설정
		if(sdatetime == null || edatetime == null) {
			LocalDateTime now = LocalDateTime.now().plus(-1, ChronoUnit.HOURS);
			edatetime = now.format (DateTimeFormatter.ofPattern("yyyy-MM-dd HH:00"));
			sdatetime = now.plus(-10, ChronoUnit.DAYS).format (DateTimeFormatter.ofPattern("yyyy-MM-dd HH:00"));
		}

		SearchVO search = new SearchVO();
		search.setSensorid(sensorid);
		search.setChannel(channel);
		search.setSdatetime(sdatetime);
		search.setEdatetime(edatetime);
		search.setTime(time);
		search.setIntervalday(intervalday);
		page.setSearch(search);
		
		System.out.println(">>>>>>>>>>>>" + page.getSearch());
		
		// Chart Data
		List<SensorReportVO> sensorReport = sensorService.getSensorReport(sensorid, channel, sdatetime, edatetime);
		System.out.println(sensorReport.toString());
		System.out.println("sensorReport : " + sensorid + ", "+ channel + ", "+ sdatetime + ", "+ edatetime + ", " + calcString);
		
		List<SensorReportVO> sensorChart = new ArrayList<SensorReportVO>();

		ScriptEngineManager mgr = new ScriptEngineManager();
		ScriptEngine engine = mgr.getEngineByName("JavaScript");
		for (SensorReportVO sr : sensorReport)	{
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
			sensorChart.add(sr);
		}
		System.out.println(sensorChart.toString());
		model.addAttribute("sensorChart", sensorChart);

		// 센서 데이터 페이지
		sensorReport = sensorService.selectSensorReportByPage(page);
		System.out.println(sensorReport.toString());
		System.out.println("sensorReport : " + sensorid + ", "+ channel + ", "+ sdatetime + ", "+ edatetime + ", " + calcString);
		
		List<SensorReportVO> sensorData = new ArrayList<SensorReportVO>();

		for (SensorReportVO sr : sensorReport)	{
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
			sensorData.add(sr);
		}
		System.out.println(sensorData.toString());
		model.addAttribute("sensorData", sensorData);
		model.addAttribute("pageMaker", new PageDTO(sensorService.selectSensorReportCntByPage(page), 5, page));

		
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
	
	
	 @GetMapping("/sensor/excel/download")
    public void excelDownLoad(@RequestParam(value = "sensorid", required = true) String sensorid,
			@RequestParam(value = "channel", required = true) Long channel, HttpServletResponse response) {
		 
			SensorVO sensor = sensorService.selectSensor(null, sensorid, channel);
			String name = sensor.getSensorname();
			String calcString = sensor.getCalcstring();
			// sensor하나에 대한 내용 표기 해야 함
			System.out.println(sensorid + "+" + channel);
			
			LocalDateTime now = LocalDateTime.now().plus(-1, ChronoUnit.HOURS);
			// todo : 현재는 DEFAULT상태 filter가 들어오면 들어온 STRING을사용해야함
			String edatetime = now.format (DateTimeFormatter.ofPattern("yyyy-MM-dd HH:00:00"));
			String sdatetime = now.plus(-10, ChronoUnit.DAYS).format (DateTimeFormatter.ofPattern("yyyy-MM-dd HH:00:00"));
			List<SensorReportVO> sensorReport = sensorService.getSensorReport(sensorid, channel, sdatetime, edatetime);
			System.out.println(sensorReport.toString());
			System.out.println("sensorReport : " + sensorid + ", "+ channel + ", "+ sdatetime + ", "+ edatetime + ", " + calcString);
			
			List<ExcelReportDTO> report = new ArrayList<ExcelReportDTO>();
			for (SensorReportVO sr : sensorReport)	{
				report.add(new ExcelReportDTO(name, sr));
			}
			
			excelUtils.sensorExcelDownload(report, response);

    }
}
