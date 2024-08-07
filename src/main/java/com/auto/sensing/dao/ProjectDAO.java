package com.auto.sensing.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.auto.sensing.vo.PageVO;
import com.auto.sensing.vo.ProjectVO;

@Repository("ProjectDAO")
public class ProjectDAO {
    @Autowired
    @Qualifier("SqlSessionTemplate")
    private SqlSessionTemplate sqlSession;
    
	public List <ProjectVO> getProjectList (String userid)	{
		return sqlSession.selectList("ProjectMapper.selectProjectList", userid);
	}
	
	public long insertProjectRegister (ProjectVO projectListDTO)	{
		return sqlSession.insert("ProjectMapper.insertProjectRegister", projectListDTO);
	}

	public ProjectVO selectProject (String projectid, String projectname, String emname)	{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("projectid", projectid);
		param.put("projectname", projectname);
		param.put("emname", emname);
		return sqlSession.selectOne("ProjectMapper.selectProject", param);
	}

	public long updateProject (ProjectVO projectListDTO)	{
		return sqlSession.update("ProjectMapper.updateProject", projectListDTO);
	}

	public long deleteProject (String projectid)	{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("projectid", projectid);
		return sqlSession.delete("ProjectMapper.deleteProject", param);
	}
	
	public List <ProjectVO> selectProjectListByPage (PageVO page)	{
		return sqlSession.selectList("ProjectMapper.selectProjectListByPage", page);
	}
	
	public int selectProjectCntByPage (PageVO page)	{
		return sqlSession.selectOne("ProjectMapper.selectProjectCntByPage", page);
	}
}
