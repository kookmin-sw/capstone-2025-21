package com.capstone.allergy.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SignupFullRequest {
    private String username;
    private String password;
    private String nationality;
    private List<String> favoriteFoods;
    private List<String> allergies;
    private String spiceLevel;
}