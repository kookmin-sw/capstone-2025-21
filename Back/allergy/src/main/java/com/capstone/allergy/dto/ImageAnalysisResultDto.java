package com.capstone.allergy.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ImageAnalysisResultDto {
    private String allergyAlert;
    private String actualSpiceLevel;
    private String recommendedMenu;

    @Override
    public String toString() {
        return "ImageAnalysisResultDto{" +
                "allergyAlert='" + allergyAlert + '\'' +
                ", spiceLevel='" + actualSpiceLevel + '\'' +
                ", recommendedMenu='" + recommendedMenu + '\'' +
                '}';
    }
}
