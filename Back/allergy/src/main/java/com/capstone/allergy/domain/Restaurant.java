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

    private String foodName;         // 음식 이름

    private String restaurantName;   // 맛집 이름

    private String address;          // 맛집 주소

    private Double rating;           // 맛집 평점 (예: 4.5)

    private String imageUrl;         // 맛집 대표 이미지 URL

    private String homepageUrl;      // 홈페이지 주소 (예: 구글 플레이스 링크)
}
