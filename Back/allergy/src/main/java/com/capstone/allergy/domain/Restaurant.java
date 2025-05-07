package com.capstone.allergy.domain;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "restaurants")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Restaurant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String foodName;     // 음식 이름

    private String restaurantName; // 맛집 이름

    private String address;       // 맛집 주소
}
