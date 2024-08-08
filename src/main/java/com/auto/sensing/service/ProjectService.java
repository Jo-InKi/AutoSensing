package com.auto.sensing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auto.sensing.dao.ProjectDAO;
import com.auto.sensing.dto.ProjectDTO;
import com.auto.sensing.vo.PageVO;
import com.auto.sensing.vo.ProjectVO;

@Service
public class ProjectService {
	
	@Autowired
	ProjectDAO projectDAO;

	public List <ProjectVO> getProjectList (String userid)	{
		return projectDAO.getProjectList(userid);
	}
	
	public long insertProjectRegister (ProjectVO projectListDTO)	{
		return projectDAO.insertProjectRegister(projectListDTO);
	}

	public ProjectVO selectProject (String projectid, String projectname, String emname)	{
		return projectDAO.selectProject(projectid, projectname, emname);
	}

	public long updateProject (ProjectVO projectListDTO)	{
		return projectDAO.updateProject(projectListDTO);
	}

	public long deleteProject (String projectid)	{
		return projectDAO.deleteProject(projectid);
	}
	
	public List <ProjectDTO> selectProjectListByPage (PageVO page)	{
		return projectDAO.selectProjectListByPage(page);
	}
	
	public int selectProjectCntByPage (PageVO page)	{
		return projectDAO.selectProjectCntByPage(page);
	}
}
