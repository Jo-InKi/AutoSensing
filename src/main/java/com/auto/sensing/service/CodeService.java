package com.auto.sensing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.auto.sensing.dao.CodeDAO;
import com.auto.sensing.vo.CodeVO;

@Service
public class CodeService {

	@Autowired
	private CodeDAO codeDAO;
	
    public List<CodeVO> selectCodeListByClass(String classification) {
    	return codeDAO.selectCodeListByClass(classification);
    }

}
