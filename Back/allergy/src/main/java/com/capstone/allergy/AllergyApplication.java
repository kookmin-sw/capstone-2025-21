package com.capstone.allergy;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class AllergyApplication {

	public static void main(String[] args) {
		SpringApplication.run(AllergyApplication.class, args);
	}

}
