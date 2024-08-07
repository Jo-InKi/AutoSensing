package com.auto.sensing.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class SensorReportDTO {
	private String	time;
	private double	aiv;
	private double	value;
}
