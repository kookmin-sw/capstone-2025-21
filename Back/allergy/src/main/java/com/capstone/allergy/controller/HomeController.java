package com.capstone.allergy.controller;

import com.capstone.allergy.dto.HomeResponseDto;
import com.capstone.allergy.jwt.CustomUserDetails;
import com.capstone.allergy.service.HomeService;
import io.swagger.v3.oas.annotations.Operation;
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

    @GetMapping
    @Operation(
            summary = "추천 음식 리스트 조회",
            description = "JWT를 통해 로그인한 사용자의 선호 데이터를 기반으로 추천된 한국 음식 리스트를 반환합니다.",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    public ResponseEntity<HomeResponseDto> getHome(
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        Long userId = userDetails.getUser().getId(); // 사용자 ID 추출
        HomeResponseDto response = homeService.getRecommendedMenus(userId);
        return ResponseEntity.ok(response);
    }
}
