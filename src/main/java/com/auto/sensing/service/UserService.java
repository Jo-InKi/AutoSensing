package com.auto.sensing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auto.sensing.dao.UserDAO;
import com.auto.sensing.dto.UserLoginDTO;
import com.auto.sensing.vo.PageVO;
import com.auto.sensing.vo.UserVO;

@Service
public class UserService {

	@Autowired
	UserDAO userDAO;
	
    public UserVO checkPassword (UserLoginDTO user) {
    	return userDAO.checkPassword(user);
    }
    
    public List<UserVO> selectAllUsers () {
    	return userDAO.selectAllUsers();
    }
    
    public List<UserVO> selectUserListByGrade (String grade) {
    	return userDAO.selectUserListByGrade(grade);
    }
    
    public List<UserVO> selectUserListByPage (PageVO page) {
    	return userDAO.selectUserListByPage(page);
    }
    
    public int selectUserCntByPage (PageVO page) {
    	return userDAO.selectUserCntByPage(page);
    }
}
