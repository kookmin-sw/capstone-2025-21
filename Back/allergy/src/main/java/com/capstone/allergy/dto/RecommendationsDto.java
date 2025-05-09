package com.capstone.allergy.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecommendationsDto {
    private String menu_name;
    private double similarity;

    @Override
    public String toString() {
        return "RecommendedMenuDto{" +
                "menu_name='" + menu_name + '\'' +
                ", similarity=" + similarity +
                '}';
    }
}
