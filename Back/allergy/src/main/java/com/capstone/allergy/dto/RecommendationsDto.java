package com.capstone.allergy.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationsDto {

    @JsonProperty("menu_name")
    private String menuName;

    private double similarity;

    // JSON 응답에서 'similarity' 키로 퍼센트 값 반환
    @JsonProperty("similarity")
    public double getSimilarityAsPercent() {
        return Math.round(similarity * 1000.0) / 10.0; // 소수점 한 자리까지
    }

    @Override
    public String toString() {
        return "RecommendedMenuDto{" +
                "menu_name='" + menuName + '\'' +
                ", similarity=" + similarity +
                '}';
    }
}
