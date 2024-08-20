package com.auto.sensing.utils;


import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.openxml4j.exceptions.OpenXML4JException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.springframework.web.multipart.MultipartFile;

import com.auto.sensing.dto.ExcelReportDTO;

public interface ExcelUtilMethodFactory {

    void sensorExcelDownload(List<ExcelReportDTO> data, HttpServletResponse response);
    void renderSensorExcelBody(List<ExcelReportDTO> data, Sheet sheet, Row row, Cell cell);
    List<ExcelReportDTO> readSensorExcel(MultipartFile file) throws OpenXML4JException, IOException, Exception;
}