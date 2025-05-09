package com.capstone.allergy.client;

import com.capstone.allergy.dto.ImageAnalysisRequestDto;
import com.capstone.allergy.dto.ImageAnalysisResultDto;
import com.capstone.allergy.dto.MenuTranslationResultDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;

import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
@Slf4j
public class AiImageAnalysisClient {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    private final String ANALYSIS_URL = "http://13.124.255.38:9000/analyze"; // 실제 엔드포인트로 수정
    private final String TRANSLATE_URL = "http://13.124.255.38:9000/analyze/menu";

    public ImageAnalysisResultDto requestAnalysis(ImageAnalysisRequestDto requestDto) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("imagePath", requestDto.getImagePath());
        formData.add("userId", String.valueOf(requestDto.getUserId()));
        formData.add("nationality", requestDto.getNationality());

        // 리스트를 JSON 문자열로 변환
        try {
            String favFoods = objectMapper.writeValueAsString(requestDto.getFavoriteFoods());
            String allergies = objectMapper.writeValueAsString(requestDto.getAllergies());

            // 전달되는 실제 데이터 확인
            log.info("Request payload: imagePath={}, userId={}, nationality={}, favFoods={}, allergies={}",
                    requestDto.getImagePath(),
                    requestDto.getUserId(),
                    requestDto.getNationality(),
                    favFoods,
                    allergies
            );

            formData.add("favoriteFoods", favFoods);
            formData.add("allergies", allergies);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 실패", e);
        }

        formData.add("top_k", "5");

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(formData, headers);

        try {
            ResponseEntity<ImageAnalysisResultDto> response = restTemplate.exchange(
                    ANALYSIS_URL, HttpMethod.POST, request, ImageAnalysisResultDto.class
            );
            return response.getBody();
        } catch (HttpStatusCodeException e) {
            // AI 서버가 응답은 했지만 HTTP 오류 (예: 400, 500)
            throw new RuntimeException("AI server error: " + e.getStatusCode() + " - " + e.getResponseBodyAsString());
        } catch (RestClientException e) {
            // AI 서버와 연결 자체가 안 되는 경우
            throw new RuntimeException("Cannot connect to AI server. Check if the AI server is running");
        }
    }

    public MenuTranslationResultDto requestTranslation(ImageAnalysisRequestDto requestDto) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("imagePath", requestDto.getImagePath());
        formData.add("userId", String.valueOf(requestDto.getUserId()));
        formData.add("nationality", requestDto.getNationality());

        try {
            formData.add("favoriteFoods", objectMapper.writeValueAsString(requestDto.getFavoriteFoods()));
            formData.add("allergies", objectMapper.writeValueAsString((requestDto.getAllergies())));
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 실패", e);
        }

        formData.add("top_k", "5");

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(formData, headers);

        try {
            ResponseEntity<MenuTranslationResultDto> response = restTemplate.exchange(
                    TRANSLATE_URL, HttpMethod.POST, request, MenuTranslationResultDto.class
            );
            return response.getBody();
        } catch (HttpStatusCodeException e) {
            throw new RuntimeException("AI server error(translation): " + e.getStatusCode() + " - " + e.getResponseBodyAsString());
        } catch (RestClientException e) {
            throw new RuntimeException("Cannot connect to AI server (translation request). Check if the AI server is running.");
        }
    }
}
