package com.capstone.allergy.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HomeResponseDto {
//    private List<RecommendedMenuDto> recommendedMenus;
    private List<String> menus;
}

