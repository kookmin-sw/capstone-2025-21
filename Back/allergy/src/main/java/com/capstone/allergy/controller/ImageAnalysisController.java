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
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClientException;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@RestController
@RequestMapping("/api/analysis")
@RequiredArgsConstructor
@Tag(name = "이미지 분석 API", description = "AI 기반 이미지 분석 및 번역 API")
@Slf4j
public class ImageAnalysisController {

    private final ImageAnalysisService imageAnalysisService;
    private final UserRepository userRepository;
    private final ImagePathCache imagePathCache;

    @Value("${app.base-url}")
    private String baseUrl;

    @Value("${file.upload-dir}")
    private String uploadDir;

    @PostMapping("/analyze-image")
    @Operation(
            summary = "이미지 분석 요청",
            description = """
            백엔드에서 사용자 정보를 조회하고, 최근 업로드된 이미지 경로를 이용해 AI 서버에 분석 요청을 보냅니다.
            
            ⚠️ 헤더 정보:
            - Authorization: Bearer {accessToken}
            - Content-Type: application/json
            """,
            security = @SecurityRequirement(name = "bearerAuth"),
            responses = {
                    @ApiResponse(responseCode = "200", description = "성공적으로 분석 요청 후 캐싱됨", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": true,
                        "message": "AI 분석 요청 성공 및 결과 캐싱 완료",
                        "data": "ok"
                    }
                    """))),
                    @ApiResponse(responseCode = "400", description = "요청 데이터 누락", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "업로드 된 이미지가 없습니다.",
                        "data": null
                    }
                    """))),
                    @ApiResponse(responseCode = "401", description = "인증 실패 또는 사용자 정보 없음", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "사용자 정보를 찾을 수 없습니다.",
                        "data": null
                    }
                    """))),
                    @ApiResponse(responseCode = "408", description = "AI 서버 응답 시간 초과", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "AI 서버 응답이 지연되어 시간 초과되었습니다.",
                        "data": null
                    }
                    """))),
                    @ApiResponse(responseCode = "500", description = "분석 요청 실패", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "AI 분석 중 내부 오류 발생: <오류 메시지>",
                        "data": null
                    }
                    """))),
                    @ApiResponse(responseCode = "502", description = "AI 서버 통신 오류", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "AI 서버와 통신 중 오류가 발생했습니다.",
                        "data": null
                    }
                    """)))
            }
    )
    public ResponseEntity<CommonResponse<String>> analyzeImageAndCache(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        Long userId = userDetails.getUser().getId();

        User user = userRepository.findById(userId)
                .orElse(null);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("사용자 정보를 찾을 수 없습니다.")
                            .data(null)
                            .build());
        }

        String imagePath = imagePathCache.getLatestImagePath(userId);
        if (imagePath == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("업로드된 이미지가 없습니다.")
                            .data(null)
                            .build());
        }

        try {
            // 파일 이름 추출
            String fileName = Paths.get(imagePath).getFileName().toString();

            // 로컬 절대 경로로 변환
            String localPath = Paths.get(uploadDir, fileName).toString();

            //String absolutePath = baseUrl + relativePath;
            log.info("[분석 요청] userId: {}, imagePath: {}", userId, localPath);

            ImageAnalysisRequestDto dto = new ImageAnalysisRequestDto();
            dto.setUserId(userId);
            dto.setNationality(imageAnalysisService.mapNationalityToLangCode(user.getNationality()));
            dto.setFavoriteFoods(user.getFavoriteFoods());
            dto.setAllergies(user.getAllergies());
            //dto.setImagePath(absolutePath);
            dto.setImagePath(localPath); // 로컬 경로 세팅

            imageAnalysisService.analyzeAndCache(dto, userId); // AI 서버 통신 중 예외 발생 가능

            return ResponseEntity.ok(
                    CommonResponse.<String>builder()
                            .success(true)
                            .message("AI 분석 요청 성공 및 결과 캐싱 완료")
                            .data("ok")
                            .build());
        } catch (ResourceAccessException e) {
            return ResponseEntity.status(HttpStatus.REQUEST_TIMEOUT)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("AI 서버 응답이 지연되어 시간 초과되었습니다.")
                            .data(null)
                            .build());
        } catch (HttpClientErrorException | HttpServerErrorException e) {
            return ResponseEntity.status(e.getStatusCode())
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("AI 서버 오류: " + e.getStatusText())
                            .data(null)
                            .build());
        } catch (RestClientException e) {
            return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("AI 서버와 통신 중 오류가 발생했습니다.")
                            .data(null)
                            .build());
        } catch (Exception e) {
            log.error("AI 분석 중 에러 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("AI 분석 중 내부 오류 발생: " + e.getMessage())
                            .data(null)
                            .build());
        }
    }

    @GetMapping("/analyze")
    @Operation(
            summary = "분석 결과 조회",
            description = """
            캐시에 저장된 분석 결과를 반환합니다.
            
            ⚠️ 헤더 정보:
            - Authorization: Bearer {accessToken}
            """,
            security = @SecurityRequirement(name = "bearerAuth"),
            responses = {
                    @ApiResponse(responseCode = "200", description = "분석 결과 조회 성공", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": true,
                        "message": "분석 결과 조회 성공",
                        "data": {
                            "recommendations": [
                                {
                                    "menu_name": "Squid",
                                    "similarity": 76.5
                                },
                                {
                                    "menu_name": "soju",
                                    "similarity": 39.3
                                }
                            ],
                            "allergen": {
                                "Pork": ["Kimchi Stew", "Tofu"],
                                "Peanuts": ["Octopus"]
                            }
                        }
                    }
                    """))),
                    @ApiResponse(responseCode = "404", description = "결과 없음", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "분석 결과가 존재하지 않습니다.",
                        "data": null
                    }
                    """))),
                    @ApiResponse(responseCode = "500", description = "서버 오류", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "서버 내부 오류 발생: <에러 메시지>",
                        "data": null
                    }
                    """)))
            }
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
                            .build());

        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(CommonResponse.<ImageAnalysisResultDto>builder()
                            .success(false)
                            .message(e.getMessage()) // "분석 결과가 존재하지 않습니다"
                            .data(null)
                            .build());

        } catch (Exception e) {
            log.error("분석 결과 조회 중 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(CommonResponse.<ImageAnalysisResultDto>builder()
                            .success(false)
                            .message("서버 내부 오류 발생: " + e.getMessage())
                            .data(null)
                            .build());
        }
    }

    @GetMapping("/translate")
    @Operation(
            summary = "번역 결과 조회",
            description = """
            캐시에 저장된 번역 결과를 반환합니다.
            
            ⚠️ 헤더 정보:
            - Authorization: Bearer {accessToken}
            """,
            security = @SecurityRequirement(name = "bearerAuth"),
            responses = {
                    @ApiResponse(responseCode = "200", description = "번역 결과 조회 성공", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": true,
                        "message": "번역 결과 조회 성공",
                        "data": {
                            "menu_items": [
                                {
                                    "menu_name": "Budaejjigae",
                                    "bbox": [
                                        [
                                            612.0,
                                            156.0
                                        ],
                                        [
                                            664.0,
                                            156.0
                                        ],
                                        [
                                            664.0,
                                            167.0
                                        ],
                                        [
                                            612.0,
                                            167.0
                                        ]
                                    ],
                                    "has_allergy": true,
                                    "allergy_types": [
                                        "Pork"
                                    ]
                                },
                                {
                                    "menu_name": "kimchi soup",
                                    "bbox": [
                                        [
                                            217.0,
                                            181.0
                                        ],
                                        [
                                            250.0,
                                            181.0
                                        ],
                                        [
                                            250.0,
                                            192.0
                                        ],
                                        [
                                            217.0,
                                            192.0
                                        ]
                                    ],
                                    "has_allergy": true,
                                    "allergy_types": [
                                        "Pork"
                                    ]
                                },
                                {
                                    "menu_name": "Tofu",
                                    "bbox": [
                                        [
                                            171.0,
                                            237.0
                                        ],
                                        [
                                            237.0,
                                            237.0
                                        ],
                                        [
                                            237.0,
                                            252.0
                                        ],
                                        [
                                            171.0,
                                            252.0
                                        ]
                                    ],
                                    "has_allergy": true,
                                    "allergy_types": [
                                        "Pork"
                                    ]
                                }
                            ]
                        }       
                    }
                    """))),
                    @ApiResponse(responseCode = "404", description = "번역 결과 없음", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "번역 결과가 존재하지 않습니다.",
                        "data": null
                    }
                    """))),
                    @ApiResponse(responseCode = "500", description = "서버 내부 오류", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "서버 내부 오류 발생: <에러 메시지>",
                        "data": null
                    }
                    """)))
            }
    )
    public ResponseEntity<CommonResponse<MenuTranslationResultDto>> getCachedTranslation(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        Long userId = userDetails.getUser().getId();

        try {
            MenuTranslationResultDto result = imageAnalysisService.getCachedTranslation(userId);
            return ResponseEntity.ok(
                    CommonResponse.<MenuTranslationResultDto>builder()
                            .success(true)
                            .message("번역 결과 조회 성공")
                            .data(result)
                            .build());
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(CommonResponse.<MenuTranslationResultDto>builder()
                            .success(false)
                            .message(e.getMessage()) // 번역 결과가 존재하지 않습니다.
                            .data(null)
                            .build());
        } catch (Exception e) {
            log.error("번역 결과 조회 중 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(CommonResponse.<MenuTranslationResultDto>builder()
                            .success(false)
                            .message("서버 내부 오류 발생: " + e.getMessage())
                            .data(null)
                            .build());
        }
    }

    @GetMapping("/translate-image")
    @Operation(
            summary = "번역 결과 이미지 반환",
            description = """
            번역된 메뉴 항목과 위치 정보 기반으로 텍스트가 그려진 이미지를 반환합니다.
            
            ⚠️ 헤더 정보:
            - Authorization: Bearer {accessToken}
            """,
            security = @SecurityRequirement(name = "bearerAuth"),
            responses = {
                    @ApiResponse(responseCode = "200", description = "번역 이미지 URL 반환 성공", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": true,
                        "message": "번역 이미지 생성 성공",
                        "data": "http://43.201.142.124:8080/uploads/translated_3.png"
                    }
                    """))),
                    @ApiResponse(responseCode = "404", description = "이미지 또는 번역 결과 없음", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "업로드된 이미지가 없거나 번역된 메뉴 결과가 없습니다.",
                        "data": null
                    }
                    """))),
                    @ApiResponse(responseCode = "500", description = "이미지 처리 중 오류 발생", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "이미지 처리 중 오류가 발생했습니다.",
                        "data": null
                    }
                    """)))
            }
    )
    public ResponseEntity<CommonResponse<String>> getTranslatedImage(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        Long userId = userDetails.getUser().getId();
        String imagePath = imagePathCache.getLatestImagePath(userId);

        if (imagePath == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("업로드된 이미지가 없습니다.")
                            .data(null)
                            .build());
        }

        try {
            String fileName = Paths.get(imagePath).getFileName().toString();
            Path fullPath = Paths.get(uploadDir).resolve(fileName);
            BufferedImage original = ImageIO.read(fullPath.toFile());

            if (original == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(CommonResponse.<String>builder()
                                .success(false)
                                .message("이미지를 읽을 수 없습니다. 손상되었거나 잘못된 파일입니다.")
                                .data(null)
                                .build());
            }

            BufferedImage output = new BufferedImage(original.getWidth(), original.getHeight(), BufferedImage.TYPE_INT_ARGB);
            Graphics2D g = output.createGraphics();

            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.6f));
            g.drawImage(original, 0, 0, null);

            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1.0f));
            g.setFont(new Font("SansSerif", Font.BOLD, 13));

            MenuTranslationResultDto result = imageAnalysisService.getCachedTranslation(userId);

            if (result == null || result.getMenuItems() == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(CommonResponse.<String>builder()
                                .success(false)
                                .message("번역된 메뉴 결과가 없습니다.")
                                .data(null)
                                .build());
            }

            for (MenuItemDto item : result.getMenuItems()) {
                String label = item.getMenuName();
                if (item.isHasAllergy() && item.getAllergyTypes() != null && !item.getAllergyTypes().isEmpty()) {
                    label += "(" + String.join(", ", item.getAllergyTypes()) + ")";
                }

                List<List<Double>> bbox = item.getBbox();
                int x = bbox.get(0).get(0).intValue();
                int y = bbox.get(0).get(1).intValue();

                FontMetrics fm = g.getFontMetrics();
                int textWidth = fm.stringWidth(label);
                int textHeight = fm.getHeight();

                g.setColor(new Color(255, 255, 255, 200));
                g.fillRect(x - 2, y - textHeight + 4, textWidth + 4, textHeight);

                g.setColor(item.isHasAllergy() ? Color.RED : Color.BLACK);
                g.drawString(label, x, y);
            }

            g.dispose();

            String outputFileName = "translated_" + userId + ".png";
            Path outputPath = Paths.get(uploadDir).resolve(outputFileName);
            ImageIO.write(output, "png", outputPath.toFile());

            String imageUrl = baseUrl + "/uploads/" + outputFileName;

            return ResponseEntity.ok(
                    CommonResponse.<String>builder()
                            .success(true)
                            .message("번역 이미지 생성 성공")
                            .data(imageUrl)
                            .build());
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message(e.getMessage()) // 번역된 메뉴 결과가 없습니다.
                            .data(null)
                            .build());
        } catch (IOException e) {
            log.error("이미지 처리 중 IOException", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("이미지 처리 중 오류가 발생했습니다.")
                            .data(null)
                            .build());
        } catch (Exception e) {
            log.error("예상치 못한 에러 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(CommonResponse.<String>builder()
                            .success(false)
                            .message("알 수 없는 서버 오류가 발생했습니다.")
                            .data(null)
                            .build());
        }
    }
}