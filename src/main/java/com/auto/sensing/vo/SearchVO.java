package com.auto.sensing.vo;

import lombok.Data;

import java.io.Serializable;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

import javax.validation.constraints.PastOrPresent;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;

@SuppressWarnings("serial")
@Data
public class SearchVO implements Serializable {
    private String keyword;
    private String keywordType;
    private String group;
    private String userStatus;
    private String userRestrict;
    private String type;
    private String ctgy;
    private String startTime;
    private String endTime;
    private String ip;
    private String ipType;
    private String certStartTime;
    private String certEndTime;
    
    
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
