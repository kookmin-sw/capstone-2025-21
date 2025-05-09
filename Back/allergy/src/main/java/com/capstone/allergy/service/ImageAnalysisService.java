package com.capstone.allergy.service;

import com.capstone.allergy.client.AiImageAnalysisClient;
import com.capstone.allergy.domain.User;
import com.capstone.allergy.dto.ImageAnalysisRequestDto;
import com.capstone.allergy.dto.ImageAnalysisResultDto;
import com.capstone.allergy.dto.MenuTranslationResultDto;
import com.capstone.allergy.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ImageAnalysisService {

    private final AiImageAnalysisClient aiImageAnalysisClient;
    private final UserRepository userRepository;

    private final Map<Long, ImageAnalysisResultDto> analysisCache = new HashMap<>();
    private final Map<Long, MenuTranslationResultDto> translationCache = new HashMap<>();

    public void analyzeAndCache(ImageAnalysisRequestDto requestDto, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        requestDto.setUserId(userId);

        requestDto.setNationality(mapNationalityToLangCode(user.getNationality()));

        ImageAnalysisResultDto analysisResult = aiImageAnalysisClient.requestAnalysis(requestDto);
        MenuTranslationResultDto translationResult = aiImageAnalysisClient.requestTranslation(requestDto);

        analysisCache.put(userId, analysisResult);
        translationCache.put(userId, translationResult);
    }

    private String mapNationalityToLangCode(String nationality) {
        switch (nationality.toUpperCase()) {
            case "USA": return "en";
            case "JPN": return "jp";
            case "CHN": return "ch";
            default: return "ko"; // 기본값
        }
    }

    public ImageAnalysisResultDto getCachedAnalysis(Long userId) {
        if (!analysisCache.containsKey(userId)) {
            throw new RuntimeException("분석 결과가 존재하지 않습니다.");
        }
        return analysisCache.get(userId);
    }

    public MenuTranslationResultDto getCachedTranslation(Long userId) {
        if (!translationCache.containsKey(userId)) {
            throw new RuntimeException("번역 결과가 존재하지 않습니다.");
        }
        return translationCache.get(userId);
    }

//    public ImageAnalysisResultDto analyzeImage(ImageAnalysisRequestDto requestDto) {
//        return aiImageAnalysisClient.requestAnalysis(requestDto);
//    }
//
//    public MenuTranslationResultDto getTranslatedMenu(String imagePath) {
//        return aiImageAnalysisClient.requestTranslation(imagePath);
//    }
}
