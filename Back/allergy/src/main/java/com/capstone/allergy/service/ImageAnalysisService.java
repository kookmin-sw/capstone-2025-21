package com.capstone.allergy.service;

import com.capstone.allergy.client.AiImageAnalysisClient;
import com.capstone.allergy.dto.ImageAnalysisRequestDto;
import com.capstone.allergy.dto.ImageAnalysisResultDto;
import com.capstone.allergy.dto.MenuTranslationResultDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ImageAnalysisService {

    private final AiImageAnalysisClient aiImageAnalysisClient;

    public ImageAnalysisResultDto analyzeImage(ImageAnalysisRequestDto requestDto) {
        return aiImageAnalysisClient.requestAnalysis(requestDto);
    }

    public MenuTranslationResultDto getTranslatedMenu(String imagePath) {
        return aiImageAnalysisClient.requestTranslation(imagePath);
    }
}
