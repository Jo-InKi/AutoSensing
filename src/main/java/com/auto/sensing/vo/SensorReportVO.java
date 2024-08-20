package com.auto.sensing.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class SensorReportVO {
	private String	time;
	private double	aiv;
	private double	value;
}
