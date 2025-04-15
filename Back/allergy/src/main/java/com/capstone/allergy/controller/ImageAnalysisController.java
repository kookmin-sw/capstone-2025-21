package com.capstone.allergy.controller;

import com.capstone.allergy.dto.ImageAnalysisResultDto;
import com.capstone.allergy.dto.MenuTranslationResultDto;
import com.capstone.allergy.service.ImageAnalysisService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/analysis")
@RequiredArgsConstructor
public class ImageAnalysisController {

    private final ImageAnalysisService imageAnalysisService;

    @PostMapping("/analyze")
    @Operation(summary = "이미지 분석", description = "알러지, 맵기 정도, 추천 메뉴를 분석합니다.")
    public ResponseEntity<ImageAnalysisResultDto> analyzeImage(
            @RequestParam String imagePath,
            @RequestParam Long userId
    ) {
        ImageAnalysisResultDto result = imageAnalysisService.analyzeImage(imagePath, userId);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/translate")
    @Operation(summary = "이미지 번역", description = "이미지에서 메뉴판을 번역합니다.")
    public ResponseEntity<MenuTranslationResultDto> translateImage(
            @RequestParam String imagePath
    ) {
        MenuTranslationResultDto result = imageAnalysisService.getTranslatedMenu(imagePath);
        return ResponseEntity.ok(result);
    }
}
