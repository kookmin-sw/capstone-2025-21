package com.capstone.allergy.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "추천 맛집 응답 DTO")
public class RestaurantResponseDto {

    @Schema(description = "음식 이름", example = "비빔밥")
    private String foodName;

    @Schema(description = "맛집 이름", example = "전주비빔밥집")
    private String restaurantName;

    @Schema(description = "맛집 주소", example = "서울 종로구 율곡로 10")
    private String address;
}
