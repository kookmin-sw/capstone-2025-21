package com.capstone.allergy.client;

import com.capstone.allergy.dto.ImageAnalysisRequestDto;
import com.capstone.allergy.dto.ImageAnalysisResultDto;
import com.capstone.allergy.dto.MenuTranslationResultDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;

import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class AiImageAnalysisClient {

    private final RestTemplate restTemplate;

    private final String ANALYSIS_URL = "http://localhost:8000/api/analyze"; // 실제 엔드포인트로 수정
    private final String TRANSLATE_URL = "http://localhost:8000/api/translate";

    public ImageAnalysisResultDto requestAnalysis(ImageAnalysisRequestDto requestDto) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<ImageAnalysisRequestDto> request = new HttpEntity<>(requestDto, headers);

        ResponseEntity<ImageAnalysisResultDto> response = restTemplate.exchange(
                ANALYSIS_URL, HttpMethod.POST, request, ImageAnalysisResultDto.class
        );

        return response.getBody();
    }

    public MenuTranslationResultDto requestTranslation(String imagePath) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("imagePath", imagePath);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        ResponseEntity<MenuTranslationResultDto> response = restTemplate.exchange(
                TRANSLATE_URL, HttpMethod.POST, request, MenuTranslationResultDto.class
        );

        return response.getBody();
    }
}
