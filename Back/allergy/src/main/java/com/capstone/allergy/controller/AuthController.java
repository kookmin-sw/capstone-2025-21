package com.capstone.allergy.controller;

import com.capstone.allergy.domain.User;
import com.capstone.allergy.dto.LoginRequest;
import com.capstone.allergy.dto.SignupFullRequest;
import com.capstone.allergy.jwt.JwtTokenProvider;
import com.capstone.allergy.repository.UserRepository;
import com.capstone.allergy.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    // ✅ 회원가입
    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignupFullRequest request) {
        try {
            userService.registerUser(request);
            return ResponseEntity.ok("회원가입 성공!");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // ✅ 로그인
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        Optional<User> userOpt = userRepository.findByUsername(request.getUsername());

        if (userOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("아이디가 존재하지 않습니다.");
        }

        User user = userOpt.get();

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("비밀번호가 틀렸습니다.");
        }

        String token = jwtTokenProvider.createToken(user.getId().toString());

        // 원하면 user 정보도 일부 포함 가능
        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        response.put("userId", user.getId());
        response.put("username", user.getUsername());

        return ResponseEntity.ok(response);
    }
}