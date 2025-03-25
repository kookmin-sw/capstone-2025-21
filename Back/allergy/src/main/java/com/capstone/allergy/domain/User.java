package com.capstone.allergy.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;     // 아이디

    private String password;     // 비밀번호 (BCrypt로 암호화할 예정)

    private String nationality;  // 국적

    @ElementCollection
    @CollectionTable(name = "user_favorite_foods", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "food")
    private List<String> favoriteFoods; // 좋아하는 한국 음식

    @ElementCollection
    @CollectionTable(name = "user_allergies", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "allergy")
    private List<String> allergies;     // 알러지

    private String spiceLevel;          // 맵기 정도 ("mild", "medium", "hot" 등)
}
