package com.auto.sensing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auto.sensing.dao.ProjectManDAO;
import com.auto.sensing.vo.ProjectManVO;
import com.auto.sensing.vo.ProjectVO;

@Service
public class ProjectManService {

	@Autowired
	ProjectManDAO projectManDAO;
	
    public List<ProjectManVO> selectProjectListByuserid(String userid) {
    	return projectManDAO.selectProjectListByuserid(userid);
    }
    
    public List<ProjectVO> selectProjectListAssign(String userid) {
    	return projectManDAO.selectProjectListAssign(userid);
    }

    public List<ProjectVO> selectProjectListNotAssign(String userid) {
    	return projectManDAO.selectProjectListNotAssign(userid);
    }
    
    public int assignProject(ProjectManVO param) {
    	return projectManDAO.assignProject(param);
    }
    
    public int deassignProject(ProjectManVO param) {
    	return projectManDAO.deassignProject(param);
    }
}
