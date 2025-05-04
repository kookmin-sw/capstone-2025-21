package com.capstone.allergy.controller;

import com.capstone.allergy.dto.*;
import com.capstone.allergy.service.ImageAnalysisService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/analysis")
@RequiredArgsConstructor
@Tag(name = "이미지 분석 API", description = "AI 기반 이미지 분석 및 번역 API")
public class ImageAnalysisController {

    private final ImageAnalysisService imageAnalysisService;

    @PostMapping("/analyze")
    @Operation(
            summary = "이미지 분석",
            description = "이미지를 분석하여 알러지와 추천 메뉴 정보를 반환합니다.",
            requestBody = @RequestBody(
                    required = true,
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = ImageAnalysisRequestDto.class),
                            examples = @ExampleObject(
                                    name = "요청 예시",
                                    value = "{\n" +
                                            "  \"imagePath\": \"/api/gallery/images/uuid_filename.jpg\",\n" +
                                            "  \"userId\": 1,\n" +
                                            "  \"nationality\": \"USA\",\n" +
                                            "  \"favoriteFoods\": [\"비빔밥\", \"불고기\"],\n" +
                                            "  \"allergies\": [\"계란\", \"우유\"]\n" +
                                            "}"
                            )
                    )
            ),
            responses = {
                    @ApiResponse(responseCode = "200", description = "분석 성공",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "분석 결과 예시",
                                            value = "{\n" +
                                                    "  \"success\": true,\n" +
                                                    "  \"message\": \"이미지 분석 성공\",\n" +
                                                    "  \"data\": {\n" +
                                                    "    \"recommendedMenus\": [\"김치찌개\", \"불고기\"],\n" +
                                                    "    \"allergyWarnings\": [\"계란\"]\n" +
                                                    "  }\n" +
                                                    "}"
                                    )
                            )
                    ),
                    @ApiResponse(responseCode = "500", description = "서버 오류",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "서버 오류 예시",
                                            value = "{\n" +
                                                    "  \"success\": false,\n" +
                                                    "  \"message\": \"이미지 분석 중 오류 발생\",\n" +
                                                    "  \"data\": null\n" +
                                                    "}"
                                    )
                            )
                    )
            }
    )
    public ResponseEntity<CommonResponse<ImageAnalysisResultDto>> analyzeImage(@RequestBody ImageAnalysisRequestDto requestDto) {
        try {
            ImageAnalysisResultDto result = imageAnalysisService.analyzeImage(requestDto);
            return ResponseEntity.ok(
                    CommonResponse.<ImageAnalysisResultDto>builder()
                            .success(true)
                            .message("이미지 분석 성공")
                            .data(result)
                            .build()
            );
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(CommonResponse.<ImageAnalysisResultDto>builder()
                            .success(false)
                            .message("이미지 분석 중 오류 발생")
                            .data(null)
                            .build());
        }
    }

    @PostMapping("/translate")
    @Operation(
            summary = "이미지 번역",
            description = "이미지를 분석하여 번역된 메뉴 리스트를 반환합니다.",
            requestBody = @RequestBody(
                    required = true,
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = ImagePathRequestDto.class),
                            examples = @ExampleObject(
                                    name = "요청 예시",
                                    value = "{\n" +
                                            "  \"imagePath\": \"/api/gallery/images/uuid_filename.jpg\"\n" +
                                            "}"
                            )
                    )
            ),
            responses = {
                    @ApiResponse(responseCode = "200", description = "번역 성공",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "번역 결과 예시",
                                            value = "{\n" +
                                                    "  \"success\": true,\n" +
                                                    "  \"message\": \"메뉴 번역 성공\",\n" +
                                                    "  \"data\": {\n" +
                                                    "    \"translatedMenus\": [\"Kimchi Stew\", \"Bulgogi\"]\n" +
                                                    "  }\n" +
                                                    "}"
                                    )
                            )
                    ),
                    @ApiResponse(responseCode = "500", description = "서버 오류",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = CommonResponse.class),
                                    examples = @ExampleObject(
                                            name = "서버 오류 예시",
                                            value = "{\n" +
                                                    "  \"success\": false,\n" +
                                                    "  \"message\": \"메뉴 번역 중 오류 발생\",\n" +
                                                    "  \"data\": null\n" +
                                                    "}"
                                    )
                            )
                    )
            }
    )
    public ResponseEntity<CommonResponse<MenuTranslationResultDto>> translateImage(@RequestBody ImagePathRequestDto requestDto) {
        try {
            MenuTranslationResultDto result = imageAnalysisService.getTranslatedMenu(requestDto.getImagePath());
            return ResponseEntity.ok(
                    CommonResponse.<MenuTranslationResultDto>builder()
                            .success(true)
                            .message("메뉴 번역 성공")
                            .data(result)
                            .build()
            );
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(CommonResponse.<MenuTranslationResultDto>builder()
                            .success(false)
                            .message("메뉴 번역 중 오류 발생")
                            .data(null)
                            .build());
        }
    }
}
