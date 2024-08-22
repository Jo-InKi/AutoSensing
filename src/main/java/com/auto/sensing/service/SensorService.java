package com.auto.sensing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auto.sensing.dao.SensorDAO;
import com.auto.sensing.dto.SensorCompanyDTO;
import com.auto.sensing.vo.PageVO;
import com.auto.sensing.vo.SensorVO;
import com.auto.sensing.vo.SensorReportVO;

@Service
public class SensorService {
	
	@Autowired
	private SensorDAO sensorDAO;

	public List <SensorVO> getSensorList(String projectid)	{
		return sensorDAO.selectSensorList(projectid);
	}
	
	public List <SensorVO> selectSensorListByPage(PageVO page)	{
		return sensorDAO.selectSensorListByPage(page);
	}
	
	public int selectSensorCntByPage(PageVO page)	{
		return sensorDAO.selectSensorCntByPage(page);
	}
	
	public List <SensorVO> getSensorList(int location_sn)	{
		return sensorDAO.selectSensorList(location_sn);
	}
	
	public List <SensorReportVO> getSensorReport (String sensorid, long channel, String sdatetime, String edatetime)	{
		return sensorDAO.getSensorReport(sensorid, channel, sdatetime, edatetime);
	}
	
	public List <SensorReportVO> selectSensorReportByPage (PageVO page)	{
		return sensorDAO.selectSensorReportByPage( page);
	}
	
	public int selectSensorReportCntByPage (PageVO page)	{
		return sensorDAO.selectSensorReportCntByPage(page);
	}

	public long insertSensor(SensorVO sensorDTO)	{
		return sensorDAO.insertSensor(sensorDTO);
	}

	public long updateSensor(SensorVO sensorDTO)	{
		return sensorDAO.updateSensor(sensorDTO);
	}

	public SensorVO selectSensor (String projectid, String sensorid, long channel)	{
		return sensorDAO.selectSensor(projectid, sensorid, channel);
	}

	public long deleteSensor (String projectid, String sensorid, long channel)	{
		return sensorDAO.deleteSensor(projectid, sensorid, channel);
	}

	public List <SensorCompanyDTO> selectSensorCompanyAll()	{
		return sensorDAO.selectSensorCompanyAll();
	}

	public List <SensorCompanyDTO> selectCompanySensor(String companycode)	{
		return sensorDAO.selectCompanySensor(companycode);
	}
}
