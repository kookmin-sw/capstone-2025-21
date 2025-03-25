package com.capstone.allergy.service;

import com.capstone.allergy.domain.User;
import com.capstone.allergy.dto.SignupFullRequest;
import com.capstone.allergy.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public void registerUser(SignupFullRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        User user = User.builder()
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .nationality(request.getNationality())
                .favoriteFoods(request.getFavoriteFoods())
                .allergies(request.getAllergies())
                .spiceLevel(request.getSpiceLevel())
                .build();

        userRepository.save(user);
    }
}
