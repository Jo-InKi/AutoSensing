package com.auto.sensing.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;

@SuppressWarnings("serial")
@Data
public class SearchVO implements Serializable {
    private String keyword;
    private String keywordType;
    private String sensorid;
    private Long channel;
    private String sdatetime;
    private String edatetime;
    private String time;
    private Integer intervalday;
    private String userid;
    private String projectid;
    private String projectname;
    private String company;
    
    
    //유효성 검사 매핑
    public Map<String, String> validateHandling(Errors errors) {
		Map<String, String> validatorResult = new HashMap<>();

		for (FieldError error : errors.getFieldErrors()) {
			String validKeyName = String.format("valid_%s", error.getField());
			validatorResult.put(validKeyName, error.getDefaultMessage());
		}
		return validatorResult;
	}
}
