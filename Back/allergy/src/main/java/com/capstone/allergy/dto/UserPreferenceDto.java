package com.capstone.allergy.dto;

import com.capstone.allergy.domain.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserPreferenceDto {
    private List<String> favoriteFoods;
    private List<String> allergies;
//    private String spiceLevel; // ✅ String으로 수정

    public static UserPreferenceDto from(User user) {
        return new UserPreferenceDto(
                user.getFavoriteFoods(),
                user.getAllergies()
//                user.getSpiceLevel()
        );
    }
}
