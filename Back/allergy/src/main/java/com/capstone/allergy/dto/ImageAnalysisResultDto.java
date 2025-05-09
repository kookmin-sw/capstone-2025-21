package com.capstone.allergy.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ImageAnalysisResultDto {

    @JsonProperty("recommendations")
    private List<RecommendationsDto> recommendations;


    @Override
    public String toString() {
        return "ImageAnalysisResultDto{" +
                "recommendedMenu=" + recommendations +
                '}';
    }
}
