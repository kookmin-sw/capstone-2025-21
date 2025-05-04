package com.capstone.allergy.controller;

import com.capstone.allergy.dto.CommonResponse;
import com.capstone.allergy.dto.HomeResponseDto;
import com.capstone.allergy.jwt.CustomUserDetails;
import com.capstone.allergy.service.HomeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/home")
@RequiredArgsConstructor
@Tag(name = "홈화면", description = "사용자 맞춤 추천 메뉴 조회 API")
public class HomeController {

    private final HomeService homeService;

    @Operation(
            summary = "추천 음식 리스트 조회",
            description = """
사용자 선호를 기반으로 음식 추천을 제공합니다.

- `Content-Type`: 필요 없음
- `Authorization`: Bearer {Token}
""",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponse(
            responseCode = "200",
            description = "추천 음식 리스트 반환 성공",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = CommonResponse.class),
                    examples = @ExampleObject(
                            name = "추천 음식 리스트 예시",
                            value = "{\n" +
                                    "  \"success\": true,\n" +
                                    "  \"message\": \"추천 음식 리스트 반환 성공\",\n" +
                                    "  \"data\": {\n" +
                                    "    \"menus\": [\"비빔밥\", \"불고기\"]\n" +
                                    "  }\n" +
                                    "}"
                    )
            )
    )
    @GetMapping
    public ResponseEntity<CommonResponse<HomeResponseDto>> getHome(
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        Long userId = userDetails.getUser().getId(); // 사용자 ID 추출
        HomeResponseDto response = homeService.getRecommendedMenus(userId);
        return ResponseEntity.ok(
                CommonResponse.<HomeResponseDto>builder()
                        .success(true)
                        .message("추천 음식 리스트 반환 성공")
                        .data(response)
                        .build()
        );
    }
}
