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
    private Long userId;
    private String nationality;
    private List<String> favoriteFoods;
    private List<String> allergies;
}
