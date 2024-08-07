package com.auto.sensing.vo;

import java.io.Serializable;

import lombok.Data;

@Data
@SuppressWarnings("serial")
public class ProjectManVO implements Serializable {
	private String userid;
	private String projectid;
	private String projectname;
}
