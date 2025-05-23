package com.capstone.allergy.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MenuTranslationResultDto {

    @JsonProperty("menu_items")
    private List<MenuItemDto> menuItems;
}
