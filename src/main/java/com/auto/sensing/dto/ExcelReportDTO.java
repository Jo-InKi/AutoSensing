package com.auto.sensing.dto;

import com.auto.sensing.annotation.ExcelColumn;
import com.auto.sensing.vo.SensorReportVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@Builder
@EqualsAndHashCode
@NoArgsConstructor
public class ExcelReportDTO {
    @ExcelColumn(headerName = "센서명")
	private String sensorname;
    @ExcelColumn(headerName = "측정일시")
	private String	time;
    @ExcelColumn(headerName = "측정치")
	private Double	value;
    @ExcelColumn(headerName = "변화량(mm)")
	private Double	change;
    
    public ExcelReportDTO(String sensorname, SensorReportVO data) {
    	if(sensorname != null && !sensorname.isEmpty() ) {
        	this.sensorname = sensorname;
    	}
    	
    	if(data != null) {
    		this.time = data.getTime();
    		this.value = data.getValue();
    		this.change = 0.;
    	}
    	
    }
}
