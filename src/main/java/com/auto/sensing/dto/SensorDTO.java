package com.auto.sensing.dto;

import java.math.BigInteger;
import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SensorDTO {
	private String sensorid;
	private long channel;
	private String sensorname;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate initdate;
	private double factor;
	private double guidel1max;
	private double guidel1min;
	private double guidel2max;
	private double guidel2min;
	private double guidel3max;
	private double guidel3min;
	private long const1;
	private long const2;
	private long const3;
	private long const4;
	private long const5;
	private long const6;
	private long const7;
	private long const8;
	private String calcstring;
	private String projectid;
	private BigInteger location_sn;
}
