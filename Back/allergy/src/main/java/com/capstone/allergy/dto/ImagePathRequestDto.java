package com.capstone.allergy.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ImagePathRequestDto {

    @Schema(description = "이미지 경로", example = "/api/gallery/images/uuid_filename.jpg", required = true)
    private String imagePath;
}
