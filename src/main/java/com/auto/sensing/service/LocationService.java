package com.auto.sensing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auto.sensing.dao.LocationDAO;
import com.auto.sensing.dto.LocationDTO;
import com.auto.sensing.vo.LocationVO;
import com.auto.sensing.vo.PageDTO;
import com.auto.sensing.vo.PageVO;

@Service
public class LocationService {

	@Autowired
	LocationDAO locationDAO;
	
    public List<LocationVO> selectLocationList(String projectid) {
    	return locationDAO.selectLocationList(projectid);
    }
    
    public LocationVO selectLocation(int location_sn) {
    	return locationDAO.selectLocation(location_sn);
    }

    public int insertLocation(LocationVO location) {
    	return locationDAO.insertLocation(location);
    }

    public int updateLocation(LocationVO location) {
    	return locationDAO.updateLocation(location);
    }
    
    public int chaeckLocationName(LocationVO location) {
    	return locationDAO.chaeckLocationName(location);
    }
    
    public List<LocationDTO> selectLocationListByPage(PageVO page) {
    	return locationDAO.selectLocationListByPage(page);
    }

    public int selectLocationCntByPage(PageVO page) {
    	return locationDAO.selectLocationCntByPage(page);
    }
}
