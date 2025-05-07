//package com.capstone.allergy.client;
//
//import com.capstone.allergy.dto.UserPreferenceDto;
//import com.capstone.allergy.dto.RecommendedMenuDto;
//import lombok.RequiredArgsConstructor;
//import org.springframework.http.*;
//import org.springframework.stereotype.Component;
//import org.springframework.web.client.RestTemplate;
//
//import java.util.Arrays;
//import java.util.List;
//
//@Component
//@RequiredArgsConstructor
//public class AiRecommendClient {
//
//    private final RestTemplate restTemplate;
//
//    // TODO: 실제 AI 주소로 바꿔줘야 함
//    private final String AI_RECOMMENDATION_URL = "http://localhost:8000/api/recommend";
//
//    public List<RecommendedMenuDto> requestRecommendation(UserPreferenceDto preferences) {
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_JSON);
//
//        HttpEntity<UserPreferenceDto> request = new HttpEntity<>(preferences, headers);
//
//        ResponseEntity<RecommendedMenuDto[]> response = restTemplate.exchange(
//                AI_RECOMMENDATION_URL,
//                HttpMethod.POST,
//                request,
//                RecommendedMenuDto[].class
//        );
//
//        return Arrays.asList(response.getBody());
//    }
//}
