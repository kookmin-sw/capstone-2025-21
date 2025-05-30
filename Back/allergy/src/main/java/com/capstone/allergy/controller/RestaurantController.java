package com.capstone.allergy.controller;

import com.capstone.allergy.domain.User;
import com.capstone.allergy.dto.CommonResponse;
import com.capstone.allergy.dto.RestaurantResponseDto;
import com.capstone.allergy.jwt.CustomUserDetails;
import com.capstone.allergy.service.RestaurantService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/restaurant")
@RequiredArgsConstructor
@Tag(name = "맛집 추천 API", description = "사용자 선호 음식 기반 맛집 정보를 제공합니다.")
public class RestaurantController {

    private final RestaurantService restaurantService;

    @Operation(
            summary = "선호 음식 기반 맛집 추천",
            description = """
            JWT 인증된 사용자의 선호 음식 목록을 기반으로 맛집 리스트를 보여줍니다.
            
            - Authorization: Bearer <JWT 토큰>
            - <img src={`https://menu-api.myserver.com/restaurant-images/restaurant001.jpg`} alt="비빔밥 맛집" />
            - 위처럼 사용가능
            """,
            security = @SecurityRequirement(name = "bearerAuth"),
            responses = {
                    @ApiResponse(responseCode = "200", description = "추천 맛집 리스트 반환 성공",
                            content = @Content(mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(value = """
                                    {
                                      "success": true,
                                      "message": "추천 맛집 조회 성공",
                                      "data": [
                                        {
                                          "foodName": "불고기",
                                          "restaurantName": "한식당 불고기명가",
                                          "address": "서울특별시 강남구 도산대로 123",
                                          "rating": 4.5,
                                          "imageUrl": "/restaurant-images/restaurant001.jpg",
                                          "homepageUrl": "https://www.google.com/maps/search/?api=1&query=한식당+불고기명가+서울특별시+강남구+도산대로+123"
                                        },
                                        {
                                          "foodName": "비빔밥",
                                          "restaurantName": "전주비빔밥마을",
                                          "address": "서울특별시 종로구 세종로 456",
                                          "rating": 4.6,
                                          "imageUrl": "/restaurant-images/restaurant002.jpg",
                                          "homepageUrl": "https://www.google.com/maps/search/?api=1&query=전주비빔밥마을+서울특별시+종로구+세종로+456"
                                        }
                                      ]
                                    }
                                    """)
                            )
                    )
            }
    )
    @GetMapping("/recommend")
    public CommonResponse<List<RestaurantResponseDto>> getRecommendedPlaces(
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        User user = userDetails.getUser();
        List<RestaurantResponseDto> recommendedPlaces = restaurantService.getRecommendedPlaces(user);

        return CommonResponse.<List<RestaurantResponseDto>>builder()
                .success(true)
                .message("추천 맛집 조회 성공")
                .data(recommendedPlaces)
                .build();
    }
}
