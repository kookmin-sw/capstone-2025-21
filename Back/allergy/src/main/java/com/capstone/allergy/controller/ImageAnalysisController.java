package com.capstone.allergy.controller;

import com.capstone.allergy.cache.ImagePathCache;
import com.capstone.allergy.domain.User;
import com.capstone.allergy.dto.*;
import com.capstone.allergy.jwt.CustomUserDetails;
import com.capstone.allergy.repository.UserRepository;
import com.capstone.allergy.service.ImageAnalysisService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;

import java.awt.*;

@RestController
@RequestMapping("/api/analysis")
@RequiredArgsConstructor
@Tag(name = "이미지 분석 API", description = "AI 기반 이미지 분석 및 번역 API")
public class ImageAnalysisController {

    private final ImageAnalysisService imageAnalysisService;
    private final UserRepository userRepository;
    private final ImagePathCache imagePathCache;

    @PostMapping("/analyze-image")
    @Operation(
            summary = "이미지 분석 요청",
            description = "백엔드에서 사용자 정보를 조회하고, 최근 업로드된 이미지 경로를 이용해 AI 서버에 분석 요청을 보냅니다.",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    public ResponseEntity<CommonResponse<String>> analyzeImageAndCache(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        try {
            Long userId = userDetails.getUser().getId();
            User user = userRepository.findById(userId)
                            .orElseThrow(() -> new RuntimeException("사용자 정보를 찾을 수 없습니다."));

            String imagePath = imagePathCache.getLatestImagePath(userId);
            if (imagePath == null) {
                throw new RuntimeException("업로드된 이미지가 없습니다.");
            }


            ImageAnalysisRequestDto dto = new ImageAnalysisRequestDto();
            dto.setUserId(userId);
            dto.setNationality(user.getNationality());
            dto.setFavoriteFoods(user.getFavoriteFoods());
            dto.setAllergies(user.getAllergies());
            dto.setImagePath(imagePath);

            imageAnalysisService.analyzeAndCache(dto, userId);

            return ResponseEntity.ok(
                    CommonResponse.<String>builder()
                            .success(true)
                            .message("AI 분석 요청 성공 및 결과 캐싱 완료")
                            .data("ok")
                            .build()
            );
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("AI 요청 실패: " + e.getMessage())
                            .data(null)
                            .build());
        }
    }

    @GetMapping("/analyze")
    @Operation(
            summary = "분석 결과 조회",
            description = "캐시에 저장된 분석 결과를 반환합니다."
    )
    public ResponseEntity<CommonResponse<ImageAnalysisResultDto>> getCachedAnalysis(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        try {
            Long userId = userDetails.getUser().getId();
            ImageAnalysisResultDto result = imageAnalysisService.getCachedAnalysis(userId);
            return ResponseEntity.ok(
                    CommonResponse.<ImageAnalysisResultDto>builder()
                            .success(true)
                            .message("분석 결과 조회 성공")
                            .data(result)
                            .build()
            );
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(CommonResponse.<ImageAnalysisResultDto>builder()
                            .success(false)
                            .message(e.getMessage())
                            .data(null)
                            .build());
        }
    }

    @GetMapping("/translate")
    @Operation(
            summary = "번역 결과 조회",
            description = "캐시에 저장된 번역 결과를 반환합니다."
    )
    public ResponseEntity<CommonResponse<MenuTranslationResultDto>> getCachedTranslation(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        try {
            Long userId = userDetails.getUser().getId();
            MenuTranslationResultDto result = imageAnalysisService.getCachedTranslation(userId);
            return ResponseEntity.ok(
                    CommonResponse.<MenuTranslationResultDto>builder()
                            .success(true)
                            .message("번역 결과 조회 성공")
                            .data(result)
                            .build()
            );
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(CommonResponse.<MenuTranslationResultDto>builder()
                            .success(false)
                            .message(e.getMessage())
                            .data(null)
                            .build());
        }
    }

//    @PostMapping("/analyze")
//    @Operation(
//            summary = "이미지 분석",
//            description = """
//이미지를 분석해 알러지 경고와 추천 메뉴를 반환합니다.
//
//- `Content-Type`: `application/json`
//- `Authorization`: Bearer {Token}
//""",
//            security = @SecurityRequirement(name = "bearerAuth"),
//            requestBody = @RequestBody(
//                    required = true,
//                    content = @Content(
//                            mediaType = "application/json",
//                            schema = @Schema(implementation = ImageAnalysisRequestDto.class),
//                            examples = @ExampleObject(
//                                    name = "요청 예시",
//                                    value = "{\n" +
//                                            "  \"imagePath\": \"/api/gallery/images/uuid_filename.jpg\",\n" +
//                                            "  \"nationality\": \"USA\",\n" +
//                                            "  \"favoriteFoods\": [\"비빔밥\", \"불고기\"],\n" +
//                                            "  \"allergies\": [\"계란\", \"우유\"]\n" +
//                                            "}"
//                            )
//                    )
//            ),
//            responses = {
//                    @ApiResponse(responseCode = "200", description = "분석 성공",
//                            content = @Content(
//                                    mediaType = "application/json",
//                                    schema = @Schema(implementation = CommonResponse.class),
//                                    examples = @ExampleObject(
//                                            name = "분석 결과 예시",
//                                            value = "{\n" +
//                                                    "  \"success\": true,\n" +
//                                                    "  \"message\": \"이미지 분석 성공\",\n" +
//                                                    "  \"data\": {\n" +
//                                                    "    \"recommendedMenus\": [\"김치찌개\", \"불고기\"],\n" +
//                                                    "    \"allergyWarnings\": [\"계란\"]\n" +
//                                                    "  }\n" +
//                                                    "}"
//                                    )
//                            )),
//                    @ApiResponse(responseCode = "500", description = "서버 오류",
//                            content = @Content(
//                                    mediaType = "application/json",
//                                    schema = @Schema(implementation = CommonResponse.class),
//                                    examples = @ExampleObject(
//                                            name = "서버 오류 예시",
//                                            value = "{\n" +
//                                                    "  \"success\": false,\n" +
//                                                    "  \"message\": \"ai 연결 실패\",\n" +
//                                                    "  \"data\": null\n" +
//                                                    "}"
//                                    )
//                            ))
//            }
//    )
//    public ResponseEntity<CommonResponse<ImageAnalysisResultDto>> analyzeImage(
//            @AuthenticationPrincipal CustomUserDetails userDetails,
//            @RequestBody ImageAnalysisRequestDto requestDto) {
//
//        try {
//            Long userId = userDetails.getUser().getId();
//            requestDto.setUserId(userId); // DTO에 사용자 ID 주입
//
//            ImageAnalysisResultDto result = imageAnalysisService.analyzeImage(requestDto);
//            return ResponseEntity.ok(
//                    CommonResponse.<ImageAnalysisResultDto>builder()
//                            .success(true)
//                            .message("이미지 분석 성공")
//                            .data(result)
//                            .build()
//            );
//        } catch (RuntimeException e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(CommonResponse.<ImageAnalysisResultDto>builder()
//                            .success(false)
//                            .message("ai 연결 실패")
//                            .data(null)
//                            .build());
//        }
//    }
//
//    @PostMapping("/translate")
//    @Operation(
//            summary = "이미지 번역",
//            description = """
//이미지 경로를 기반으로 메뉴를 번역합니다.
//
//- `Content-Type`: `application/json`
//- `Authorization`: Bearer {Token}
//""",
//            security = @SecurityRequirement(name = "bearerAuth"), // ✅ JWT 인증 필요 추가
//            requestBody = @RequestBody(
//                    required = true,
//                    content = @Content(
//                            mediaType = "application/json",
//                            schema = @Schema(implementation = ImagePathRequestDto.class),
//                            examples = @ExampleObject(
//                                    name = "요청 예시",
//                                    value = "{\n" +
//                                            "  \"imagePath\": \"/api/gallery/images/uuid_filename.jpg\"\n" +
//                                            "}"
//                            )
//                    )
//            ),
//            responses = {
//                    @ApiResponse(responseCode = "200", description = "번역 성공",
//                            content = @Content(
//                                    mediaType = "application/json",
//                                    schema = @Schema(implementation = CommonResponse.class),
//                                    examples = @ExampleObject(
//                                            name = "번역 결과 예시",
//                                            value = "{\n" +
//                                                    "  \"success\": true,\n" +
//                                                    "  \"message\": \"메뉴 번역 성공\",\n" +
//                                                    "  \"data\": {\n" +
//                                                    "    \"translatedMenus\": [\"Kimchi Stew\", \"Bulgogi\"]\n" +
//                                                    "  }\n" +
//                                                    "}"
//                                    )
//                            )),
//                    @ApiResponse(responseCode = "500", description = "서버 오류",
//                            content = @Content(
//                                    mediaType = "application/json",
//                                    schema = @Schema(implementation = CommonResponse.class),
//                                    examples = @ExampleObject(
//                                            name = "ai 연결 실패",
//                                            value = "{\n" +
//                                                    "  \"success\": false,\n" +
//                                                    "  \"message\": \"ai 연결 실패\",\n" +
//                                                    "  \"data\": null\n" +
//                                                    "}"
//                                    )
//                            ))
//            }
//    )
//    public ResponseEntity<CommonResponse<MenuTranslationResultDto>> translateImage(
//            @AuthenticationPrincipal CustomUserDetails userDetails, // ✅ 토큰에서 사용자 정보 추출
//            @RequestBody ImagePathRequestDto requestDto) {
//
//        try {
//            MenuTranslationResultDto result = imageAnalysisService.getTranslatedMenu(requestDto.getImagePath());
//            return ResponseEntity.ok(
//                    CommonResponse.<MenuTranslationResultDto>builder()
//                            .success(true)
//                            .message("메뉴 번역 성공")
//                            .data(result)
//                            .build()
//            );
//        } catch (RuntimeException e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(CommonResponse.<MenuTranslationResultDto>builder()
//                            .success(false)
//                            .message("ai 연결 실패")
//                            .data(null)
//                            .build());
//        }
//    }
}
