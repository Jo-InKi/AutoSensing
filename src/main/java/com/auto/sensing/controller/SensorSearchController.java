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
public class SensorSearchController {

	@Autowired
	ProjectService projectService;
	
	@Autowired
	LocationService locationService;
	
	@Autowired
	private SensorService sensorService;

	
	@GetMapping("/sensor/search.do")
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
}
