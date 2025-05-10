package com.capstone.allergy.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ImageAnalysisResultDto {

    @JsonProperty("recommendations")
    private List<RecommendationsDto> recommendations;

    @JsonProperty("allergen")
    private Map<String, List<String>> allergen;


//    @Override
//    public String toString() {
//        return "ImageAnalysisResultDto{" +
//                "recommendedMenu=" + recommendations +
//                ", allergen=" + allergen +
//                '}';
//    }
}
