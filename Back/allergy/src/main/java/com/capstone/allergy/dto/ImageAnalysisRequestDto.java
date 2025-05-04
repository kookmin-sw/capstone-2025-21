package com.capstone.allergy.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ImageAnalysisRequestDto {
    private String imagePath;
    private String nationality;
    private List<String> favoriteFoods;
    private List<String> allergies;

    private Long userId;  // 내부 주입용

    // 이 메서드를 명시적으로 추가
    public void setUserId(Long userId) {
        this.userId = userId;
    }
}

