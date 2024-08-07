package com.auto.sensing.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.auto.sensing.vo.LocationVO;

@Repository("LocationDAO")
public class LocationDAO {
    @Autowired
    @Qualifier("SqlSessionTemplate")
    private SqlSessionTemplate sqlSession;
    
    public List<LocationVO> selectLocationList(String projectid) {
    	return sqlSession.selectList("LocationMapper.selectLocationList", projectid);
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

}
