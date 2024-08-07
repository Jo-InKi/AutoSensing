package com.auto.sensing.vo;

import java.io.Serializable;

import lombok.Data;

@Data
@SuppressWarnings("serial")
public class UserVO implements Serializable{
	private String userid;
	private String username;
	private String passwd;
	private String email;
	private String phone;
	private String grade;
	private String use_yn;
}
