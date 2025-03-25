package com.capstone.allergy.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SignupCredentialRequest {
    private String username;
    private String password;
    private String confirmPassword;
}
