package com.auto.sensing.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Data
@ToString
public class ProjectDTO {
	private String	projectid;
	private	String	projectname;
	private	String	company;
	private	String	address;
	private	String	mappath;
	private String	emname;
	private String	phone;
	private String	email;
	private String	userid;
	private String	username;
}
