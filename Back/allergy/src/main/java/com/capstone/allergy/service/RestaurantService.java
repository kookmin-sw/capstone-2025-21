package com.capstone.allergy.service;

import com.capstone.allergy.domain.Restaurant;
import com.capstone.allergy.domain.User;
import com.capstone.allergy.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class RestaurantService {

    private final RestaurantRepository restaurantRepository;

    public List<Map<String, String>> getRecommendedPlaces(User user) {
        List<Map<String, String>> result = new ArrayList<>();

        for (String food : user.getFavoriteFoods()) {
            restaurantRepository.findFirstByFoodName(food).ifPresent(restaurant -> {
                Map<String, String> map = new HashMap<>();
                map.put("foodName", restaurant.getFoodName());
                map.put("restaurantName", restaurant.getRestaurantName());
                map.put("address", restaurant.getAddress());
                result.add(map);
            });
        }

        return result;
    }
}
