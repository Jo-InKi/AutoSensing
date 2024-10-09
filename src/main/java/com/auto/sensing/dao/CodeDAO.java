package com.auto.sensing.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.auto.sensing.vo.CodeVO;

@Repository("CodeDAO")
public class CodeDAO {
    @Autowired
    @Qualifier("SqlSessionTemplate")
    private SqlSessionTemplate sqlSession;
    
    public List<CodeVO> selectCodeListByClass(String classification) {
    	return sqlSession.selectList("CodeMapper.selectCodeListByClass", classification);
    }
}
