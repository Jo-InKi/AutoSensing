package com.auto.sensing.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
    @Value("${autosensing.project.uploadpath}")
    private String filePath1;
    
    @Value("${autosensing.project.uploadpath.test}")
    private String filePath2;
	
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        WebMvcConfigurer.super.addResourceHandlers(registry);
		String osName = System.getProperty("os.name").toLowerCase();
        if (osName.toLowerCase().contains("win")) {
        	System.out.println("windows system " + filePath2);
            registry.addResourceHandler("/map/**").addResourceLocations("file:///" + filePath2);
        } else if (osName.toLowerCase().contains("linux")) {
        	System.out.println("linux system " + filePath1);
            registry.addResourceHandler("/map/**").addResourceLocations("file:///" + filePath1);
        }

    }
}