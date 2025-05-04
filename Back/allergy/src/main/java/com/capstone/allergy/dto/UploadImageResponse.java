package com.capstone.allergy.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "이미지 업로드 응답 DTO")
public class UploadImageResponse {
    @Schema(description = "업로드된 이미지 URL", example = "/api/gallery/images/uuid_filename.jpg")
    private String url;
}
