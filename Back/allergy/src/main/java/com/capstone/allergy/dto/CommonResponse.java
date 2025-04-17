package com.capstone.allergy.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "API 공통 응답 형식")
public class CommonResponse<T> {

    @Schema(description = "요청 성공 여부", example = "true")
    private boolean success;

    @Schema(description = "응답 메시지", example = "회원가입 성공")
    private String message;

    @Schema(description = "응답 데이터 (nullable 가능)", nullable = true)
    private T data;
}
