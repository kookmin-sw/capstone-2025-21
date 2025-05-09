package com.capstone.allergy.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class MenuItemDto {

    private String menu_name;

    private List<List<Double>> bbox; // 각 좌표 [ [x1,y1], [x2,y2], ... ]

    private boolean has_allergy;

    private List<String> allergy_types;
}
