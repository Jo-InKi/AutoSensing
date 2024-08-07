package com.auto.sensing.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auto.sensing.dao.SensorDAO;
import com.auto.sensing.dto.SensorCompanyDTO;
import com.auto.sensing.dto.SensorDTO;
import com.auto.sensing.dto.SensorReportDTO;

@Service
public class SensorService {
	
	@Autowired
	private SensorDAO sensorDAO;

	public List <SensorDTO> getSensorList(String projectid)	{
		return sensorDAO.selectSensorList(projectid);
	}
	
	public List <SensorDTO> getSensorList(int location_sn)	{
		return sensorDAO.selectSensorList(location_sn);
	}
	
	public List <SensorReportDTO> getSensorReport (String sensorid, long channel, String sdatetime, String edatetime)	{
		return sensorDAO.getSensorReport(sensorid, channel, sdatetime, edatetime);
	}

	public long insertSensor(SensorDTO sensorDTO)	{
		return sensorDAO.insertSensor(sensorDTO);
	}

	public long updateSensor(SensorDTO sensorDTO)	{
		return sensorDAO.updateSensor(sensorDTO);
	}

	public SensorDTO selectSensor (String projectid, String sensorid, long channel)	{
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
