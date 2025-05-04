package com.capstone.allergy.client;

import com.capstone.allergy.dto.ImageAnalysisRequestDto;
import com.capstone.allergy.dto.ImageAnalysisResultDto;
import com.capstone.allergy.dto.MenuTranslationResultDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestClientException;
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

        try {
            ResponseEntity<ImageAnalysisResultDto> response = restTemplate.exchange(
                    ANALYSIS_URL, HttpMethod.POST, request, ImageAnalysisResultDto.class
            );
            return response.getBody();
        } catch (HttpStatusCodeException e) {
            // AI 서버가 응답은 했지만 HTTP 오류 (예: 400, 500)
            throw new RuntimeException("AI 서버 오류 응답: " + e.getStatusCode() + " - " + e.getResponseBodyAsString());
        } catch (RestClientException e) {
            // AI 서버와 연결 자체가 안 되는 경우
            throw new RuntimeException("AI 서버에 연결할 수 없습니다. 서버가 실행 중인지 확인해주세요.");
        }
    }

    public MenuTranslationResultDto requestTranslation(String imagePath) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("imagePath", imagePath);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        try {
            ResponseEntity<MenuTranslationResultDto> response = restTemplate.exchange(
                    TRANSLATE_URL, HttpMethod.POST, request, MenuTranslationResultDto.class
            );
            return response.getBody();
        } catch (HttpStatusCodeException e) {
            throw new RuntimeException("AI 서버 오류 응답(번역): " + e.getStatusCode() + " - " + e.getResponseBodyAsString());
        } catch (RestClientException e) {
            throw new RuntimeException("AI 서버에 연결할 수 없습니다 (번역 요청). 서버가 실행 중인지 확인해주세요.");
        }
    }
}
