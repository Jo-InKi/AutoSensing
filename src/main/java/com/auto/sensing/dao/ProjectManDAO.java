package com.auto.sensing.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.auto.sensing.vo.ProjectManVO;
import com.auto.sensing.vo.ProjectVO;

@Repository("ProjectManDAO")
public class ProjectManDAO {
    @Autowired
    @Qualifier("SqlSessionTemplate")
    private SqlSessionTemplate sqlSession;
    
    public List<ProjectManVO> selectProjectListByuserid(String userid) {
    	return sqlSession.selectList("ProjectManMapper.selectProjectListByuserid", userid);
    }
    public List<ProjectVO> selectProjectListAssign(String userid) {
    	return sqlSession.selectList("ProjectManMapper.selectProjectListAssign", userid);
    }
    public List<ProjectVO> selectProjectListNotAssign(String userid) {
    	return sqlSession.selectList("ProjectManMapper.selectProjectListNotAssign", userid);
    }
    
    public int assignProject(ProjectManVO param) {
    	return sqlSession.insert("ProjectManMapper.assignProject", param);
    }
    
    public int deassignProject(ProjectManVO param) {
    	return sqlSession.delete("ProjectManMapper.deassignProject", param);
    }
}
