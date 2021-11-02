package com.project.client;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = "com.project")
@EntityScan(basePackages = "com.project.bean")
@EnableJpaRepositories(basePackages = "com.project.model.persistence")
public class MetroProjectSpringBootMvcUpdatedApplication {

	public static void main(String[] args) {
		SpringApplication.run(MetroProjectSpringBootMvcUpdatedApplication.class, args);
	}

}
