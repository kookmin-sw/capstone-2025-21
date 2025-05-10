package com.capstone.allergy.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class MenuItemDto {

    @JsonProperty("menu_name")
    private String menuName;

    private List<List<Double>> bbox; // 각 좌표 [ [x1,y1], [x2,y2], ... ]

    @JsonProperty("has_allergy")
    private boolean hasAllergy;

    @JsonProperty("allergy_types")
    private List<String> allergyTypes;
}
