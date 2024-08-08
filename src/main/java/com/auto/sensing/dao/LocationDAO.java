package com.auto.sensing.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.auto.sensing.dto.LocationDTO;
import com.auto.sensing.vo.LocationVO;
import com.auto.sensing.vo.PageVO;

@Repository("LocationDAO")
public class LocationDAO {
    @Autowired
    @Qualifier("SqlSessionTemplate")
    private SqlSessionTemplate sqlSession;
    
    public List<LocationVO> selectLocationList(String projectid) {
    	return sqlSession.selectList("LocationMapper.selectLocationList", projectid);
    }
    
    public LocationVO selectLocation(int location_sn) {
    	return sqlSession.selectOne("LocationMapper.selectLocation", location_sn);
    }

    public int insertLocation(LocationVO location) {
    	return sqlSession.insert("LocationMapper.insertLocation", location);
    }

    public int updateLocation(LocationVO location) {
    	return sqlSession.update("LocationMapper.updateLocation", location);
    }
    
    public int chaeckLocationName(LocationVO location) {
    	return sqlSession.selectOne("LocationMapper.chaeckLocationName", location);
    }
    
    public List<LocationDTO> selectLocationListByPage(PageVO page) {
    	return sqlSession.selectList("LocationMapper.selectLocationListByPage", page);
    }

    public int selectLocationCntByPage(PageVO page) {
    	return sqlSession.insert("LocationMapper.selectLocationCntByPage", page);
    }


}
