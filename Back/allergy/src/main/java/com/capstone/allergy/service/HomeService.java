//package com.capstone.allergy.service;
//
//import com.capstone.allergy.client.AiRecommendClient;
//import com.capstone.allergy.domain.User;
//import com.capstone.allergy.dto.HomeResponseDto;
//import com.capstone.allergy.dto.RecommendedMenuDto;
//import com.capstone.allergy.dto.UserPreferenceDto;
//import com.capstone.allergy.repository.UserRepository;
//import lombok.RequiredArgsConstructor;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//import java.util.stream.Collectors;
//
//@Service
//@RequiredArgsConstructor
//public class HomeService {
//
//    private final UserRepository userRepository;
//    private final AiRecommendClient aiRecommendClient;
//
//    public HomeResponseDto getRecommendedMenus(Long userId) {
//        // 유저 정보 조회
//        User user = userRepository.findById(userId)
//                .orElseThrow(() -> new RuntimeException("해당 사용자를 찾을 수 없습니다."));
//
//        // 유저 취향 DTO 구성
//        UserPreferenceDto preference = UserPreferenceDto.from(user);
//
//        // AI 서버로 추천 요청
//        List<RecommendedMenuDto> recommendedMenus = aiRecommendClient.requestRecommendation(preference);
//
//        // 음식 이름만 추출
//        List<String> menuNames = recommendedMenus.stream()
//                .map(RecommendedMenuDto::getName)
//                .collect(Collectors.toList());
//
//        // 응답 DTO 구성
//        return new HomeResponseDto(menuNames);
//    }
//}
