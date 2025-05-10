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
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
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

//    @Value("${app.base-url}")
//    private String baseUrl;

    @Value("${file.uplaod-dir}")
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
                    @ApiResponse(responseCode = "500", description = "분석 요청 실패", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "AI 요청 실패: 업로드된 이미지가 없습니다.",
                        "data": null
                    }
                    """)))
            }
    )
    public ResponseEntity<CommonResponse<String>> analyzeImageAndCache(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        try {
            Long userId = userDetails.getUser().getId();
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("사용자 정보를 찾을 수 없습니다."));

            String relativePath = imagePathCache.getLatestImagePath(userId);
            if (relativePath == null) {
                throw new RuntimeException("업로드된 이미지가 없습니다.");
            }

            // 파일 이름 추출
            String fileName = relativePath.substring(relativePath.lastIndexOf("/") + 1);

            // 로컬 절대 경로로 변환
            String localPath = uploadDir + File.separator + fileName;

            //String absolutePath = baseUrl + relativePath;
            log.info("[분석 요청] userId: {}, imagePath: {}", userId, localPath);

            ImageAnalysisRequestDto dto = new ImageAnalysisRequestDto();
            dto.setUserId(userId);
            dto.setNationality(user.getNationality());
            dto.setFavoriteFoods(user.getFavoriteFoods());
            dto.setAllergies(user.getAllergies());
            //dto.setImagePath(absolutePath);
            dto.setImagePath(localPath); // 로컬 경로 세팅

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
                            "allergyWarnings": ["새우", "땅콩"],
                            "recommendedMenus": ["비빔밥", "잡채"]
                        }
                    }
                    """))),
                    @ApiResponse(responseCode = "404", description = "결과 없음", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "분석 결과를 찾을 수 없습니다.",
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
                            "translatedMenus": [
                                {
                                    "original": "비빔밥",
                                    "translated": "Bibimbap"
                                },
                                {
                                    "original": "불고기",
                                    "translated": "Bulgogi"
                                }
                            ]
                        }
                    }
                    """))),
                    @ApiResponse(responseCode = "404", description = "결과 없음", content = @Content(
                            mediaType = "application/json",
                            examples = @ExampleObject(value = """
                    {
                        "success": false,
                        "message": "번역 결과를 찾을 수 없습니다.",
                        "data": null
                    }
                    """)))
            }
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

    @GetMapping("/translate-image")
    @Operation(
            summary = "번역 결과 이미지 반환",
            description = "번역된 메뉴 항목과 위치 정보 기반으로 텍스트가 그려진 이미지를 반환합니다.",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    public void getTranslatedImage(
            HttpServletResponse response,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        try {
            Long userId = userDetails.getUser().getId();
            String imagePath = imagePathCache.getLatestImagePath(userId);  // 예: /api/gallery/images/abc.png

            if (imagePath == null) {
                throw new RuntimeException("업로드된 이미지가 없습니다.");
            }

            // 실제 로컬 경로로 변환
            String fileName = Paths.get(imagePath).getFileName().toString(); // abc.png
            Path fullPath = Paths.get(uploadDir).resolve(fileName);
            BufferedImage original = ImageIO.read(fullPath.toFile());

            // ARGB 이미지로 복사 및 투명도 처리
            BufferedImage output = new BufferedImage(original.getWidth(), original.getHeight(), BufferedImage.TYPE_INT_ARGB);
            Graphics2D g = output.createGraphics();
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1.6f));
            g.drawImage(original, 0, 0, null);

            // 텍스트용 설정
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1.0f));
            g.setFont(new Font("SansSerif", Font.BOLD, 15));

            // 번역 결과 꺼내기
            MenuTranslationResultDto result = imageAnalysisService.getCachedTranslation(userId);
            if (result == null || result.getMenuItems() == null) {
                throw new RuntimeException("번역된 메뉴 결과가 없습니다.");
            }

            for (MenuItemDto item : result.getMenuItems()) {
                String label = item.getMenuName();
                if (item.isHasAllergy()) {
                    label += "⚠";
                }

                List<List<Double>> bbox = item.getBbox();
                int x = bbox.get(0).get(0).intValue();
                int y = bbox.get(0).get(1).intValue();

                FontMetrics fm = g.getFontMetrics();
                int textWidth = fm.stringWidth(label);
                int textHeight = fm.getHeight();

                g.setColor(new Color(255, 255, 255, 200)); // 반투명 흰 배경
                g.fillRect(x - 2, y - textHeight + 4, textWidth + 4, textHeight);

                g.setColor(item.isHasAllergy() ? Color.RED : Color.BLACK);
                g.drawString(label, x, y);
            }

            g.dispose();

            response.setContentType("image/png");
            OutputStream os = response.getOutputStream();
            ImageIO.write(output, "png", os);
            os.close();

        } catch (Exception e) {
            log.error("번역 이미지 생성 중 오류: {}", e.getMessage(), e);
            response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
        }
    }
}


//@RestController
//@RequestMapping("/api/analysis")
//@RequiredArgsConstructor
//@Tag(name = "이미지 분석 API", description = "AI 기반 이미지 분석 및 번역 API")
//@Slf4j
//public class ImageAnalysisController {
//
//    private final ImageAnalysisService imageAnalysisService;
//    private final UserRepository userRepository;
//    private final ImagePathCache imagePathCache;
//
//    @Value("${app.base-url}")
//    private String baseUrl;
//
//    @PostMapping("/analyze-image")
//    @Operation(
//            summary = "이미지 분석 요청",
//            description = "백엔드에서 사용자 정보를 조회하고, 최근 업로드된 이미지 경로를 이용해 AI 서버에 분석 요청을 보냅니다.",
//            security = @SecurityRequirement(name = "bearerAuth")
//    )
//    public ResponseEntity<CommonResponse<String>> analyzeImageAndCache(
//            @AuthenticationPrincipal CustomUserDetails userDetails
//    ) {
//        try {
//            Long userId = userDetails.getUser().getId();
//            User user = userRepository.findById(userId)
//                            .orElseThrow(() -> new RuntimeException("사용자 정보를 찾을 수 없습니다."));
//
//            String relativePath = imagePathCache.getLatestImagePath(userId);
//            if (relativePath == null) {
//                throw new RuntimeException("업로드된 이미지가 없습니다.");
//            }
//
//            String absolutePath = baseUrl + relativePath;
//            log.info("[분석 요청] userId: {}, imagePath: {}", userId, absolutePath);
//
//            ImageAnalysisRequestDto dto = new ImageAnalysisRequestDto();
//            dto.setUserId(userId);
//            dto.setNationality(user.getNationality());
//            dto.setFavoriteFoods(user.getFavoriteFoods());
//            dto.setAllergies(user.getAllergies());
//            dto.setImagePath(absolutePath);
//
//            imageAnalysisService.analyzeAndCache(dto, userId);
//
//            return ResponseEntity.ok(
//                    CommonResponse.<String>builder()
//                            .success(true)
//                            .message("AI 분석 요청 성공 및 결과 캐싱 완료")
//                            .data("ok")
//                            .build()
//            );
//        } catch (RuntimeException e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(CommonResponse.<String>builder()
//                            .success(false)
//                            .message("AI 요청 실패: " + e.getMessage())
//                            .data(null)
//                            .build());
//        }
//    }
//
//    @GetMapping("/analyze")
//    @Operation(
//            summary = "분석 결과 조회",
//            description = "캐시에 저장된 분석 결과를 반환합니다."
//    )
//    public ResponseEntity<CommonResponse<ImageAnalysisResultDto>> getCachedAnalysis(
//            @AuthenticationPrincipal CustomUserDetails userDetails
//    ) {
//        try {
//            Long userId = userDetails.getUser().getId();
//            ImageAnalysisResultDto result = imageAnalysisService.getCachedAnalysis(userId);
//            return ResponseEntity.ok(
//                    CommonResponse.<ImageAnalysisResultDto>builder()
//                            .success(true)
//                            .message("분석 결과 조회 성공")
//                            .data(result)
//                            .build()
//            );
//        } catch (RuntimeException e) {
//            return ResponseEntity.status(HttpStatus.NOT_FOUND)
//                    .body(CommonResponse.<ImageAnalysisResultDto>builder()
//                            .success(false)
//                            .message(e.getMessage())
//                            .data(null)
//                            .build());
//        }
//    }
//
//    @GetMapping("/translate")
//    @Operation(
//            summary = "번역 결과 조회",
//            description = "캐시에 저장된 번역 결과를 반환합니다."
//    )
//    public ResponseEntity<CommonResponse<MenuTranslationResultDto>> getCachedTranslation(
//            @AuthenticationPrincipal CustomUserDetails userDetails
//    ) {
//        try {
//            Long userId = userDetails.getUser().getId();
//            MenuTranslationResultDto result = imageAnalysisService.getCachedTranslation(userId);
//            return ResponseEntity.ok(
//                    CommonResponse.<MenuTranslationResultDto>builder()
//                            .success(true)
//                            .message("번역 결과 조회 성공")
//                            .data(result)
//                            .build()
//            );
//        } catch (RuntimeException e) {
//            return ResponseEntity.status(HttpStatus.NOT_FOUND)
//                    .body(CommonResponse.<MenuTranslationResultDto>builder()
//                            .success(false)
//                            .message(e.getMessage())
//                            .data(null)
//                            .build());
//        }
//    }
//}
