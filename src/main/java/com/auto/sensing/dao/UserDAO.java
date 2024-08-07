package com.auto.sensing.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.auto.sensing.dto.UserLoginDTO;
import com.auto.sensing.vo.UserVO;

@Repository("UserDAO")
public class UserDAO {
    @Autowired
    @Qualifier("SqlSessionTemplate")
    private SqlSessionTemplate sqlSession;
    
    public UserVO checkPassword (UserLoginDTO user) {
    	return sqlSession.selectOne("UserMapper.checkPassword", user);
    }
    
    public List<UserVO> selectAllUsers () {
    	return sqlSession.selectList("UserMapper.selectAllUsers");
    }
    
    public List<UserVO> selectUserListByGrade (String grade) {
    	return sqlSession.selectList("UserMapper.selectUserListByGrade", grade);
    }
}
