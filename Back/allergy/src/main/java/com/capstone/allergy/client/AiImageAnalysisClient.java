package com.capstone.allergy.client;

import com.capstone.allergy.dto.ImageAnalysisRequestDto;
import com.capstone.allergy.dto.ImageAnalysisResultDto;
import com.capstone.allergy.dto.MenuTranslationResultDto;
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
