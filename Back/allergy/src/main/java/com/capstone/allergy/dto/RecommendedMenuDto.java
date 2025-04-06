package com.capstone.allergy.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecommendedMenuDto {
    private String name;            // 음식 이름 (예: "김치찌개")
    private String imageUrl;        // 이미지 링크 (예: "https://image...")
    private String description;     // 음식 설명 (예: "얼큰한 돼지고기 김치찌개입니다.")
    private String spicyLevel;      // 맵기 ("mild", "medium", "hot")
    private List<String> allergens; // 알러지 성분 (예: ["돼지고기", "대두"])
}