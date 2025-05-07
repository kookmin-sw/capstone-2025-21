package com.capstone.allergy.repository;

import com.capstone.allergy.domain.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {
    Optional<Restaurant> findFirstByFoodName(String foodName);
}
