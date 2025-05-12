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

public class AllergenDto {

    @JsonProperty("allergen_name")
    private String allergenName;

    @JsonProperty("included_menus")
    private List<String> includedMenus;
}
