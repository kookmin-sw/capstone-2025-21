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

    @Schema(description = "평점", example = "4.5")
    private Double rating;

    @Schema(description = "대표 이미지 URL", example = "/uploads/restaurant001.jpg")
    private String imageUrl;

    @Schema(description = "홈페이지 주소 또는 구글 지도 링크", example = "https://www.google.com/maps/search/?api=1&query=전주비빔밥집+서울+종로구+율곡로+10")
    private String homepageUrl;
}
