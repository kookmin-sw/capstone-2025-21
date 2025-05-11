package com.capstone.allergy.client;

import com.capstone.allergy.dto.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.FileSystemResource;
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

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
@Slf4j
public class AiImageAnalysisClient {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    private final String ANALYSIS_URL = "http://3.35.4.60:8000/analyze"; // 실제 엔드포인트로 수정
    private final String TRANSLATE_URL = "http://3.35.4.60:8000/analyze/menu";

    public ImageAnalysisResultDto requestAnalysis(ImageAnalysisRequestDto requestDto) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA); // 파일 전송

        MultiValueMap<String, Object> formData = new LinkedMultiValueMap<>();

        // 실제 파일 경로 (예: /home/ubuntu/uploads/abc.jpg)
        File imageFile = new File(requestDto.getImagePath());
        if (!imageFile.exists()) {
            throw new RuntimeException("이미지 파일이 존재하지 않습니다.: " + requestDto.getImagePath());
        }
        formData.add("imagePath", new FileSystemResource(imageFile)); // 바이너리 파일 첨부

        try {
            formData.add("userId", String.valueOf(requestDto.getUserId()));
            formData.add("nationality", requestDto.getNationality());
            formData.add("favoriteFoods", objectMapper.writeValueAsString(requestDto.getFavoriteFoods()));
            formData.add("allergies", objectMapper.writeValueAsString(requestDto.getAllergies()));

            log.info("Request payload: imageFile={}, userId={}, nationality={}, favFoods={}, allergies={}",
                    imageFile.getName(),
                    requestDto.getUserId(),
                    requestDto.getNationality(),
                    objectMapper.writeValueAsString(requestDto.getFavoriteFoods()),
                    objectMapper.writeValueAsString(requestDto.getAllergies())
            );

        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 실패", e);
        }

        HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(formData, headers);

        try {
            // AI 서버 응답을 Map으로 받기
            ResponseEntity<Map> response = restTemplate.exchange(
                    ANALYSIS_URL, HttpMethod.POST, request, Map.class
            );

            log.info("AI 분석 응답 raw JSON: {}", response.getBody());

            Map<String, Object> body = response.getBody();

            // recommendations 가공
            List<Map<String, Object>> recommendationRaw = (List<Map<String, Object>>) body.get("recommendations");
            List<RecommendationsDto> recommendations = recommendationRaw.stream()
                    .map(r -> new RecommendationsDto(
                            (String) r.get("menu_name"),
                            ((Number) r.get("similarity")).doubleValue()
                    )).collect(Collectors.toList());

            // allergen 가공: Map<String, List<String>> -> List<AllergenDto>
            Map<String, List<String>> rawAllergen = (Map<String, List<String>>) body.get("allergen");
            List<AllergenDto> allergenList = rawAllergen.entrySet().stream()
                    .map(entry -> new AllergenDto(entry.getKey(), entry.getValue()))
                    .collect(Collectors.toList());

            return new ImageAnalysisResultDto(recommendations, allergenList);
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
        headers.setContentType(MediaType.MULTIPART_FORM_DATA); // multipart 설정

        MultiValueMap<String, Object> formData = new LinkedMultiValueMap<>();

        File imageFile = new File(requestDto.getImagePath());
        if (!imageFile.exists()) {
            throw new RuntimeException("이미지 파일이 존재하지 않습니다: " + requestDto.getImagePath());
        }
        formData.add("imagePath", new FileSystemResource(imageFile));

        try {
            formData.add("userId", String.valueOf(requestDto.getUserId()));
            formData.add("nationality", requestDto.getNationality());
            formData.add("favoriteFoods", objectMapper.writeValueAsString(requestDto.getFavoriteFoods()));
            formData.add("allergies", objectMapper.writeValueAsString(requestDto.getAllergies()));

            log.info("Translation request: file={}, userId={}, nationality={}, foods={}, allergies={}",
                    imageFile.getName(),
                    requestDto.getUserId(),
                    requestDto.getNationality(),
                    objectMapper.writeValueAsString(requestDto.getFavoriteFoods()),
                    objectMapper.writeValueAsString(requestDto.getAllergies())
            );

        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 변환 실패", e);
        }

        HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(formData, headers);

//        try {
//            ResponseEntity<MenuTranslationResultDto> response = restTemplate.exchange(
//                    TRANSLATE_URL, HttpMethod.POST, request, MenuTranslationResultDto.class
//            );
//            return response.getBody();
        try {
            // 1. 먼저 응답을 문자열(String)로 받음
            ResponseEntity<String> response = restTemplate.exchange(
                    TRANSLATE_URL, HttpMethod.POST, request, String.class
            );

            // 2. 실제 응답 내용을 로그로 확인
            log.info("AI 응답 raw JSON: {}", response.getBody());

            // 3. JSON을 DTO로 파싱
            MenuTranslationResultDto dto = objectMapper.readValue(response.getBody(), MenuTranslationResultDto.class);
            return dto;

        } catch (HttpStatusCodeException e) {
            throw new RuntimeException("AI server error(translation): " + e.getStatusCode() + " - " + e.getResponseBodyAsString());
        } catch (RestClientException e) {
            throw new RuntimeException("Cannot connect to AI server (translation request). Check if the AI server is running.");
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 파싱 오류", e);
        }
    }
}
