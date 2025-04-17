package com.capstone.allergy.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "로그인 응답 DTO")
public class LoginResponse {

    @Schema(description = "JWT 토큰", example = "eyJhbGciOiJIUz...")
    private String token;

    @Schema(description = "사용자 ID", example = "1")
    private Long userId;

    @Schema(description = "사용자 이름", example = "testuser123")
    private String username;
}

