package com.capstone.allergy.service;

import com.capstone.allergy.client.AiImageAnalysisClient;
import com.capstone.allergy.domain.User;
import com.capstone.allergy.dto.*;
import com.capstone.allergy.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

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

    public String mapNationalityToLangCode(String nationality) {
        switch (nationality.toUpperCase()) {
            case "USA": return "en";
            case "JPN": return "ja";
            case "CHN": return "zh-cn";
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

    public void saveDummyResultToCache(Long userId,
                                       ImageAnalysisResultDto analyze,
                                       MenuTranslationResultDto translate) {
        analysisCache.put(userId, analyze);
        translationCache.put(userId, translate);
    }

    public ImageAnalysisResultDto createDummyAnalysis() {
        List<RecommendationsDto> recommendations = Arrays.asList(
                new RecommendationsDto("Squid", 0.765),
                new RecommendationsDto("soju", 0.393),
                new RecommendationsDto("drinkables", 0.386),
                new RecommendationsDto("beer", 0.366)
        );

        List<AllergenDto> allergenList = Arrays.asList(
                new AllergenDto("Pork", Arrays.asList("Budaejjigae", "kimchi soup", "Cheonggukjang", "Octopus", "Stir-fried")),
                new AllergenDto("Peanuts", Collections.singletonList("Octopus"))
        );

        return new ImageAnalysisResultDto(recommendations, allergenList);
    }

    public MenuTranslationResultDto createDummyTranslation() {
        List<MenuItemDto> menuItems = Arrays.asList(
                new MenuItemDto("Budaejjigae",
                        Arrays.asList(
                                Arrays.asList(612.0, 156.0),
                                Arrays.asList(664.0, 156.0),
                                Arrays.asList(664.0, 167.0),
                                Arrays.asList(612.0, 167.0)
                        ),
                        true,
                        Collections.singletonList("Pork")
                ),
                new MenuItemDto("kimchi soup",
                        Arrays.asList(
                                Arrays.asList(217.0, 181.0),
                                Arrays.asList(250.0, 181.0),
                                Arrays.asList(250.0, 192.0),
                                Arrays.asList(217.0, 192.0)
                        ),
                        true,
                        Collections.singletonList("Pork")
                ),
                new MenuItemDto("Tofu",
                        Arrays.asList(
                                Arrays.asList(171.0, 237.0),
                                Arrays.asList(237.0, 237.0),
                                Arrays.asList(237.0, 252.0),
                                Arrays.asList(171.0, 252.0)
                        ),
                        true,
                        Collections.singletonList("Pork")
                ),
                new MenuItemDto("Cheonggukjang",
                        Arrays.asList(
                                Arrays.asList(389.0, 237.0),
                                Arrays.asList(432.0, 237.0),
                                Arrays.asList(432.0, 252.0),
                                Arrays.asList(389.0, 252.0)
                        ),
                        true,
                        Collections.singletonList("Pork")
                ),
                new MenuItemDto("Octopus",
                        Arrays.asList(
                                Arrays.asList(611.0, 237.0),
                                Arrays.asList(664.0, 237.0),
                                Arrays.asList(664.0, 252.0),
                                Arrays.asList(611.0, 252.0)
                        ),
                        true,
                        Arrays.asList("Peanuts", "Pork")
                ),
                new MenuItemDto("Squid",
                        Arrays.asList(
                                Arrays.asList(168.0, 324.0),
                                Arrays.asList(237.0, 321.0),
                                Arrays.asList(237.0, 339.0),
                                Arrays.asList(169.0, 341.0)
                        ),
                        false,
                        Collections.emptyList()
                ),
                new MenuItemDto("Stir -fried",
                        Arrays.asList(
                                Arrays.asList(388.0, 323.0),
                                Arrays.asList(444.0, 323.0),
                                Arrays.asList(444.0, 341.0),
                                Arrays.asList(388.0, 341.0)
                        ),
                        true,
                        Collections.singletonList("Pork")
                ),
                new MenuItemDto("soju",
                        Arrays.asList(
                                Arrays.asList(206.0, 442.0),
                                Arrays.asList(233.0, 442.0),
                                Arrays.asList(233.0, 458.0),
                                Arrays.asList(206.0, 458.0)
                        ),
                        false,
                        Collections.emptyList()
                ),
                new MenuItemDto("beer",
                        Arrays.asList(
                                Arrays.asList(205.0, 464.0),
                                Arrays.asList(233.0, 464.0),
                                Arrays.asList(233.0, 479.0),
                                Arrays.asList(205.0, 479.0)
                        ),
                        false,
                        Collections.emptyList()
                ),
                new MenuItemDto("drinkables",
                        Arrays.asList(
                                Arrays.asList(321.0, 464.0),
                                Arrays.asList(348.0, 464.0),
                                Arrays.asList(348.0, 479.0),
                                Arrays.asList(321.0, 479.0)
                        ),
                        false,
                        Collections.emptyList()
                )
        );

        return new MenuTranslationResultDto(menuItems);
    }
}
