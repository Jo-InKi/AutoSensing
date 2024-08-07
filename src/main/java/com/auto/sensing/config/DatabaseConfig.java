package com.auto.sensing.config;
import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

@Configuration
@PropertySource("classpath:./application.properties")
@MapperScan(value = "com.auto.sensing.mapper",sqlSessionFactoryRef="SqlSessionFactory")
public class DatabaseConfig {
	
	@Autowired
	private ApplicationContext applicationContext;
	
	@Value("${spring.datasource.mapper-locations}")
	private String mapperLocations;
	
	@Value("${spring.datasource.mybatis-config}")
	private String configPath;
	
	@Bean(name="DataSource")
	@Primary
	@ConfigurationProperties(prefix="spring.datasource") //appliction.properties 참고.
	public DataSource DataSource() {
		return DataSourceBuilder.create().build();
	}
	
	@Bean(name="SqlSessionFactory")
	@Primary
	public SqlSessionFactory sqlSessionFactory(@Qualifier("DataSource") DataSource DataSource) throws Exception{
		final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
		sessionFactory.setDataSource(DataSource);
		sessionFactory.setMapperLocations(applicationContext.getResources(mapperLocations)); //쿼리작성용 mapper.xml위치 설정.
		
		//Mybatis config파일 위치
		Resource myBatisConfig = new PathMatchingResourcePatternResolver().getResource(configPath);
		sessionFactory.setConfigLocation(myBatisConfig);
		return sessionFactory.getObject();
	}
	
	@Bean(name="SqlSessionTemplate")
	@Primary
	public SqlSessionTemplate sqlSessionTemplate(@Qualifier("SqlSessionFactory")SqlSessionFactory sqlSessionFactory) throws Exception{
		return new SqlSessionTemplate(sqlSessionFactory);
	}
}
