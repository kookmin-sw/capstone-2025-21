package com.capstone.allergy.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Schema(description = "회원가입 전체 요청 DTO")
public class SignupFullRequest {

    @Schema(description = "사용자 아이디", example = "testuser123")
    private String username;

    @Schema(description = "비밀번호", example = "password123!")
    private String password;

    @Schema(description = "국적 (예: 미국, USA 등)", example = "USA")
    private String nationality;

    @Schema(description = "선호하는 한식 목록", example = "[\"불고기\", \"비빔밥\"]")
    private List<String> favoriteFoods;

    @Schema(description = "알러지 정보", example = "[\"계란\", \"우유\"]")
    private List<String> allergies;

    @Schema(description = "맵기 단계 (medium, low, 1, 3 중 선택)", example = "medium")
    private String spiceLevel;
}
