package com.capstone.allergy.service;

import com.capstone.allergy.domain.Restaurant;
import com.capstone.allergy.domain.User;
import com.capstone.allergy.dto.RestaurantResponseDto;
import com.capstone.allergy.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class RestaurantService {

    private final RestaurantRepository restaurantRepository;

    public List<RestaurantResponseDto> getRecommendedPlaces(User user) {
        List<RestaurantResponseDto> result = new ArrayList<>();

        for (String food : user.getFavoriteFoods()) {
            restaurantRepository.findFirstByFoodName(food).ifPresent(restaurant -> {
                result.add(RestaurantResponseDto.builder()
                        .foodName(restaurant.getFoodName())
                        .restaurantName(restaurant.getRestaurantName())
                        .address(restaurant.getAddress())
                        .rating(restaurant.getRating())
                        .imageUrl(restaurant.getImageUrl())
                        .homepageUrl(restaurant.getHomepageUrl())
                        .build());
            });
        }

        return result;
    }
}
