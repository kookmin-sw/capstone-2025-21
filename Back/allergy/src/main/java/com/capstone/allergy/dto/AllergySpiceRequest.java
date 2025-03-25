package com.capstone.allergy.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class AllergySpiceRequest {
    private List<String> allergies;
    private String spiceLevel; // ex: "mild", "medium", "hot"
}