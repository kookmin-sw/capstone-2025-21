package com.capstone.allergy.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "회원가입 시 아이디 및 비밀번호 입력을 위한 DTO")
public class SignupCredentialRequest {

    @Schema(description = "사용자 아이디", example = "testuser123")
    private String username;

    @Schema(description = "비밀번호", example = "password123!")
    private String password;

    @Schema(description = "비밀번호 확인", example = "password123!")
    private String confirmPassword;
}
