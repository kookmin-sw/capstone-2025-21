//package com.capstone.allergy.controller;
//
//import com.capstone.allergy.dto.CommonResponse;
//import com.capstone.allergy.dto.HomeResponseDto;
//import com.capstone.allergy.jwt.CustomUserDetails;
//import com.capstone.allergy.service.HomeService;
//import io.swagger.v3.oas.annotations.Operation;
//import io.swagger.v3.oas.annotations.media.Content;
//import io.swagger.v3.oas.annotations.media.ExampleObject;
//import io.swagger.v3.oas.annotations.media.Schema;
//import io.swagger.v3.oas.annotations.responses.ApiResponse;
//import io.swagger.v3.oas.annotations.security.SecurityRequirement;
//import io.swagger.v3.oas.annotations.tags.Tag;
//import lombok.RequiredArgsConstructor;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//@RestController
//@RequestMapping("/api/home")
//@RequiredArgsConstructor
//@Tag(name = "홈화면", description = "사용자 맞춤 추천 메뉴 조회 API")
//public class HomeController {
//
//    private final HomeService homeService;
//
//    @Operation(
//            summary = "추천 음식 리스트 조회",
//            description = """
//            JWT를 통해 로그인한 사용자의 선호 데이터를 기반으로 추천된 한국 음식 리스트를 반환합니다.
//
//            - Authorization: Bearer {Token}
//            - Content-Type: 없음
//            """,
//            security = @SecurityRequirement(name = "bearerAuth")
//    )
//    @ApiResponse(
//            responseCode = "200",
//            description = "추천 음식 리스트 반환 성공",
//            content = @Content(
//                    mediaType = "application/json",
//                    schema = @Schema(implementation = CommonResponse.class),
//                    examples = @ExampleObject(
//                            name = "추천 음식 리스트 예시",
//                            value = "{\n" +
//                                    "  \"success\": true,\n" +
//                                    "  \"message\": \"추천 음식 리스트 반환 성공\",\n" +
//                                    "  \"data\": {\n" +
//                                    "    \"menus\": [\"비빔밥\", \"불고기\"]\n" +
//                                    "  }\n" +
//                                    "}"
//                    )
//            )
//    )
//    @ApiResponse(
//            responseCode = "500",
//            description = "AI 서버 연결 실패",
//            content = @Content(
//                    mediaType = "application/json",
//                    schema = @Schema(implementation = CommonResponse.class),
//                    examples = @ExampleObject(
//                            name = "AI 서버 오류 예시",
//                            value = "{\n" +
//                                    "  \"success\": false,\n" +
//                                    "  \"message\": \"AI 추천 서버 연결 실패\",\n" +
//                                    "  \"data\": null\n" +
//                                    "}"
//                    )
//            )
//    )
//    @GetMapping
//    public ResponseEntity<CommonResponse<HomeResponseDto>> getHome(
//            @AuthenticationPrincipal CustomUserDetails userDetails) {
//
//        Long userId = userDetails.getUser().getId(); // 사용자 ID 추출
//
//        try {
//            HomeResponseDto response = homeService.getRecommendedMenus(userId);
//            return ResponseEntity.ok(
//                    CommonResponse.<HomeResponseDto>builder()
//                            .success(true)
//                            .message("추천 음식 리스트 반환 성공")
//                            .data(response)
//                            .build()
//            );
//        } catch (RuntimeException e) {
//            return ResponseEntity.internalServerError().body(
//                    CommonResponse.<HomeResponseDto>builder()
//                            .success(false)
//                            .message("AI 추천 서버 연결 실패: " + e.getMessage())
//                            .data(null)
//                            .build()
//            );
//        }
//    }
//}
