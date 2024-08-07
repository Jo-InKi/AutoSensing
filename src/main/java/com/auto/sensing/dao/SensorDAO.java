package com.auto.sensing.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.auto.sensing.dto.SensorCompanyDTO;
import com.auto.sensing.dto.SensorDTO;
import com.auto.sensing.dto.SensorReportDTO;

@Repository("SensorDAO")
public class SensorDAO {

    @Autowired
    @Qualifier("SqlSessionTemplate")
    private SqlSessionTemplate sqlSession;
	
	public List <SensorDTO> selectSensorList(String projectid)	{
		return sqlSession.selectList("SensorMapper.selectSensorListByProjectID", projectid);
	}
	
	public List <SensorDTO> selectSensorList(int location_sn)	{
		return sqlSession.selectList("SensorMapper.selectSensorListLocationSN", location_sn);
	}
	
	public List <SensorReportDTO> getSensorReport (String sensorid, long channel, String sdatetime, String edatetime)	{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("sensorid", sensorid);
		param.put("channel", channel);
		param.put("sdatetime", sdatetime);
		param.put("edatetime", edatetime);
		return sqlSession.selectList("SensorMapper.selectSensorReport", param);
	}

	public long insertSensor(SensorDTO sensorDTO)	{
		return sqlSession.insert("SensorMapper.insertSensor", sensorDTO);
	}

	public long updateSensor(SensorDTO sensorDTO)	{
		return sqlSession.update("SensorMapper.updateSensor", sensorDTO);
	}

	public SensorDTO selectSensor (String projectid, String sensorid, long channel)	{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("projectid", projectid);
		param.put("sensorid", sensorid);
		param.put("channel", channel);
		System.out.println("param : " + param);
		return sqlSession.selectOne("SensorMapper.selectSensor", param);
	}

	public long deleteSensor (String projectid, String sensorid, long channel)	{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("projectid", projectid);
		param.put("sensorid", sensorid);
		param.put("channel", channel);
		return sqlSession.delete("SensorMapper.deleteSensor", param);
	}

	public List <SensorCompanyDTO> selectSensorCompanyAll()	{
		return sqlSession.selectList("selectSensorCompanyAll");
	}

	public List <SensorCompanyDTO> selectCompanySensor(String companycode)	{
		return sqlSession.selectList("selectCompanySensor",companycode);
	}
}
